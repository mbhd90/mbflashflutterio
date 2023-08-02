import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../utils/language_string.dart';
import '../../widgets/app_bar_leading.dart';
import 'component/faq_app_bar.dart';
import 'component/faq_list_widget.dart';
import 'controllers/faq_cubit/faq_cubit.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<FaqCubit>().getFaqList();
    const double appBarHeight = 120;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: appBarHeight,
            /*systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: lightningYellowColor),*/            
            /*systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: lightningYellowColor, 
              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.light, // For Android (dark icons)
              statusBarBrightness: Brightness.light, 
                // statusBarColor: appPrimaryColor,
                ),*/
            title: Text(
              Language.faq,
              style: const TextStyle(color: Colors.white),
            ),
            titleSpacing: 0,
            leading: const AppbarLeading(),
            // leading: const AppbarLeading(color: primaryColor,),
            flexibleSpace: const FaqAppBar(height: appBarHeight),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          BlocBuilder<FaqCubit, FaqCubitState>(
            builder: (context, state) {
              if (state is FaqCubitStateLoaded) {
                return FaqListWidget(faqList: state.faqList);
              } else if (state is FaqCubitStateLoading) {
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is FaqCubitStateError) {
                final double theWidth = MediaQuery.of(context).size.width * 0.8;
                return SliverToBoxAdapter(
                  child: Column(children: [
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
                  ])
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
        ],
      ),
    );
  }
}
