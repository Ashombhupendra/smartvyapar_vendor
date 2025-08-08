import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:get/get.dart';

class OtpDialog extends StatefulWidget {
  final String phone;
  final String otp;
  final Function onSuccess;

  OtpDialog({required this.phone, required this.otp, required this.onSuccess});

  @override
  _OtpDialogState createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  String userInputCode = '';
  int _start = 60;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer!.cancel();
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void validateOtp() async {
    setState(() {
      _isLoading = true;
    });

    if (userInputCode == widget.otp) {
      await widget.onSuccess();
      Navigator.of(context).pop();
      //Get.toNamed(AppRoutes.confirmRegisterPage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect OTP, try again.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogBackgroundColor: Colors.white, // Set the background color to white
      ),
      child: AlertDialog(
        title: Text('Enter OTP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OtpTextField(
              numberOfFields: 6,
              fieldHeight: 55,
              fieldWidth: 35,
              alignment: Alignment.center,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                setState(() {
                  userInputCode = code;
                });
              },
              onSubmit: (String verificationCode) {
                setState(() {
                  userInputCode = verificationCode;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Time remaining: $_start seconds'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : validateOtp,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('Submit'),
          ),
        ],
      ),
    );
  }
}


