import 'dart:developer';

import 'package:bm_flash/i18n/i18n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '/widgets/capitalized_word.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/primary_button.dart';
import '../../utils/k_images.dart';
import '../../utils/language_string.dart';
import '../../widgets/custom_image.dart';
import 'controller/login/login_bloc.dart';
import 'dart:async';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  bool _isValid = false;
  bool _pending = true;
  late Timer _timer;
  late int _start = 60;
  final pinController = TextEditingController();

  void startTimer() {
    try {
      _timer.cancel();
    } catch (err) {}
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            print("C'est ) Zero");
            timer.cancel();
            _pending = false;
          });
        } else {
          setState(() {
            // ignore: avoid_print
            print("== _start ==");
            print(_start);
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xffFFEFE7)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(child: _buildForm()),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        CircleAvatar(
          radius: 96,
          child: const CustomImage(path: Kimages.forgotIcon),
          backgroundColor: redColor.withOpacity(0.1),
        ),
        const SizedBox(height: 55),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Language.verificationCode.capitalizeByWord(),
            style: GoogleFonts.poppins(
                height: 1, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 22),
        Pinput(
          controller: pinController,
          defaultPinTheme: PinTheme(
            height: 52,
            width: 52,
            textStyle: GoogleFonts.poppins(fontSize: 26, color: blackColor),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          autofocus: true,
          keyboardType: TextInputType.number,
          length: 6,
          validator: (String? s) {
            if (s == null || s.isEmpty)
              return Language.enterCode.capitalizeByWord();
            return null;
          },
          onChanged: (String s) {
            if (s.length == 6) {
              _isValid = true;
            } else {
              _isValid = false;
            }
            setState(() {});
          },
          onCompleted: (String s) {
            log('onComplete');
            context.read<LoginBloc>().add(AccountActivateCodeSubmit(s));
          },
          onSubmitted: (String s) {
            log('onSUbmit');
          },
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
        ),
        const SizedBox(height: 28),
        BlocBuilder<LoginBloc, LoginModelState>(
          builder: (context, state) {
            if (state.state is LoginStateLoading) {
              return const CircularProgressIndicator();
            }
            return _buildContinueBtn();
          },
        ),
        const SizedBox(height: 15),
        BlocBuilder<LoginBloc, LoginModelState>(
          builder: (context, state) {
            if (state.state is LoginStateLoading) {
              return Row();
            }
            if (_pending) {
              return _buildWaitResendBtn();
            }
            return _buildResendBtn();
          },
        ),
      ],
    );
  }

  Widget _buildContinueBtn() {
    return PrimaryButton(
      // text: Language.continue,
      text: Language.continue_,
      grediantColor: _isValid
          ? greenGredient
          : [
              lightningYellowColor.withOpacity(.6),
              lightningYellowColor.withOpacity(.6),
            ],
      onPressed: _isValid
          ? () {
              context
                  .read<LoginBloc>()
                  .add(const SentAccountActivateCodeSubmit());
            }
          : null,
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  Widget _buildWaitResendBtn() {
    return Text.rich(TextSpan(
        text:
            '${LanguageText.waitStartSendingCode()} ${_start} ${LanguageText.waitSendingCode()}',
        style: const TextStyle(color: Color(0xff878D97))));
  }

  Widget _buildResendBtn() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text('${Language.dontReceivedCode} ? ',
          style: const TextStyle(color: Color(0xff878D97))),
      TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16, color: Color(0xff000000)),
        ),
        onPressed: () {
          print("Restart Send code!...");
          context.read<LoginBloc>().add(const SentAccountActivateCodeSubmit());
          setState(() {
            _start = 60;
            _pending = true;
          });
          startTimer();
        },
        child: Text(Language.resend.capitalizeByWord()),
      ),
    ]);
  }
}
