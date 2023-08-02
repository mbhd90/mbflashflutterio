import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/capitalized_word.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/primary_button.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '../controller/sign_up/sign_up_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignUpBloc>();
    final appSettingBloc = context.read<AppSettingCubit>();
    final _countries =  ["CM"];
    bloc.add(SignUpEventPhoneCode('+237'));
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            BlocBuilder<SignUpBloc, SignUpModelState>(
              builder: (context, state) {
                final s = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      initialValue: state.name,
                      onChanged: (value) => bloc.add(SignUpEventName(value)),
                      decoration: InputDecoration(
                          hintText: Language.name.capitalizeByWord()),
                    ),
                    if (s is SignUpStateLoadedError) ...[
                      if (s.errors.name.isNotEmpty)
                        ErrorText(text: s.errors.name.first),
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<SignUpBloc, SignUpModelState>(
              builder: (context, state) {
                final s = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: state.email,
                      onChanged: (value) => bloc.add(SignUpEventEmail(value)),
                      decoration: InputDecoration(
                          hintText: Language.emailAddress.capitalizeByWord()),
                    ),
                    if (s is SignUpStateLoadedError) ...[
                      if (s.errors.email.isNotEmpty)
                        ErrorText(text: s.errors.email.first),
                    ]
                  ],
                );
              },
            ),
            if (appSettingBloc.settingModel!.setting.phoneNumberRequired ==
                1) ...[
              const SizedBox(height: 16),
              BlocBuilder<SignUpBloc, SignUpModelState>(
                builder: (context, state) {
                  final s = state.state;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        initialValue: state.phone,
                        onChanged: (value) => bloc.add(SignUpEventPhone(value)),
                        decoration: InputDecoration(
                          hintText: Language.phoneNumber.capitalizeByWord(),
                          prefixIcon: CountryCodePicker(
                            padding: const EdgeInsets.only(bottom: 8),
                            onChanged: (country) {
                              bloc.add(SignUpEventPhoneCode(country.dialCode ?? '+237'));
                              // profileEdBlc
                              //     .changePhoneCode(country.dialCode ?? '');
                            },
                            flagWidth: 35,
                            initialSelection: 'CMR',
                            countryFilter: _countries,
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                          // hintText: Language.phoneNumber.capitalizeByWord(),
                        ),
                      ),
                      if (s is SignUpStateLoadedError) ...[
                        if (s.errors.phone.isNotEmpty)
                          ErrorText(text: s.errors.phone.first),
                      ]
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 16),
            BlocBuilder<SignUpBloc, SignUpModelState>(
              builder: (context, state) {
                final s = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      initialValue: state.password,
                      onChanged: (value) =>
                          bloc.add(SignUpEventPassword(value)),
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
                    if (s is SignUpStateLoadedError) ...[
                      if (s.errors.password.isNotEmpty)
                        ErrorText(text: s.errors.password.first),
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<SignUpBloc, SignUpModelState>(
              // buildWhen: (previous, current) =>
              //     previous.passwordConfirmation != current.passwordConfirmation,
              builder: (context, state) {
                final s = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      initialValue: state.passwordConfirmation,
                      onChanged: (value) =>
                          bloc.add(SignUpEventPasswordConfirm(value)),
                      obscureText: !_passwordVisible2,
                      decoration: InputDecoration(
                        hintText: Language.confirmPassword.capitalizeByWord(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: grayColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible2 = !_passwordVisible2;
                            });
                          },
                        ),
                      ),
                    ),
                    if (s is SignUpStateLoadedError) ...[
                      if (s.errors.password.isNotEmpty)
                        ErrorText(text: s.errors.password.first),
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            _buildRememberMe(),
            const SizedBox(height: 25),
            BlocBuilder<SignUpBloc, SignUpModelState>(
              buildWhen: (previous, current) => previous.state != current.state,
              builder: (context, state) {
                if (state.state is SignUpStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return PrimaryButton(
                  text: Language.singUp.capitalizeByWord(),
                  onPressed: () {
                    Utils.closeKeyBoard(context);
                    bloc.add(SignUpEventSubmit());
                  },
                );
              },
            ),
            // const SizedBox(height: 28),
            // const GuestButton(),
            SizedBox(height: size.height * 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return BlocBuilder<SignUpBloc, SignUpModelState>(
      buildWhen: (previous, current) => previous.agree != current.agree,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.agree == 1,
              checkColor: Colors.white,
              activeColor: lightningYellowColor,
              onChanged: (v) {
                if (v == null) return;
                context.read<SignUpBloc>().add(SignUpEventAgree(v ? 1 : 0));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                Language.signUpCondition.capitalizeByWord(),
                style: TextStyle(color: blackColor.withOpacity(.5)),
              ),
            )
          ],
        );
      },
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.red,
            ),
      ),
    );
  }
}
