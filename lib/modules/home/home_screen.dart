import 'dart:developer';

import 'package:bm_flash/utils/k_images.dart';
import 'package:bm_flash/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../utils/utils.dart';
import '../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '../cart/controllers/cart/add_to_cart/add_to_cart_cubit.dart';
import '../cart/controllers/cart/cart_cubit.dart';
import 'component/best_seller_grid_view.dart';
import 'component/category_and_list_component.dart';
import 'component/category_grid_view.dart';
import 'component/flash_sale_component.dart';
import 'component/home_app_bar.dart';
import 'component/hot_deal_banner_slider.dart';
import 'component/new_arrival_component.dart';
import 'component/offer_banner_slider.dart';
import 'component/populer_product_component.dart';
import 'component/sponsor_component.dart';
import 'controller/cubit/home_controller_cubit.dart';
import 'model/banner_model.dart';
import 'model/home_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
      
  @override
  State<HomeScreen> createState() =>
      _HomeScreen();

}

class _HomeScreen 
    extends State<HomeScreen>  {
  
  final _className = 'HomeScreen';

  final _controller = ScrollController();
  bool _showAppbar = true;
  bool isScrollingDown = false;
  
  double bottomBarHeight = 75;

  void showBar() {
    setState(() {
          isScrollingDown = false;
      _showAppbar = true;
    });
  }

  void hideBar() {
    setState(() {
      isScrollingDown = true;
      _showAppbar = false;
    });
  }

  void _init() {
    _controller.addListener(() {
      if (_controller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          hideBar();
        }
      }
      if (_controller.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          showBar();
        }
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToCartCubit, AddToCartState>(
      listenWhen: (previous, current) => true,
      listener: (context, state) {
        if (state is AddToCartStateLoading) {
          Utils.loadingDialog(context);
        } else {
          Utils.closeDialog(context);
          if (state is AddToCartStateAdded) {
            context.read<CartCubit>().getCartProducts();
            Utils.showSnackBar(context, state.message);
          } else if (state is AddToCartStateError) {
            Utils.errorSnackBar(context, state.message);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: /*_showAppbar ?*/AppBar(
            toolbarHeight: 60,
            flexibleSpace: const HomeAppBar(height: 60),
            elevation: 0,
            automaticallyImplyLeading: true,
            //backgroundColor: lightningYellowColor,
            /*systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: lightningYellowColor, 
              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.light, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),*/
          ) /*: PreferredSize(
            preferredSize: const Size(0.0, 0.0),
            child: Container(),
        )*/,
          body: BlocBuilder<HomeControllerCubit, HomeControllerState>(
            builder: (context, state) {
              log(state.toString(), name: _className);
              if (state is HomeControllerLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeControllerError) {
                final double theWidth = MediaQuery.of(context).size.width * 0.8;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
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
                      ]),
                      const SizedBox(height: 10),
                      IconButton(
                        onPressed: () {
                          context.read<HomeControllerCubit>().getHomeData();
                        },
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                    ],
                  ),
                );
              }

              if (state is HomeControllerLoaded) {
                return _LoadedHomePage(homeModel: state.homeModel, controller: _controller);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _LoadedHomePage extends StatelessWidget {
  const _LoadedHomePage({
    Key? key,
    required this.homeModel,
    required this.controller,
  }) : super(key: key);
  final ScrollController controller;

  final HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    final appSetting = context.read<AppSettingCubit>().settingModel;

    final combineBannerList = <BannerModel>[];
    final _map = <String, String>{};
    homeModel.sectionTitle.map((e) {
      _map[e.key] = e.custom!;
    }).toList();
    // homeModel.sliderBannerOne!,
    //       homeModel.sliderBannerTwo!,
    //       homeModel.twoColumnBannerOne!,
    //       homeModel.twoColumnBannerTwo!,
    //       homeModel.singleBannerOne!,
    //       homeModel.singleBannerTwo!,
    // if (homeModel.sliderBannerOne != null) {
    //   combineBannerList.add(homeModel.sliderBannerOne!);
    // }
    // if (homeModel.sliderBannerTwo != null) {
    //   combineBannerList.add(homeModel.sliderBannerTwo!);
    // }
    if (homeModel.twoColumnBannerOne != null) {
      combineBannerList.add(homeModel.twoColumnBannerOne!);
    }
    if (homeModel.twoColumnBannerTwo != null) {
      combineBannerList.add(homeModel.twoColumnBannerTwo!);
    }
    if (homeModel.singleBannerOne != null) {
      combineBannerList.add(homeModel.singleBannerOne!);
    }
    if (homeModel.singleBannerTwo != null) {
      combineBannerList.add(homeModel.singleBannerTwo!);
    }
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        /*const SliverToBoxAdapter(child: SizedBox(height: 10)),
        const SliverToBoxAdapter(child: SearchField()),*/
        SliverToBoxAdapter(
          child: OfferBannerSlider(sliders: homeModel.sliders),
        ),

        CategoryGridView(
            categoryList: homeModel.homePageCategory,
            // categoryList: appSetting!.productCategories,
            sectionTitle:
                '${homeModel.sectionTitle[0].custom ?? homeModel.sectionTitle[0].dDefault}'),

        /*SliverToBoxAdapter(
          child: */SponsorComponent(brands: homeModel.brands, onTap: () {
            Navigator.pushNamed(context, RouteNames.allBrandList,
                arguments: {
                  'keyword': 'brands',
                  'title':
                      '${homeModel.sectionTitle[7].custom ?? homeModel.sectionTitle[7].dDefault}'
                });
          },),
        //),

        // const CountDownOfferAndProduct(),

        HorizontalProductComponent(
          productList: homeModel.popularCategoryProducts,
          bgColor: const Color(0xffF6F6F6),
          category:
              '${homeModel.sectionTitle[1].custom ?? homeModel.sectionTitle[1].dDefault}',
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.allPopulerProductScreen,
              arguments: {
                'keyword': "popular_category",
                'title':
                    '${homeModel.sectionTitle[1].custom ?? homeModel.sectionTitle[1].dDefault}',
              },
            );
          },
        ),

        FlashSaleComponent(flashSale: homeModel.flashSale),

        appSetting!.setting.enableMultivendor == 1
            ? BestSellerGridView(
                sectionTitle:
                    '${homeModel.sectionTitle[4].custom ?? homeModel.sectionTitle[4].dDefault}',
                sellers: homeModel.sellers)
            : const SliverToBoxAdapter(child: SizedBox()),

        CategoryAndListComponent(
          productList: homeModel.topRatedProducts,
          bgColor: const Color(0xffF6F6F6),
          category:
              '${homeModel.sectionTitle[3].custom ?? homeModel.sectionTitle[3].dDefault}',
          onTap: () {
            Navigator.pushNamed(context, RouteNames.allPopulerProductScreen,
                arguments: {
                  'keyword': 'topRatedProducts',
                  'title':
                      '${homeModel.sectionTitle[3].custom ?? homeModel.sectionTitle[3].dDefault}'
                });
          },
        ),

        // WidthBannerComponent(banner: homeModel.popularCategorySidebarBanner),
        const SliverToBoxAdapter(child: SizedBox(height: 5)),

        HorizontalProductComponent(
          productList: homeModel.featuredCategoryProducts,
          bgColor: const Color(0xffF6F6F6),
          category:
              '${homeModel.sectionTitle[5].custom ?? homeModel.sectionTitle[5].dDefault}',
          onTap: () {
            Navigator.pushNamed(context, RouteNames.allPopulerProductScreen,
                arguments: {
                  'keyword': 'featured_product',
                  'title':
                      '${homeModel.sectionTitle[5].custom ?? homeModel.sectionTitle[5].dDefault}'
                });
          },
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 5)),
        HorizontalProductComponent(
          productList: homeModel.bestProducts,
          bgColor: const Color(0xffF6F6F6),
          category:
              '${homeModel.sectionTitle[7].custom ?? homeModel.sectionTitle[7].dDefault}',
          onTap: () {
            Navigator.pushNamed(context, RouteNames.allPopulerProductScreen,
                arguments: {
                  'keyword': 'best_product',
                  'title':
                      '${homeModel.sectionTitle[7].custom ?? homeModel.sectionTitle[7].dDefault}'
                });
          },
        ),

        SliverToBoxAdapter(
          child: CombineBannerSlider(banners: combineBannerList),
        ),

        NewArrivalComponent(
            sectionTitle:
                '${homeModel.sectionTitle[6].custom ?? homeModel.sectionTitle[6].dDefault}',
            productList: homeModel.newArrivalProducts),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }
}
