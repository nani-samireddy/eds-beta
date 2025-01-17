import 'dart:async';
import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/constants/images_urls.dart';
import 'package:eds_beta/core/core.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneNumberView extends ConsumerStatefulWidget {
  const PhoneNumberView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PhoneNumberViewState();
}

class _PhoneNumberViewState extends ConsumerState<PhoneNumberView> {
  bool _isLoading = false;
  bool _isValid = false;
  bool _otpSent = false;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final TextEditingController phoneNumberController = TextEditingController();

  void _requestOTP() async {
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(authControllerProvider.notifier)
        .sendOTP(phoneNumber: phoneNumberController.text, context: context)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res) {
        setState(() {
          _otpSent = true;
          startResendTimer();
        });
      }
    });
  }

  void editPhoneNumberHandler() {
    setState(() {
      _otpSent = false;
      _otpController.clear();
    });
  }

  // otp validations and resend functions
  final TextEditingController _otpController = TextEditingController();

  bool enableResend = false;
  String otp = "";
  Timer? _timer;
  int _seconds = 120;

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
        .reSendOTP(phoneNumber: phoneNumberController.text, context: context)
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
      if (!value) {
        showSnackBar(
            content: "Oops that's an Invalid OTP! 🥲", context: context);
      } 
      // else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const AuthWrapper(),
      //     ),
      //   );
      // }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(_seconds);

    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        child: Stack(
          children: [
            // Background image
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImagesUrl.authBg), fit: BoxFit.cover)),
            ),
            // Contents
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Pallete.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, bottom: 40, top: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 4,
                            width: 60,
                            margin: const EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                              color: Pallete.fadedIconColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Welcome 👋",
                          style: AppStyles.heading1,
                        ),
                        const Text(
                          "Enter your phone number to get started",
                          style: TextStyle(
                              color: Pallete.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        Center(
                          child: CustomTextInput(
                              prefixText: "+91",
                              enable: !_otpSent,
                              validator: validatephoneNumber,
                              type: TextInputType.number,
                              hintText: "Enter 10 digit phone number ",
                              labelText: "Phone number*",
                              controller: phoneNumberController,
                              onChange: (val) {
                                setState(() {
                                  _isValid = validatephoneNumber(val) == null;
                                });
                              }),
                        ),
                        _otpSent
                            ? Wrap(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      editPhoneNumberHandler();
                                    },
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: Pallete.fadedIconColor,
                                    ),
                                    label: const Text(
                                      "Edit phone number",
                                      style: TextStyle(
                                          color: Pallete.fadedIconColor),
                                    ),
                                  ),
                                  CustomTextInput(
                                    validator: validateOTP,
                                    hintText: "Enter the 6 digit OTP",
                                    labelText: "OTP",
                                    controller: _otpController,
                                    type: TextInputType.number,
                                    onChange: (val) {
                                      setState(() {
                                        _isValid = validateOTP(val) == null;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
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
                                                      color: Pallete.blue,
                                                      fontSize: 14)
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
                                    height: 40,
                                  ),
                                  PrimaryButton(
                                    enable: _isValid,
                                    text: "Verify OTP",
                                    onPressed: verifyOTP,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 20,
                        ),
                        !_otpSent
                            ? Center(
                                child: PrimaryButton(
                                  text: "SEND OTP",
                                  onPressed: _requestOTP,
                                  enable: _isValid,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _isLoading ? const CircularLoaderPage() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
