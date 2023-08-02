import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import 'package:html/dom.dart' as htmlParser;
import '../../utils/constants.dart';
import '../../widgets/rounded_app_bar.dart';
import 'controllers/privacy_and_term_condition_cubit/privacy_and_term_condition_cubit.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<PrivacyAndTermConditionCubit>().getTermsAndConditionData();
    return Scaffold(
      appBar: RoundedAppBar(titleText: Language.termsCon.capitalizeByWord()),
      body: BlocBuilder<PrivacyAndTermConditionCubit,
          PrivacyTermConditionCubitState>(
        builder: (context, state) {
          if (state is TermConditionCubitStateLoaded) {
            final termsAndCondition = state.privacyPolicyAndTermConditionModel;
            final String hml = htmlParser.DocumentFragment.html(
                    termsAndCondition.termsAndCondition)
                .text
                .toString();
            return ListView(
              padding: const EdgeInsets.all(6),
              children: [
                HtmlWidget(
                  termsAndCondition.termsAndCondition,
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
                            "table": Style(
                      backgroundColor:
                          const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    "tr": Style(
                      border:
                          const Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: HtmlPaddings.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: HtmlPaddings.all(6),
                      alignment: Alignment.topLeft,
                    ),
                    'h':
                        Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
                    'ul': Style(color: textGreyColor),
                    'p': Style(
                        color: textGreyColor, textAlign: TextAlign.justify),
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
