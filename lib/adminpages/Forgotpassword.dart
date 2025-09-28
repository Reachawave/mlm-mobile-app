import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_project/auth/Login.dart';
import 'package:new_project/utils/AuthApi.dart';

class Forgotpasswod extends StatelessWidget {
  const Forgotpasswod({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ForgotpasswodBody());
  }
}

class ForgotpasswodBody extends StatefulWidget {
  const ForgotpasswodBody({super.key});

  @override
  State<ForgotpasswodBody> createState() => _ForgotpasswodBodyState();
}

enum _Step { phone, otp, password }

class _ForgotpasswodBodyState extends State<ForgotpasswodBody> {
  final _api = AuthApi();

  // Controllers
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();
  final TextEditingController pwdCtrl = TextEditingController();
  final TextEditingController confirmPwdCtrl = TextEditingController();

  // UI/state
  _Step _step = _Step.phone;
  bool _loading = false;

  // Resend OTP timer
  Timer? _timer;
  int _secondsLeft = 0;
  static const int _otpCooldown = 60;

  @override
  void dispose() {
    _timer?.cancel();
    phoneCtrl.dispose();
    otpCtrl.dispose();
    pwdCtrl.dispose();
    confirmPwdCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===== Validators =====
  String? _validatePhone(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Enter registered mobile number';
    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      return 'Enter valid number (10–15 digits)';
    }
    return null;
  }

  String? _validateOtp(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Enter OTP';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) return 'OTP must be 6 digits';
    return null;
  }

  String? _validatePwd(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Enter new password';
    if (value.length < 6) return 'Min 6 characters';
    return null;
  }

  // ===== Actions =====
  Future<void> _sendOtp() async {
    final err = _validatePhone(phoneCtrl.text);
    if (err != null) {
      _toast(err);
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await _api.sendOtp(phoneCtrl.text.trim());
      _toast(res.message.isNotEmpty ? res.message : 'OTP sent');
      setState(() {
        _step = _Step.otp;
        _startResendTimer();
      });
    } catch (e) {
      _toast('Failed to send OTP: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final phoneErr = _validatePhone(phoneCtrl.text);
    if (phoneErr != null) {
      _toast(phoneErr);
      return;
    }
    final otpErr = _validateOtp(otpCtrl.text);
    if (otpErr != null) {
      _toast(otpErr);
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await _api.verifyOtp(
        phoneCtrl.text.trim(),
        otpCtrl.text.trim(),
      );
      _toast(res.message.isNotEmpty ? res.message : 'OTP verified');
      setState(() => _step = _Step.password);
    } catch (e) {
      _toast('Verification failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final phoneErr = _validatePhone(phoneCtrl.text);
    if (phoneErr != null) {
      _toast(phoneErr);
      return;
    }
    final otpErr = _validateOtp(otpCtrl.text);
    if (otpErr != null) {
      _toast(otpErr);
      return;
    }
    final pwdErr = _validatePwd(pwdCtrl.text);
    if (pwdErr != null) {
      _toast(pwdErr);
      return;
    }
    if (pwdCtrl.text != confirmPwdCtrl.text) {
      _toast('Passwords do not match');
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await _api.resetPassword(
        phoneCtrl.text.trim(),
        otpCtrl.text.trim(),
        pwdCtrl.text,
      );
      _toast(res.message.isNotEmpty ? res.message : 'Password updated');
      if (res.isSuccess && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Loginpage()),
        );
      }
    } catch (e) {
      _toast('Reset failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _otpCooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_secondsLeft > 0) return;
    await _sendOtp();
  }

  // ===== UI blocks =====
  Widget _phoneStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Enter registered mobile number",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: "e.g. 9876543210",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _loading ? null : _sendOtp,
          child: _loading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Send OTP"),
        ),
      ],
    );
  }

  Widget _otpStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Enter 6-digit OTP",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: otpCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "••••••",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          ),
          maxLength: 6,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: (_secondsLeft == 0 && !_loading) ? _resendOtp : null,
          child: Text(_secondsLeft == 0 ? "Resend OTP" : "Resend in $_secondsLeft s"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _loading ? null : _verifyOtp,
          child: _loading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Verify OTP"),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _loading
              ? null
              : () => setState(() => _step = _Step.phone), // go back if needed
          child: const Text("Change Mobile Number"),
        ),
      ],
    );
  }

  Widget _passwordStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Set new password",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: pwdCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "New password",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: confirmPwdCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "Confirm password",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _loading ? null : _resetPassword,
          child: _loading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Change Password"),
        ),
      ],
    );
  }

  // ===== Scaffold =====
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 60,
                      child: Image.asset('lib/icons/bank.png', color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Reset your password",
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _step == _Step.phone
                          ? "We’ll send an OTP to your registered mobile number"
                          : _step == _Step.otp
                          ? "Enter the OTP we sent to your mobile"
                          : "Choose a strong new password",
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    if (_step == _Step.phone) _phoneStep(context),
                    if (_step == _Step.otp) _otpStep(context),
                    if (_step == _Step.password) _passwordStep(context),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.green, size: 20),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const Loginpage()),
                            );
                          },
                          child: const Text(
                            "Back to login",
                            style: TextStyle(fontSize: 16.0, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
