import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '/dummy_data/all_dummy_data.dart';
import '/modules/cart/controllers/delivery_charges/delivery_charges_cubit.dart';
import '/modules/profile/controllers/address/address_cubit.dart';
import '/widgets/capitalized_word.dart';
import '../../core/router_name.dart';
import '../../utils/constants.dart';
import '../../utils/language_string.dart';
import '../../utils/utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rounded_app_bar.dart';
import '../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import 'component/address_card_component.dart';
import 'component/checkout_single_item.dart';
import 'component/shiping_method_list.dart';
import 'controllers/cart/cart_cubit.dart';
import 'controllers/checkout/checkout_cubit.dart';
import 'model/cart_calculation_model.dart';
import 'model/checkout_response_model.dart';
import 'model/shipping_response_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CartCalculation? cartCalculation;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (context.read<CartCubit>().couponResponseModel != null) {
        context.read<CheckoutCubit>().getCheckOutData(
            context.read<CartCubit>().couponResponseModel!.code);
      } else {
        context.read<CheckoutCubit>().getCheckOutData("");
      }
      context.read<AddressCubit>().getAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(titleText: Language.checkout.capitalizeByWord()),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (_, state) {
          //   if (state is CheckoutStateLoading) {
          //     Utils.loadingDialog(context);
          //   } else {
          //     Utils.closeDialog(context);
          //     if (state is CartStateDecIncretError) {
          //       Utils.errorSnackBar(context, state.message);
          //     }
          //   }
        },
        builder: (context, state) {
          if (state is CheckoutStateLoading || state is CheckoutStateInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CheckoutStateError) {
            if (state.statusCode == 503) {
              return const _LoadedWidget();
            } else {
              return Center(child: Text(state.message));
            }
          }
          return const _LoadedWidget();
        },
      ),
    );
  }
}

class _LoadedWidget extends StatefulWidget {
  const _LoadedWidget({Key? key}) : super(key: key);

  @override
  State<_LoadedWidget> createState() => _LoadedWidgetState();
}

class _LoadedWidgetState extends State<_LoadedWidget> {
  final double height = 140;
  String addressTypeSelect = "Billing Address";

  final headerStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  CheckoutResponseModel? checkoutResponseModel;
  CartCalculation? cartCalculation;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  final body = <String, dynamic>{};
  final shippingMethodList = <ShippingResponseModel>[];

  @override
  void initState() {
    super.initState();
    load();
    if (context.read<CartCubit>().couponResponseModel != null) {
      body['coupon'] = context.read<CartCubit>().couponResponseModel!.code;
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  load() {
    checkoutResponseModel = context.read<CheckoutCubit>().checkoutResponseModel;
    // final c = checkoutResponseModel = context.read<CheckoutCubit>().checkoutResponseModel;
    // print('Checkout:: $c');

    cartCalculation = context.read<CartCubit>().getCartCalculation();
    if (checkoutResponseModel == null) {
      return const SizedBox();
    }
    previousPrice = cartCalculation!.total;
  }

  int shippingMethod = 0;
  int agreeTermsCondition = 1;
  int billingAddressId = 0;
  int shippingAddressId = 0;
  double previousPrice = 0.0;
  double totalPrice = 0.0;
  String basedOnWeight = 'base_on_weight';
  String basedOnPrice = 'base_on_price';
  String basedOnQty = 'base_on_qty';

  @override
  Widget build(BuildContext context) {
    context.read<DeliveryChargesCubit>().addDeliveryCharges(previousPrice);
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildProductNumber()),
              _buildProductList(),
              SliverToBoxAdapter(child: _buildLocation()),
              if (shippingMethodList.isNotEmpty)
                SliverToBoxAdapter(
                  child: ShippingMethodList(
                    shippingMethods: shippingMethodList,
                    onChange: (int id) {
                      shippingMethod = id;
                      for (var i in shippingMethodList) {
                        if (i.id == id) {
                          totalPrice = previousPrice + i.shippingFee;
                          context
                              .read<DeliveryChargesCubit>()
                              .addDeliveryCharges(totalPrice);
                        }
                      }
                    },
                  ),
                ),
              // SliverToBoxAdapter(child: _buildPaymentList(context)),
              SliverToBoxAdapter(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: agreeTermsCondition == 1 ? true : false,
                    activeColor: lightningYellowColor,
                    onChanged: (v) {
                      if (v != null) {
                        agreeTermsCondition = agreeTermsCondition == 1 ? 0 : 1;
                        setState(() {});
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      Language.agreeTermAndCondition.capitalizeByWord(),
                      style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: textGreyColor),
                    ),
                  ),
                ],
              )),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ],
          ),
        ),
        _bottomBtn(),
      ],
    );
  }

  Widget _bottomBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<DeliveryChargesCubit, DeliveryChargesState>(
                  builder: (context, state) {
                    if (state is DeliveryChargesInitial) {
                      return const Text('');
                    } else if (state is DeliveryChargesAdded) {
                      final price =
                          context.read<DeliveryChargesCubit>().initialPrice;
                      return Text(
                        "${Language.total.capitalizeByWord()}: ${Utils.formatPrice(price, context)} ",
                        style: const TextStyle(
                            color: redColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                Text(
                  " +${Language.shippingCost.capitalizeByWord()}",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: PrimaryButton(
              text: Language.placeOrderNow.capitalizeByWord(),
              onPressed: () {
                if (agreeTermsCondition != 1) {
                  Utils.errorSnackBar(context, Language.termAndCondition);
                  return;
                } else if (shippingAddressId < 1 ||
                    billingAddressId < 1 ||
                    shippingMethod < 1) {
                  Utils.errorSnackBar(context, Language.selectLocation);
                } else {
                  body['shipping_address_id'] = shippingAddressId.toString();
                  body['billing_address_id'] = billingAddressId.toString();
                  body['shipping_method_id'] = shippingMethod.toString();
                  debugPrint(body.toString());
                  // Navigator.pushNamed(context, RouteNames.placeOrderScreen,
                  //     // arguments: {
                  //     //   'body': body,
                  //     //   'payment_status': checkoutResponseModel,
                  //     // });
                  //   arguments: body,
                  // );
                  Navigator.pushNamed(context, RouteNames.placeOrderScreen,
                      arguments: {
                        'body': body,
                        'payment_status': checkoutResponseModel,
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Language.deliveryLocation.capitalizeByWord(),
                  style: headerStyle),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.addressScreen);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 22,
                  decoration: BoxDecoration(
                    color: lightningYellowColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(Language.add.capitalizeByWord(),
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        BlocBuilder<AddressCubit, AddressState>(
          builder: (context, state) {
            if (state is AddressStateLoading) {
              return Text(Language.loading.capitalizeByWord());
            } else if (state is AddressStateError) {
              if (state.statusCode == 503) {}
              return Text(state.message);
            } else if (state is AddressStateLoaded) {
              if (state.address.addresses.isEmpty) {
                return Text(Language.noAddress.capitalizeByWord());
              } else {    
                if (state.address.addresses.isNotEmpty){
                  var index = 0;
                  for(var address in state.address.addresses){
                    //print(address);
                    
                    if(billingAddressId == 0 && address.defaultBilling == 1){
                      billingAddressId = address.id;
                    }

                    if(shippingAddressId == 0 && address.defaultShipping == 1){
                      shippingAddressId = address.id;
                      shippingCharges(state, index);
                    }
                    index++;
                  }
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        ...addressType.asMap().entries.map(
                              (e) => InkWell(
                                onTap: () {
                                  setState(() {
                                    addressTypeSelect = e.value;
                                    pageController.animateToPage(e.key,
                                        duration:
                                            const Duration(microseconds: 500),
                                        curve: Curves.ease);
                                  });
                                },
                                child: AnimatedContainer(
                                    duration: const Duration(microseconds: 300),
                                    curve: Curves.ease,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      color: addressTypeSelect == e.value
                                          ? lightningYellowColor
                                          : Colors.transparent,
                                    ))),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      e.value,
                                      style: TextStyle(
                                        color: addressTypeSelect == e.value
                                            ? lightningYellowColor
                                            : blackColor,
                                      ),
                                    )),
                              ),
                            ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: PageView.builder(
                          itemCount: addressType.length,
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.only(left: 20),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(
                                      state.address.addresses.length,
                                      (index) => shippingCharges(state, index)),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                );
              }
            }
            return Text("${Language.somethingWentWrong}!");
          },
        )
      ],
    );
  }

  Widget shippingCharges(AddressStateLoaded state, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          if (addressTypeSelect == Language.billingAddress.capitalizeByWord()) {
            billingAddressId = state.address.addresses[index].id;
          } else {
            shippingMethodList.clear();

            // shippingMethodList.addAll(checkoutResponseModel!.shippings
            //     .where((element) =>
            //         element.cityId == state.address.addresses[index].cityId)
            //     .toList());
            //
            // shippingMethodList.addAll(checkoutResponseModel!.shippings
            //     .where((element) => element.shippingRule == 'Regular')
            //     .toList());
            //
            // shippingMethodList.addAll(checkoutResponseModel!.shippings
            //     .where((element) => element.type == basedOnQty)
            //     .toList());

            for (var shipping in checkoutResponseModel!.shippings) {
              if (shipping.type == basedOnPrice) {
                if (shipping.conditionFrom <= previousPrice &&
                    shipping.conditionTo >= previousPrice) {
                  if (shippingAddressId != shipping.id) {
                    shippingMethodList.add(shipping);
                  }
                }
              }

              if (shipping.type == basedOnWeight) {
                if (shipping.conditionFrom <= previousPrice &&
                    shipping.conditionTo >= previousPrice) {
                  shippingMethodList.add(shipping);
                  // if (shippingAddressId != shipping.id) {
                  //   shippingMethodList.add(shipping);
                  // }
                }
              }

              if (shipping.type == basedOnQty) {
                if (shipping.conditionFrom <= previousPrice &&
                    shipping.conditionTo >= previousPrice) {
                  shippingMethodList.add(shipping);
                }
              }

              //shippingAddressId = state.address.addresses[index].id;
              //setState(() {});
            }

            shippingAddressId = state.address.addresses[index].id;
            //setState(() {});
          }
          setState(() {});
        },
        child: AddressCardComponent(
            isEditButtonShow: false,
            selectAddress: addressTypeSelect == Language.billingAddress.capitalizeByWord()
                ? billingAddressId
                : shippingAddressId,
            addressModel: state.address.addresses[index],
            type: state.address.addresses[index].phone),
      ),
    );
  }

  SliverPadding _buildProductList() {
    final appSetting = context.read<AppSettingCubit>();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return CheckoutSingleItem(
                appSetting: appSetting,
                product: checkoutResponseModel!.cartProducts[index]);
          },
          childCount: checkoutResponseModel!.cartProducts.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    );
  }

  Widget _buildProductNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart_rounded, color: redColor),
          const SizedBox(width: 10),
          Text(
            "${checkoutResponseModel!.cartProducts.length} ${Language.products.capitalizeByWord()}",
            style: headerStyle,
          ),
        ],
      ),
    );
  }
}
