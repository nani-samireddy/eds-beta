import 'dart:async';
import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/common/custom_text_input.dart';
import 'package:eds_beta/common/primary_button.dart';
import 'package:eds_beta/core/core.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:eds_beta/features/home_screen/view/home_view.dart';
import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPValidationView extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OTPValidationView({required this.phoneNumber, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OTPValidationViewState();
}

class _OTPValidationViewState extends ConsumerState<OTPValidationView> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool enableResend = false;
  String otp = "";
  Timer? _timer;
  int _seconds = 120;
  bool _isValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    _phoneNumberController.text = widget.phoneNumber;
    startResendTimer();
    super.initState();
  }

  void startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_seconds == 0) {
          enableResend = true;
          timer.cancel();
        } else {
          _seconds--;
        }
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      _seconds = 120;
      enableResend = false;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void resendOTP() async {
    await ref
        .read(authControllerProvider.notifier)
        .reSendOTP(phoneNumber: widget.phoneNumber, context: context)
        .then(
      (value) {
        if (value) {
          resetTimer();
          startResendTimer();
        }
      },
    );
  }

  void verifyOTP() async {
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(authControllerProvider.notifier)
        .verifyOTP(otp: _otpController.text, context: context)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(_seconds);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 40,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/pngs/otp.png",
                      height: 300,
                    ),
                    Text(
                      "Code sent to +91${widget.phoneNumber}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextInput(
                      validator: validateOTP,
                      hintText: "Enter the 6 digit OTP",
                      labelText: "OTP",
                      controller: _otpController,
                      type: TextInputType.number,
                      onChange: (val) {
                        setState(() {
                          if (validateOTP(val) == null) {
                            _isValid = true;
                          } else {
                            _isValid = false;
                          }
                        });
                      },
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Didn't get the code?",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Pallete.textBlackColor),
                          children: [
                            TextSpan(
                                text: enableResend
                                    ? " Resend"
                                    : " Resend in $formattedTime",
                                style: enableResend
                                    ? const TextStyle(
                                        color: Pallete.blue, fontSize: 14)
                                    : null,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = enableResend
                                      ? () {
                                          resendOTP();
                                        }
                                      : null),
                          ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PrimaryButton(
                      enable: _isValid,
                      text: "Verify OTP",
                      onPressed: verifyOTP,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _isLoading ? const CircularLoaderPage() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
