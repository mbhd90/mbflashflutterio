import 'dart:convert';

import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/capitalized_word.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/language_string.dart';
import '../../widgets/rounded_app_bar.dart';
import 'component/contact_us_form_widget.dart';
import 'controllers/contact_us_cubit/contact_us_cubit.dart';
import 'model/contact_us_mode.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  void initState() {
    Future.microtask(
            () => context.read<ContactUsCubit>().getContactUsContent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(titleText: Language.contactUs.capitalizeByWord()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            ContactUsFormWidget(),
            ContactUsCondentWidget(),
          ],
        ),
      ),
    );
  }
}

class ContactUsCondentWidget extends StatefulWidget {
  const ContactUsCondentWidget({Key? key}) : super(key: key);

  @override
  State<ContactUsCondentWidget> createState() => _ContactUsCondentWidgetState();
}

class _ContactUsCondentWidgetState extends State<ContactUsCondentWidget> {
  late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactUsCubit, ContactUsState>(
      builder: (context, state) {
        if (state is ContactUsStateLoaded) {
          final aboutUsData = state.contactUsModel;
          return _buildLoadedWidget(aboutUsData);
        } else if (state is ContactUsStateLoading) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ContactUsStateError) {
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
    );
  }

  Widget _buildLoadedWidget(ContactUsModel aboutUsData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30, width: double.infinity),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Expanded(
        //       child:
        //     ),
        //     const SizedBox(width: 10),
        //     VerticalDivider(),
        //     const SizedBox(width: 10),
        //     Expanded(
        //       child:
        //     ),
        //   ],
        // ),
        _buildSingleInfo(
            Language.emailAddress.capitalizeByWord(), Icons.email, aboutUsData.email),
        const Divider(height: 40),
        _buildSingleInfo(
            Language.phoneNumber.capitalizeByWord(), Icons.call, aboutUsData.phone),
        const Divider(height: 40),
        _buildSingleInfo(
            Language.address.capitalizeByWord(), Icons.location_on, aboutUsData.address),
        const SizedBox(height: 20),
        // Container(
        //   color: redColor,
        //   height: 200,
        //   width: MediaQuery.of(context).size.width,
        //   child: WebView(
        //     zoomEnabled: true,
        //     javascriptMode: JavascriptMode.unrestricted,
        //     onWebViewCreated: (WebViewController ctr) {
        //       controller = ctr;
        //       loadMap(aboutUsData.map);
        //     },
        //   ),
        // ),
      ],
    );
  }

  void loadMap(String iframe) {
    final uri = Uri.dataFromString(
      iframe,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();
    controller.loadUrl(uri);
  }

  Widget _buildSingleInfo(String header, IconData icon, content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 30, color: lightningYellowColor),
        Text(header, style: const TextStyle(fontSize: 16)),
        Text(
          content,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: iconGreyColor),
        ),
      ],
    );
  }
}
