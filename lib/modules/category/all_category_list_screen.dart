import 'package:bm_flash/utils/constants.dart';
import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/capitalized_word.dart';

import '../../utils/language_string.dart';
import '../../widgets/rounded_app_bar.dart';
import 'component/single_circuler_card.dart';
import 'controller/cubit/category_cubit.dart';

class AllCategoryListScreen extends StatelessWidget {
  const AllCategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<CategoryCubit>().getCategoryList();
    final double theWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: Language.allCategories.capitalizeByWord(),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryListLoadedState ||
              state is CategoryLoadedState) {
            final categories = context.read<CategoryCubit>().categoryList;
            if (categories.isEmpty) {
              
              return Column(children: [
                const SizedBox(height: 40),
                CustomImage(path: Kimages.emptyOrder, width: theWidth
                    // height: 55,
                    ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: Text(
                          Language.noCategory.capitalizeByWord(),
                    style: const TextStyle(color: redColor),
                  )))
              ]);
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                mainAxisExtent: 130,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryCircleCard(
                  categoriesModel: categories[index],
                );
              },
            );
          } else if (state is CategoryErrorState) {            
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
          return Center(
            child: SizedBox(
              child: Text(Language.somethingWentWrong.capitalizeByWord()),
            ),
          );
        },
      ),
    );
  }
}
