// lib/services/auth_api.dart
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
  final Map<String, dynamic>? data; // carry whole payload if you need (e.g., loginData)
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
  AuthApi({http.Client? client}) : _client = client ?? http.Client();

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

  void _log(Uri url, http.BaseResponse res, [String method = 'REQ']) {
    print('$method $url -> ${res.statusCode} ${(res as dynamic).reasonPhrase ?? ''}');
    if (res is http.Response) {
      print(res.body);
    }
  }

  // ---------------- LOGIN ----------------
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final url = _buildUri('public/login');
    try {
      final res = await _client
          .post(url, headers: _jsonHeaders, body: jsonEncode({'email': email, 'password': password}))
          .timeout(const Duration(seconds: 20));
      _log(url, res, 'POST');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Login failed');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // -------------- OTP: SEND --------------
  Future<ApiResponse> sendOtp(String number) async {
    final url = _buildUri('public/otp/send/$number');
    try {
      // Most backends with path params don't need a body:
      final res = await _client
          .put(url, headers: _headersNoBody)
          .timeout(const Duration(seconds: 20));



      _log(url, res, 'PUT');
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to send OTP');
    } on SocketException catch (e) {
      throw ApiException(null, 'Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException(null, 'Bad response format: ${e.message}');
    }
  }

  // ------------- OTP: VERIFY -------------
  Future<ApiResponse> verifyOtp(String number, String otp) async {
    final url = _buildUri('public/otp/verify/$number/$otp');
    final res = await _client
        .put(url, headers: _headersNoBody)
        .timeout(const Duration(seconds: 20));
    _log(url, res, 'PUT');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to verify OTP');
  }

  // ----------- PASSWORD: RESET -----------
  Future<ApiResponse> resetPassword(String number, String otp, String password) async {
    final url = _buildUri('public/reset/password/$number/$otp/$password');
    final res = await _client
        .put(url, headers: _headersNoBody)
        .timeout(const Duration(seconds: 20));
    _log(url, res, 'PUT');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ApiResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw ApiException(res.statusCode, res.body.isNotEmpty ? res.body : 'Failed to reset password');
  }
}
