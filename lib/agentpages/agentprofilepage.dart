import 'package:flutter/material.dart';
import '../utils/AuthApi.dart';
import 'mainpage.dart';

class ProfilePage extends StatelessWidget {
  final String agentId;
  final String token;

  const ProfilePage({Key? key, required this.agentId, required this.token})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileBody(agentId: agentId, token: token);
  }
}

class ProfileBody extends StatefulWidget {
  final String agentId;
  final String token;

  const ProfileBody({Key? key, required this.agentId, required this.token})
    : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, dynamic>? _agentDetail;

  @override
  void initState() {
    super.initState();
    _fetchAgentDetail();
  }

  Future<void> _fetchAgentDetail() async {
    try {
      final api = AuthApi();
      final ApiResponse resp = await api.viewAgentProfile(
        agentId: widget.agentId,
        token: widget.token,
      );

      if (resp.isSuccess) {
        final data = resp.data;
        if (data != null && data.containsKey('agentDetails')) {
          final arr = data['agentDetails'] as List;
          if (arr.isNotEmpty) {
            setState(() {
              _agentDetail = Map<String, dynamic>.from(arr.first as Map);
              _isLoading = false;
            });
          } else {
            setState(() {
              _errorMessage = "No agent details found";
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = "Invalid response structure";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = resp.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ================== EDIT DIALOG ==================
  void showUserFormDialog(BuildContext ctx) {
    if (_agentDetail == null) return;

    // controllers seeded from current detail
    final nameController = TextEditingController(
      text: _agentDetail!['name']?.toString() ?? '',
    );
    final otherNameController = TextEditingController(
      text: _agentDetail!['otherName']?.toString() ?? '',
    );
    final fatherNameController = TextEditingController(
      text: _agentDetail!['fatherName']?.toString() ?? '',
    );
    final emailController = TextEditingController(
      text: _agentDetail!['email']?.toString() ?? '',
    );
    final mobileController = TextEditingController(
      text: _agentDetail!['contactNumber']?.toString() ?? '',
    );
    final pancardController = TextEditingController(
      text: _agentDetail!['panNo']?.toString() ?? '',
    );
    final aadharController = TextEditingController(
      text: _agentDetail!['aadharNo']?.toString() ?? '',
    );
    final accountnumController = TextEditingController(
      text: _agentDetail!['accountNo']?.toString() ?? '',
    );
    final ifsccodeController = TextEditingController(
      text: _agentDetail!['ifscCode']?.toString() ?? '',
    );

    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black54),
                          iconSize: 20,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Edit Your Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Modify your personal and bank details. Critical changes will require OTP verification.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 14.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildField("Name", nameController),
                              const SizedBox(height: 10),
                              _buildField("Other's Name", otherNameController),
                              const SizedBox(height: 10),
                              _buildField(
                                "Father's Name",
                                fatherNameController,
                              ),
                              const SizedBox(height: 10),
                              _buildField(
                                "Email (Cannot be changed)",
                                emailController,
                                enabled: false,
                              ),
                              const SizedBox(height: 10),
                              _buildField("Mobile", mobileController),
                              const SizedBox(height: 10),
                              _buildField("PAN Card", pancardController),
                              const SizedBox(height: 10),
                              _buildField("Aadhar Number", aadharController),
                              const SizedBox(height: 10),
                              _buildField(
                                "Bank Account Number",
                                accountnumController,
                              ),
                              const SizedBox(height: 10),
                              _buildField("IFSC Code", ifsccodeController),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed: () async {
                                    // build update body: keep both otherName and fatherName
                                    final Map<String, dynamic> body = {
                                      "name": nameController.text,
                                      "aadharNo": aadharController.text,
                                      "address": _agentDetail!['address'] ?? "",
                                      "bankName":
                                          _agentDetail!['bankName'] ?? "",
                                      "ifscCode": ifsccodeController.text,
                                      "accountNo": accountnumController.text,
                                      "accountHolderName": nameController.text,
                                      "otherName": otherNameController.text,
                                      // distinct
                                      "fatherName": fatherNameController.text,
                                      // NEW field
                                      "panNo": pancardController.text,
                                    };

                                    try {
                                      final api = AuthApi();
                                      final ApiResponse resp = await api
                                          .updateAgentProfile(
                                            agentId: widget.agentId,
                                            token: widget.token,
                                            updateData: body,
                                          );
                                      if (resp.isSuccess) {
                                        Navigator.of(context).pop();
                                        _fetchAgentDetail(); // refresh data
                                      } else {
                                        ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Update failed: ${resp.message}",
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                    }
                                  },
                                  child: const Text("Save Changes"),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Cancel"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================== UI HELPERS ==================
  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6.0),
        TextField(
          controller: ctrl,
          enabled: enabled,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ],
    );
  }

  // ================== PAGE ==================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text(_errorMessage!)));
    }

    final d = _agentDetail!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) =>
                              Agentdashboardmainpage(initialIndex: 0),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.0),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Image.asset(
                          'lib/icons/back-arrow.png',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),

              // Card: Agent Info
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Agent Information",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Your personal and professional information",
                        style: TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                      const SizedBox(height: 20.0),

                      // Box 1
                      Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(
                                "# Agent ID",
                                d['referalId']?.toString() ?? "",
                                null,
                              ),
                              const Divider(thickness: 0.3, color: Colors.grey),
                              _infoRow(
                                "Name",
                                d['name']?.toString() ?? "",
                                'lib/icons/profile.png',
                              ),
                              const Divider(thickness: 0.3, color: Colors.grey),
                              _infoRow(
                                "Other's Name",
                                d['otherName']?.toString() ?? "",
                                'lib/icons/profile.png',
                              ),
                              const Divider(thickness: 0.3, color: Colors.grey),
                              _infoRow(
                                "Father's Name",
                                d['fatherName']?.toString() ?? "",
                                'lib/icons/profile.png',
                              ),
                              const Divider(thickness: 0.3, color: Colors.grey),
                              _infoRow(
                                "Mobile Number",
                                d['contactNumber']?.toString() ?? "",
                                'lib/icons/telephone.png',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // Box 2
                      Container(
                        height: 210,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(
                                "Aadhar Number",
                                d['aadharNo']?.toString() ?? "",
                                'lib/icons/driving.png',
                              ),
                              const Divider(thickness: 0.3, color: Colors.grey),
                              _infoRow(
                                "PAN Card",
                                d['panNo']?.toString() ?? "",
                                'lib/icons/card.png',
                              ),
                              const Divider(thickness: 0.3, color: Colors.grey),
                              _infoRow(
                                "Account Number",
                                d['accountNo']?.toString() ?? "",
                                'lib/icons/rupee.png',
                              ),
                              const Divider(thickness: 0.3, color: Colors.grey),
                              _infoRow(
                                "IFSC Code",
                                d['ifscCode']?.toString() ?? "",
                                'lib/icons/rupee.png',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () => showUserFormDialog(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15.0,
                                child: Image.asset(
                                  "lib/icons/edit-button.png",
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, String? iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (iconPath != null)
              SizedBox(
                height: 14,
                child: Image.asset(iconPath, color: Colors.green),
              ),
            if (iconPath != null) const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.green, fontSize: 14.0),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
