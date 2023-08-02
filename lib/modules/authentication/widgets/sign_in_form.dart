import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bm_flash/modules/authentication/widgets/sign_up_form.dart';
import '/widgets/capitalized_word.dart';
import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/primary_button.dart';
import '../controller/login/login_bloc.dart';
import 'guest_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _checkBoxSelect = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: loginBloc.formKey,
        child: Column(
          children: [
            const SizedBox(height: 12),
            BlocBuilder<LoginBloc, LoginModelState>(
              // buildWhen: (previous, current) => previous.email != current.email,
              builder: (context, state) {
                final login = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: state.text,
                      onChanged: (value) =>
                          loginBloc.add(LoginEvenEmailOrPhone(value)),
                      decoration:  const InputDecoration(
                        hintText:"",
                      ),
                    ),
                    if(login is LoginStateFormInvalid)...[
                      if(login.error.email.isNotEmpty)
                        ErrorText(text:login.error.email.first)
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<LoginBloc, LoginModelState>(
              // buildWhen: (previous, current) =>
              //     previous.password != current.password,
              builder: (context, state) {
                final login = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      initialValue: state.password,
                      onChanged: (value) =>
                          loginBloc.add(LoginEventPassword(value)),
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: Language.password.capitalizeByWord(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: grayColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    if(login is LoginStateFormInvalid)...[
                      if(login.error.password.isNotEmpty)
                        ErrorText(text:login.error.password.first)
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            _buildRememberMe(),
            const SizedBox(height: 25),
            BlocBuilder<LoginBloc, LoginModelState>(
              buildWhen: (previous, current) => previous.state != current.state,
              builder: (context, state) {
                if (state.state is LoginStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return PrimaryButton(
                  text: Language.login.capitalizeByWord(),
                  onPressed: () {
                    Utils.closeKeyBoard(context);
                    loginBloc.add(const LoginEventSubmit());
                  },
                );
              },
            ),
            // const SizedBox(height: 16),
            // const Text(
            //   'Sign In With Social',
            //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            // ),
            // const SizedBox(height: 12),
            // const SocialButtons(),
            const SizedBox(height: 28),
            const GuestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _checkBoxSelect,
              checkColor: Colors.white,
              activeColor: lightningYellowColor,
              onChanged: (bool? v) {
                if (v == null) return;
                setState(() {
                  _checkBoxSelect = v;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                Language.rememberMe.capitalizeByWord(),
                style: TextStyle(color: blackColor.withOpacity(.5)),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.forgotScreen);
          },
          child:  Text(
            '${Language.forgotPassword.capitalizeByWord()}?',
            style: const TextStyle(color: lightningYellowColor),
          ),
        ),
      ],
    );
  }
}
