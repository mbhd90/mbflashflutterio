import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../../utils/constants.dart';
import '../../widgets/rounded_app_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'controllers/privacy_and_term_condition_cubit/privacy_and_term_condition_cubit.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<PrivacyAndTermConditionCubit>().getPrivacyPolicyData();
    return Scaffold(
      appBar:
          RoundedAppBar(titleText: Language.privacyPolicy.capitalizeByWord()),
      body: BlocBuilder<PrivacyAndTermConditionCubit,
          PrivacyTermConditionCubitState>(
        builder: (context, state) {
          if (state is TermConditionCubitStateLoaded) {
            final termsAndCondition = state.privacyPolicyAndTermConditionModel;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                HtmlWidget(
                  termsAndCondition.privacyPolicy,
                  onErrorBuilder: (context, element, error) =>
                      Text('$element error: $error'),
                  /*onLoadingBuilder: (context, element, loadingProgress) =>
                      const CircularProgressIndicator(),*/
                  /*customStylesBuilder: (element) {
                          if (element.nodeType ==  ) {
                            return {'color': 'red'};
                          }

                          return null;
                        },
                        textStyle:{
                          'p': Style(
                              color: textGreyColor, textAlign: TextAlign.justify),
                          'h': Style(color: blackColor, fontSize: FontSize.larger),
                        }*/
                )
              ],
            );
          } else if (state is TermConditionCubitStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TermConditionCubitStateError) {
            final double theWidth = MediaQuery.of(context).size.width * 0.8;
            return Column(children: [
                const SizedBox(height: 40),
                CustomImage(path: Kimages.error, width: theWidth
                    // height: 55,
                    ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: redColor),
                  )))
              ]);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
