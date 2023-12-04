import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:ui/api/loginApi.dart';
import 'package:ui/config/images.dart';
import 'package:ui/screens/forget_change_password.dart';

class ForgotOtpPage extends StatefulWidget {
  String method, name, role;
  ForgotOtpPage(
      {Key? key, required this.method, required this.name, required this.role})
      : super(key: key);

  @override
  State<ForgotOtpPage> createState() => _ForgotOtpPageState();
}

class _ForgotOtpPageState extends State<ForgotOtpPage> {
  late OTPTextEditController controller;
  late OTPInteractor otpInteractor;
  final formKey = GlobalKey<FormState>();

  String value = "";
  String output = "";

  //////////////////////////////////////////////////////////////
  int otpCodeLength = 4;
  bool isLoadingButton = false;
  bool enableButton = false;
  String otpCode = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = TextEditingController(text: "");

  checkTextInputData() {
    setState(() {
      value = widget.method;
    });

    if (_isNumeric(value) == true) {
      setState(() {
        output = 'Enter 4 Digit OTP code to your Mobile No';
      });
    } else {
      setState(() {
        output = 'Enter 4 Digit OTP code to your E-Mail Address';
      });
    }
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.green.shade900, width: 2),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  // /// get signature code
  // getSignatureCode() async {
  //   String? signature = await SmsVerification.getAppSignature();
  //   print("signature $signature");
  // }

  // /// listen sms
  // startListeningSms() {
  //   SmsVerification.startListeningSms().then((message) {
  //     setState(() {
  //       otpCode = SmsVerification.getCode(message, intRegex);
  //       textEditingController.text = otpCode;
  //       _onOtpCallBack(otpCode, true);
  //     });
  //   });
  // }

  // _onSubmitOtp() {
  //   setState(() {
  //     isLoadingButton = !isLoadingButton;
  //     _verifyOtpCode();
  //   });
  // }

  // _onClickRetry() {
  //   startListeningSms();
  // }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      this.otpCode = otpCode;
      if (otpCode.length == otpCodeLength && isAutofill) {
        enableButton = false;
        isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == otpCodeLength && !isAutofill) {
        enableButton = true;
        isLoadingButton = false;
      } else {
        enableButton = false;
      }
    });
  }

  _verifyOtpCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    Timer(Duration(milliseconds: 4000), () {
      setState(() {
        isLoadingButton = false;
        enableButton = false;
      });

      // scaffoldKey.currentState?.showSnackBar(
      //     SnackBar(content: Text("Verification OTP Code $otpCode Success")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.3), BlendMode.dstATop),
                    image: const AssetImage(Images.bgImage),
                    repeat: ImageRepeat.repeat)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Images.appLogo),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "OTP",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(output),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(widget.method),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextFieldPin(
                                textController: textEditingController,
                                autoFocus: true,
                                codeLength: otpCodeLength,
                                alignment: MainAxisAlignment.center,
                                defaultBoxSize: 46.0,
                                margin: 10,
                                selectedBoxSize: 46.0,
                                textStyle: const TextStyle(fontSize: 16),
                                defaultDecoration: _pinPutDecoration.copyWith(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue)),
                                selectedDecoration: _pinPutDecoration,
                                onChange: (code) {
                                  _onOtpCallBack(code, false);
                                })),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (textEditingController.text.isEmpty) {
                                _displaySnackBar(context, "Please Enter OTP");
                              } else {
                                if (formKey.currentState!.validate()) {
                                  await resetPassword(
                                          widget.method,
                                          textEditingController.text,
                                          widget.role)
                                      .then((value) {
                                    if (value['status'] != false) {
                                      _displaySnackBar(context,
                                          'OTP Verified Successfully!!');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotChangePassword(
                                                    name: widget.name,
                                                    pin: textEditingController
                                                        .text,
                                                    role: widget.role,
                                                    userId: widget.method,
                                                  )));
                                    } else {
                                      _displaySnackBar(
                                          context, 'Please Enter Valid OTP');
                                    }
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary: Colors.blueAccent,
                                onPrimary: Colors.white),
                            child: const Text("NEXT"),
                          ),
                        ),
                        const SizedBox(
                          height: 55,
                        ),
                      ]),
                ])),
      )),
    );
  }

  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }
}
