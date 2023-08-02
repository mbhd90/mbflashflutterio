import 'package:bm_flash/modules/category/controller/cubit_product/category_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bm_flash/modules/animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import 'package:bm_flash/modules/category/model/product_categories_model.dart';
import 'package:bm_flash/widgets/capitalized_word.dart';
import '../../../utils/language_string.dart';
import '/modules/category/model/filter_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/primary_button.dart';

class DrawerFilter extends StatefulWidget {
  const DrawerFilter({Key? key}) : super(key: key);

  @override
  State<DrawerFilter> createState() => _DrawerFilterState();
}

class _DrawerFilterState extends State<DrawerFilter> {

  /*late double maxValue = 100000;
  late double minValue = 0;
  late double _lowerValue = 1;
  late double _upperValue = 1000;*/
  late CategoryProductCubit loadMoreBloc;
  
  @override
  Widget build(BuildContext context) {
    loadMoreBloc = context.read<CategoryProductCubit>();
    //set default values
    final currency =
        context.read<AppSettingCubit>().settingModel!.setting.currencyIcon;
    return BlocBuilder<CategoryProductCubit, CategoryProductState>(
      builder: (context, state) {
        if (state is CategoryProductLoadingState) {
          return const Drawer(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Center(child: SizedBox())));
        } else if (state is CategoryProductLoadedState) {
          /*if (loadMoreBloc.categoryProducts.isEmpty) {
            return const SizedBox();
          }*/
          // _buildProductGrid(filterOptions.products);
          // filterOptions.products.map((e) {
          //   if (double.parse(e.price) > minValue) {
          //     minValue = double.parse(e.price);
          //   }
          //   if (double.parse(e.price) < maxValue) {
          //     maxValue = double.parse(e.price);
          //   }
          // }).toList();
          final filterOptions =
              context.read<CategoryProductCubit>().productCategoriesModel;

          return Drawer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Scaffold.of(context).closeEndDrawer();
                      },
                      icon: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1, color: lightningYellowColor)),
                          child: const Icon(
                            Icons.clear,
                            color: redColor,
                            size: 15,
                          ))),
                  Text(Language.price.capitalizeByWord()),
                  RangeSlider(
                    max: loadMoreBloc.maxValue,
                    min: loadMoreBloc.minValue,
                    divisions: 10, //slide interval
                    values: RangeValues(loadMoreBloc.lowerValue, loadMoreBloc.upperValue),
                    activeColor: lightningYellowColor,
                    inactiveColor: grayColor,
                    labels: RangeLabels(
                      loadMoreBloc.lowerValue.round().toString(),
                      loadMoreBloc.upperValue.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        loadMoreBloc.lowerValue = values.start;
                        loadMoreBloc.upperValue = values.end;
                      });
                    },
                  ),
                  Text(
                      "${Language.price.capitalizeByWord()} $currency${loadMoreBloc.lowerValue} - $currency${loadMoreBloc.upperValue}"),
                  const SizedBox(height: 10),
                  if (filterOptions.brands.isNotEmpty) ...[
                    Text(
                      Language.brand.capitalizeByWord(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    allBrandItems(filterOptions)
                  ],
                  const SizedBox(height: 10),
                  if (filterOptions.activeVariants.isNotEmpty) ...[
                    ...List.generate(
                        filterOptions.activeVariants.length,
                        (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filterOptions.activeVariants[index].name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (filterOptions.activeVariants[index]
                                    .activeVariantsItems.isNotEmpty) ...[
                                  allVariantItems(filterOptions, index),
                                ],
                                const SizedBox(height: 10),
                              ],
                            ))
                  ],
                  const SizedBox(height: 20),
                  PrimaryButton(
                      borderRadiusSize: 24,
                      text: Language.findProduct.capitalizeByWord(),
                      onPressed: () {
                        final data = FilterModelDto(
                          brands: loadMoreBloc.brands,
                          variantItems: loadMoreBloc.variantsItem,
                          minPrice: loadMoreBloc.lowerValue,
                          maxPrice: loadMoreBloc.upperValue,
                        );

                        loadMoreBloc.page = 1;
                        loadMoreBloc.getFilterProducts(data);
                        
                        Scaffold.of(context).closeEndDrawer();
                      }),
                ],
              ),
            ),
          );
        } else if (state is CategoryProductErrorState) {
          return Drawer(
              child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Center(
                    child: Text(state.errorMessage),
                  )));
        }
        return Drawer(
            child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Center(
                  child: Text(Language.somethingWentWrong),
                )));
      },
    );
  }

  Widget allVariantItems(ProductCategoriesModel filterOptions, int index) {
    return Wrap(
      children: [
        ...List.generate(
          filterOptions.activeVariants[index].activeVariantsItems.length,
          (i) => InkWell(
            onTap: () {
              final String itemName = filterOptions
                  .activeVariants[index].activeVariantsItems[i].name;
              setState(() {
                if (loadMoreBloc.variantsItem.contains(itemName)) {
                  loadMoreBloc.variantsItem.remove(itemName);
                } else {
                  loadMoreBloc.variantsItem.add(itemName);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: loadMoreBloc.variantsItem.contains(filterOptions
                        .activeVariants[index].activeVariantsItems[i].name)
                    ? lightningYellowColor
                    : lightningYellowColor.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(filterOptions
                    .activeVariants[index].activeVariantsItems[i].name),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget allBrandItems(ProductCategoriesModel filterOptions) {
    return Wrap(
      children: [
        ...List.generate(
          filterOptions.brands.length,
          (index) => InkWell(
            onTap: () {
              final int ids = filterOptions.brands[index].id;
              setState(() {
                if (loadMoreBloc.brands.contains(ids)) {
                  loadMoreBloc.brands.remove(ids);
                } else {
                  loadMoreBloc.brands.add(ids);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    loadMoreBloc.brands.contains(filterOptions.brands[index].id)
                        ? lightningYellowColor
                        : lightningYellowColor.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  filterOptions.brands[index].name,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
