import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:new_project/utils/ApiConstants.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException(${statusCode ?? 'no-status'}): $message';
}

class ApiResponse {
  final String message;
  final String status;
  final Map<String, dynamic>?
  data; // carry whole payload if you need (e.g., loginData)
  bool get isSuccess => status.toLowerCase() == 'success';

  ApiResponse({required this.message, required this.status, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: (json['message'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      data: json,
    );
  }
}

class AuthApi {
  final http.Client _client;
  String? _token; // <-- store bearer for non-public APIs

  AuthApi({http.Client? client, String? token})
    : _client = client ?? http.Client(),
      _token = token;

  /// Set/replace the bearer token after login.
  void setAuthToken(String? token) => _token = token;

  Uri _buildUri(String path) {
    final base = Uri.parse(Constants.ipBaseUrl);
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: path,
    );
  }

  Map<String, String> get _jsonHeaders => const {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Map<String, String> get _headersNoBody => const {
    'Accept': 'application/json',
  };

  /// Require a non-empty token for all non-public (admin/...) endpoints
  String _requireToken() {
    final t = _token;
    if (t == null || t.isEmpty) {
      throw ApiException(
        null,
        'Missing auth token. Call setAuthToken(...) after login.',
      );
    }
    return t;
  }

  Map<String, String> _jsonAuthHeaders() {
    final t = _requireToken();
    return {..._jsonHeaders, 'Authorization': 'Bearer $t'};
  }

  void _log(Uri url, http.BaseResponse res, [String method = 'REQ']) {
    print(
      '$method $url -> ${res.statusCode} ${(res as dynamic).reasonPhrase ?? ''}',
    );
    if (res is http.Response) {
      print(res.body);
    }
  }

  // ---------------- PUBLIC: LOGIN ----------------
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final url = _buildUri('public/login');
    try {
      final res = await _client
          .post(
            url,
            headers: _jsonHeaders,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 20));
      _log(url, res, 'POST');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Login failed',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- PUBLIC: OTP SEND ----------------
  Future<ApiResponse> sendOtp(String number) async {
    final url = _buildUri('public/otp/send/$number');
    try {
      final res = await _client
          .put(url, headers: _headersNoBody)
          .timeout(const Duration(seconds: 20));
      _log(url, res, 'PUT');
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to send OTP',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- PUBLIC: OTP VERIFY ----------------
  Future<ApiResponse> verifyOtp(String number, String otp) async {
    final url = _buildUri('public/otp/verify/$number/$otp');
    final res = await _client
        .put(url, headers: _headersNoBody)
        .timeout(const Duration(seconds: 20));
    _log(url, res, 'PUT');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw ApiException(
      res.statusCode,
      res.body.isNotEmpty ? res.body : 'Failed to verify OTP',
    );
  }

  // -------------- PUBLIC: PASSWORD RESET --------------
  Future<ApiResponse> resetPassword(
    String number,
    String otp,
    String password,
  ) async {
    final url = _buildUri('public/reset/password/$number/$otp/$password');
    final res = await _client
        .put(url, headers: _headersNoBody)
        .timeout(const Duration(seconds: 20));
    _log(url, res, 'PUT');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw ApiException(
      res.statusCode,
      res.body.isNotEmpty ? res.body : 'Failed to reset password',
    );
  }

  // ================== ADMIN (TOKEN REQUIRED) ==================

  // ---------------- BRANCH: CREATE ----------------
  Future<ApiResponse> createBranch({
    required String branchName,
    required String location,
  }) async {
    final url = _buildUri('admin/branch/save');
    try {
      final body = jsonEncode({'branchName': branchName, 'location': location});

      final res = await _client
          .post(url, headers: _jsonAuthHeaders(), body: body)
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'POST');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to create branch',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ------------- AGENT (MOBILE): CREATE -------------
  Future<ApiResponse> createAgentMobile({
    required String name,
    required String email,
    required String contactNumber,
    required double totalAmount,
    required int ventureId,
    required int agentReferalId,
    required String address,
    required String aadharNo,
    required String bankName,
    required String accountNo,
    required String ifscCode,
    required int branchId,
    required String otherName,
    required String accountHolderName,
    required String panNo,
    required int count,
  }) async {
    final url = _buildUri('admin/agent/mobile/save');
    try {
      final payload = {
        'name': name,
        'email': email,
        'contactNumber': contactNumber,
        'totalAmount': totalAmount,
        'ventureId': ventureId,
        'agentReferalId': agentReferalId,
        'address': address,
        'aadharNo': aadharNo,
        'bankName': bankName,
        'accountNo': accountNo,
        'ifscCode': ifscCode,
        'branchId': branchId,
        'otherName': otherName,
        'accountHolderName': accountHolderName,
        'panNo': panNo,
        'count': count,
      };

      final res = await _client
          .post(url, headers: _jsonAuthHeaders(), body: jsonEncode(payload))
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'POST');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to create agent',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- BRANCH: VIEW ----------------
  Future<ApiResponse> getBranchDetails() async {
    final url = _buildUri(
      'admin/branch/view',
    ).replace(queryParameters: {'branch': 'branchDetails'});

    try {
      final res = await _client
          .get(url, headers: _jsonAuthHeaders())
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to fetch branch details',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- DASHBOARD (treeDetails) ----------------
  Future<ApiResponse> getAgentDashboard() async {
    final url = _buildUri('agent/mobile/dashboard');
    try {
      final res = await _client
          .get(url, headers: _jsonAuthHeaders())
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to fetch dashboard',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- AGENT: VIEW ----------------
  Future<ApiResponse> getAgentDetails() async {
    final url = _buildUri(
      'agent/view/all/mobile',
    ).replace(queryParameters: {'agent': 'agentDetails'});

    try {
      final res = await _client
          .get(url, headers: _jsonAuthHeaders())
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to fetch agent details',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- WITHDRAWL: VIEW ----------------
  Future<ApiResponse> getWithdrawlDetails() async {
    final url = _buildUri(
      'agent/withdrawl/view/mobile',
    ).replace(queryParameters: {'withdrawl': 'withdrawlDetails'});

    try {
      final res = await _client
          .get(url, headers: _jsonAuthHeaders())
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to fetch agent details',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- WITHDRAWL: VIEW PENDING ----------------
  Future<ApiResponse> getWithdrawlPendingDetails() async {
    final url = _buildUri(
      'agent/withdrawl/view/mobile/pending',
    ).replace(queryParameters: {'withdrawl': 'withdrawlDetails'});

    try {
      final res = await _client
          .get(url, headers: _jsonAuthHeaders())
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to fetch withdrawl details',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- WITHDRAWL: UPDATE STATUS ----------------
  Future<ApiResponse> updateWithdrawlStatus({
    required int id,
    required String status,
    String? referenceNumber,
    String? paymentDate,
    String? paymentMode,
    String? reason,
  }) async {
    final url = _buildUri('agent/withdrawl/status/mobile/$id');

    final Map<String, dynamic> body = {'status': status};

    if (status.toLowerCase() == 'paid') {
      body['referenceNumber'] = (referenceNumber ?? '').trim();
      body['paymentDate'] = (paymentDate ?? '').trim();
      body['paymentMode'] = (paymentMode ?? '').trim();
    } else if (status.toLowerCase() == 'cancelled') {
      body['reason'] = (reason ?? '').trim();
    }

    try {
      final res = await _client
          .put(url, headers: _jsonAuthHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'PUT');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to update withdrawl status',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- VENTURE: VIEW ----------------
  Future<ApiResponse> getVentureDetails() async {
    final url = _buildUri(
      'admin/venture/mobile/view',
    ).replace(queryParameters: {'venture': 'ventureDetails'});

    try {
      final res = await _client
          .get(url, headers: _jsonAuthHeaders())
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to fetch venture details',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------------- COMMISSION LEVEL TREE: VIEW ----------------
  // Future<ApiResponse> getCommissionLevels({required int id}) async {
  //   final url = _buildUri('agent/mobile/commision/level/$id');
  //
  //   try {
  //     final res = await _client
  //         .get(url, headers: _jsonAuthHeaders())
  //         .timeout(const Duration(seconds: 20));
  //
  //     _log(url, res, 'GET');
  //
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       return ApiResponse.fromJson(
  //         jsonDecode(res.body) as Map<String, dynamic>,
  //       );
  //     }
  //     throw ApiException(
  //       res.statusCode,
  //       res.body.isNotEmpty ? res.body : 'Failed to fetch commission levels',
  //     );
  //   } on SocketException catch (e) {
  //     throw ApiException(null, 'Network error: ${e.message}');
  //   } on FormatException catch (e) {
  //     throw ApiException(null, 'Bad response format: ${e.message}');
  //   }
  // }

  // ---------------- REFERRAL LEVELS (UP TO 5) ----------------
  Future<ApiResponse> getReferralLevels({required int agentId}) async {
    final url = _buildUri(
      'agent/mobile/commision/level/$agentId',
    ).replace(queryParameters: {'tree': 'treeDetails'});

    try {
      final res = await _client
          .get(url, headers: _jsonAuthHeaders())
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to fetch referral levels',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ---------- NEW: UPDATE AGENT ----------
  Future<ApiResponse> updateAgentMobile({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final url = _buildUri('agent/update/mobile/$id');

    try {
      final res = await _client
          .put(url, headers: _jsonAuthHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'PUT');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to update agent',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  Future<ApiResponse> updateVentureMobile({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final url = _buildUri('admin/venture/mobile/update/$id');
    try {
      final res = await _client
          .put(url, headers: _jsonAuthHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));
      _log(url, res, 'PUT');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to update venture',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  Future<ApiResponse> updateBranchMobile({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final url = _buildUri('admin/branch/update/$id');
    try {
      final res = await _client
          .put(url, headers: _jsonAuthHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'PUT');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to update branch',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ------------- VENTURE (MOBILE): CREATE -------------
  Future<ApiResponse> createVentureMobile({
    required String ventureName,
    required String location,
    required String status,
    required int totalTrees,
    required int treesSold,
  }) async {
    final url = _buildUri('admin/venture/mobile/save');
    try {
      final payload = {
        'ventureName': ventureName,
        'location': location,
        'status': status,
        'totalTrees': totalTrees,
        'treesSold': treesSold,
      };

      final res = await _client
          .post(url, headers: _jsonAuthHeaders(), body: jsonEncode(payload))
          .timeout(const Duration(seconds: 20));

      _log(url, res, 'POST');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      throw ApiException(
        res.statusCode,
        res.body.isNotEmpty ? res.body : 'Failed to create venture',
      );
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }




  // ---------------- VIEW AGENT PROFILE ----------------
  Future<ApiResponse> viewAgentProfile({
    required String agentId,
    required String token,
  }) async {
    final url = _buildUri('agent/view/mobile/$agentId');
    try {
      final res = await _client
          .get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      })
          .timeout(const Duration(seconds: 20));
      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to load profile');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }


  // ---------------- UPDATE AGENT PROFILE ----------------
  Future<ApiResponse> updateAgentProfile({
    required String agentId,
    required String token,
    required Map<String, dynamic> updateData,
  }) async {
    final url = _buildUri('agent/update/mobile/$agentId');
    try {
      final res = await _client
          .put(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }, body: jsonEncode(updateData))
          .timeout(const Duration(seconds: 20));
      _log(url, res, 'PUT');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to update profile');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

// ------------------ GET AGENT BALANCE ------------------
  Future<ApiResponse> fetchBalance({
    required String agentId,
    required String token,
  }) async {
    final url = _buildUri('agent/withdrawl/balance/mobile/$agentId'); // Keep URL if backend uses 'withdrawl'

    try {
      final res = await _client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body));
      }

      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to fetch balance');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

// ------------------ GET AGENT WITHDRAWAL HISTORY ------------------
  Future<ApiResponse> fetchWithdrawalHistory({
    required String agentId,
    required String token,
  }) async {
    final url = _buildUri('agent/withdrawl/view/mobile/$agentId');

    try {
      final res = await _client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body));
      }

      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to fetch withdrawal history');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

// ------------------ POST AGENT WITHDRAWAL REQUEST ------------------
  Future<ApiResponse> requestWithdrawal({
    required String agentId,
    required String token,
    required double amount,
  }) async {
    final url = _buildUri('agent/withdrawl/save/mobile');

    final body = {
      "agentId": agentId,
      "withdrawlAmount": amount,
    };

    try {
      final res = await _client.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 20));

      _log(url, res, 'POST');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body));
      }

      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to request withdrawal');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ------------------ GET AGENT NETWORK LEVEL  ------------------
  Future<ApiResponse> fetchCommissionLevel({
    required String token,
    required String agentId,
  }) async {
    final url = _buildUri('agent/mobile/commision/level/$agentId');

    try {
      final res = await _client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body));
      }

      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to fetch Network data');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }


// ------------------ GET AGENT COMMISION REPORT  ------------------

  Future<ApiResponse> fetchAgentCommissionReport({
    required String token,
    required String agentId,
  }) async {
    final url = _buildUri('agent/commision/view/mobile/$agentId');

    try {
      final res = await _client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      _log(url, res, 'GET');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body));
      }

      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to fetch Commission Report');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

}
