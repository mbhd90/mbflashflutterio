import 'package:bm_flash/modules/category/controller/cubit_brand/brand_cubit.dart';
import 'package:bm_flash/modules/category/controller/cubit_brand_product/brand_product_cubit.dart';
import 'package:bm_flash/modules/seller/cubic/cubit_product/seller_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bm_flash/modules/message/controller/cubit/inbox_cubit.dart';
import 'package:bm_flash/modules/message/controller/repository/chat_respository.dart';

import '/modules/category/controller/cubit/category_cubit.dart';
import '/modules/category/controller/cubit_product/category_product_cubit.dart';
import '/modules/category/controller/cubit/cubit/child_cubit.dart';
import '/modules/category/controller/cubit/cubit/sub_category_cubit.dart';
import '/modules/category/controller/repository/category_repository.dart';
import '/modules/flash/controller/cubit/flash_cubit.dart';
import '/modules/flash/controller/flash_repository.dart';
import '/modules/home/controller/cubit/products_cubit.dart';
import '/modules/place_order/controllers/bank/bank_cubit.dart';
import '/modules/place_order/controllers/razorpay/razorpay_cubit.dart';
import 'core/data/datasources/local_data_source.dart';
import 'core/data/datasources/remote_data_source.dart';
import 'core/remote_urls.dart';
import 'modules/animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import 'modules/animated_splash_screen/controller/repository/app_setting_repository.dart';
import 'modules/authentication/controller/forgot_password/forgot_password_cubit.dart';
import 'modules/authentication/controller/login/login_bloc.dart';
import 'modules/authentication/controller/sign_up/sign_up_bloc.dart';
import 'modules/authentication/repository/auth_repository.dart';
import 'modules/cart/controllers/cart/add_to_cart/add_to_cart_cubit.dart';
import 'modules/cart/controllers/cart/cart_cubit.dart';
import 'modules/cart/controllers/cart_repository.dart';
import 'modules/cart/controllers/checkout/checkout_cubit.dart';
import 'modules/cart/controllers/delivery_charges/delivery_charges_cubit.dart';
import 'modules/home/controller/cubit/home_controller_cubit.dart';
import 'modules/home/controller/repository/home_repository.dart';
import 'modules/message/controller/bloc/bloc/chat_bloc.dart';
import 'modules/order/controllers/order/order_cubit.dart';
import 'modules/order/controllers/repository/order_repository.dart';
import 'modules/place_order/controllers/cash_on_payment/cash_on_payment_cubit.dart';
import 'modules/place_order/controllers/payment/payment_cubit.dart';
import 'modules/place_order/controllers/payment_repository.dart';
import 'modules/place_order/controllers/paypal/paypal_cubit.dart';
import 'modules/product_details/controller/cubit/product_details_cubit.dart';
import 'modules/product_details/controller/repository/product_details_repository.dart';
import 'modules/product_details/controller/repository/review_submit_repository.dart';
import 'modules/product_details/controller/review/review_cubit.dart';
import 'modules/profile/controllers/address/address_cubit.dart';
import 'modules/profile/controllers/address/cubit/edit_address_cubit.dart';
import 'modules/profile/controllers/change_password/change_password_cubit.dart';
import 'modules/profile/controllers/country_state_by_id/country_state_by_id_cubit.dart';
import 'modules/profile/controllers/delete_user/delete_user_cubit.dart';
import 'modules/profile/controllers/profile_edit/profile_edit_cubit.dart';
import 'modules/profile/controllers/repository/profile_repository.dart';
import 'modules/profile/controllers/updated_info/updated_info_cubit.dart';
import 'modules/profile/profile_offer/controllers/wish_list/wish_list_cubit.dart';
import 'modules/search/controllers/search/search_bloc.dart';
import 'modules/search/controllers/search_repository.dart';
import 'modules/seller/controller/become_seller_cubit.dart';
import 'modules/seller/repository/become_seller_repository.dart';
import 'modules/setting/controllers/about_us_cubit/about_us_cubit.dart';
import 'modules/setting/controllers/contact_us_cubit/contact_us_cubit.dart';
import 'modules/setting/controllers/contact_us_form_bloc/contact_us_form_bloc.dart';
import 'modules/setting/controllers/faq_cubit/faq_cubit.dart';
import 'modules/setting/controllers/privacy_and_term_condition_cubit/privacy_and_term_condition_cubit.dart';
import 'modules/setting/controllers/repository/setting_repository.dart';

class StateInjector {
  static late final SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static final repositoryProviders = <RepositoryProvider>[
    ///network client
    RepositoryProvider<Client>(
      create: (context) => Client(),
    ),
    RepositoryProvider<SharedPreferences>(
      create: (context) => _sharedPreferences,
    ),

    ///data source repository
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(
        client: context.read(),
      ),
    ),

    RepositoryProvider<LocalDataSource>(
      create: (context) => LocalDataSourceImpl(
        sharedPreferences: context.read(),
      ),
    ),

    ///repository
    RepositoryProvider<HomeRepository>(
      create: (context) => HomeRepositoryImp(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<CategoryRepository>(
      create: (context) => CategoryRepositoryImp(
        remoteDataSource: context.read(),
      ),
    ),

    RepositoryProvider<SettingRepository>(
      create: (context) => SettingRepositoryImp(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<ProductDetailsRepository>(
      create: (context) => ProductDetailsRepositoryImp(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepositoryImp(
        remoteDataSource: context.read(),
        localDataSource: context.read(),
      ),
    ),
    RepositoryProvider<ProfileRepository>(
      create: (context) => ProfileRepositoryImp(
        remoteDataSource: context.read(),
        localDataSource: context.read(),
      ),
    ),
    RepositoryProvider<FlashRepository>(
      create: (context) => FlashRepositoryImp(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<AppSettingRepository>(
      create: (context) => AppSettingRepositoryImp(
        remoteDataSource: context.read(),
        localDataSource: context.read(),
      ),
    ),
    RepositoryProvider<OrderRepository>(
      create: (context) => OrderRepositoryImp(
        context.read(),
      ),
    ),
    RepositoryProvider<SearchRepository>(
      create: (context) => SearchRepositoryImp(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<CartRepository>(
      create: (context) => CartRepositoryImp(
        remoteDataSource: context.read(),
        localDataSource: context.read(),
      ),
    ),
    RepositoryProvider<PaymentRepository>(
      create: (context) => PaymentRepositoryImp(
        context.read(),
        context.read(),
      ),
    ),
    RepositoryProvider<SubmitReviewRepository>(
      create: (context) => SubmitReviewRepositoryImp(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<ChatRepository>(
      create: (context) => ChatRepository(
        remoteDataSource: context.read(),
      ),
    ),
    RepositoryProvider<BecomeSellerRequestRepository>(
      create: (context) => BecomeSellerRequestRepositoryImpl(
        remoteDataSource: context.read(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<HomeControllerCubit>(
      create: (BuildContext context) => HomeControllerCubit(
        context.read(),
      ),
    ),
    BlocProvider<ProductsCubit>(
      create: (BuildContext context) => ProductsCubit(
        context.read(),
      ),
    ),
    BlocProvider<CategoryCubit>(
      create: (BuildContext context) => CategoryCubit(
        context.read(),
      ),
    ),
    BlocProvider<CategoryProductCubit>(
      create: (BuildContext context) => CategoryProductCubit(
        context.read(),
      ),
    ),
    BlocProvider<SellerProductCubit>(
      create: (BuildContext context) => SellerProductCubit(
        context.read(),
      ),
    ),
    BlocProvider<BrandCubit>(
      create: (BuildContext context) => BrandCubit(
        context.read(),
      ),
    ),
    BlocProvider<BrandProductCubit>(
      create: (BuildContext context) => BrandProductCubit(
        context.read(),
      ),
    ),
    BlocProvider<SubCategoryCubit>(
      create: (BuildContext context) => SubCategoryCubit(
        context.read(),
      ),
    ),
    BlocProvider<ChildCubit>(
      create: (BuildContext context) => ChildCubit(
        context.read(),
      ),
    ),
    BlocProvider<AboutUsCubit>(
      create: (BuildContext context) => AboutUsCubit(
        context.read(),
      ),
    ),
    BlocProvider<FaqCubit>(
      create: (BuildContext context) => FaqCubit(
        context.read(),
      ),
    ),
    BlocProvider<PrivacyAndTermConditionCubit>(
      create: (BuildContext context) => PrivacyAndTermConditionCubit(
        context.read(),
      ),
    ),
    BlocProvider<ContactUsCubit>(
      create: (BuildContext context) => ContactUsCubit(
        context.read(),
      ),
    ),
    BlocProvider<ContactUsCubit>(
      create: (BuildContext context) => ContactUsCubit(
        context.read(),
      ),
    ),
    BlocProvider<ContactUsFormBloc>(
      create: (BuildContext context) => ContactUsFormBloc(
        context.read(),
      ),
    ),
    BlocProvider<ProductDetailsCubit>(
      create: (BuildContext context) => ProductDetailsCubit(
        context.read(),
      ),
    ),
    BlocProvider<FlashCubit>(
      create: (BuildContext context) => FlashCubit(
        context.read(),
      ),
    ),
    BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(
        profileRepository: context.read(),
        authRepository: context.read(),
      ),
    ),
    BlocProvider<SignUpBloc>(
      create: (BuildContext context) => SignUpBloc(
        context.read(),
      ),
    ),
    BlocProvider<ForgotPasswordCubit>(
      create: (BuildContext context) => ForgotPasswordCubit(
        context.read(),
      ),
    ),
    BlocProvider<AppSettingCubit>(
      create: (BuildContext context) => AppSettingCubit(
        context.read(),
      ),
    ),
    BlocProvider<ChangePasswordCubit>(
      create: (BuildContext context) => ChangePasswordCubit(
        loginBloc: context.read(),
        profileRepository: context.read(),
      ),
    ),
    BlocProvider<ProfileEditCubit>(
      create: (BuildContext context) => ProfileEditCubit(
        loginBloc: context.read(),
        profileRepository: context.read(),
      ),
      lazy: true,
    ),
    BlocProvider<CountryStateByIdCubit>(
      create: (BuildContext context) => CountryStateByIdCubit(
        loginBloc: context.read(),
        profileRepository: context.read(),
      ),
      lazy: true,
    ),
    BlocProvider<OrderCubit>(
      create: (BuildContext context) => OrderCubit(
        loginBloc: context.read(),
        orderRepository: context.read(),
      ),
      lazy: true,
    ),
    BlocProvider<AddressCubit>(
      create: (BuildContext context) => AddressCubit(
        loginBloc: context.read(),
        profileRepository: context.read(),
      ),
      lazy: true,
    ),
    BlocProvider<WishListCubit>(
      create: (BuildContext context) => WishListCubit(
        loginBloc: context.read(),
        profileRepository: context.read(),
      ),
    ),
    BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        searchRepository: context.read(),
      ),
    ),
    BlocProvider<CartCubit>(
      create: (context) => CartCubit(
        cartRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(
        paymentRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<SubmitReviewCubit>(
      create: (context) => SubmitReviewCubit(
        repository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<AddToCartCubit>(
      create: (context) => AddToCartCubit(
        cartRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<CheckoutCubit>(
      create: (context) => CheckoutCubit(
        cartRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<CashOnPaymentCubit>(
      create: (context) => CashOnPaymentCubit(
        paymentRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<PaypalCubit>(
      create: (context) => PaypalCubit(
        paymentRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<RazorpayCubit>(
      create: (context) => RazorpayCubit(
        paymentRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    /*BlocProvider<StripeCubit>(
      create: (context) => StripeCubit(
        paymentRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),*/
    BlocProvider<BankCubit>(
      create: (context) => BankCubit(
        paymentRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<DeliveryChargesCubit>(
      create: (context) => DeliveryChargesCubit(),
    ),
    BlocProvider<UserProfileInfoCubit>(
      create: (context) => UserProfileInfoCubit(
        profileRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<EditAddressCubit>(
      create: (context) => EditAddressCubit(
        profileRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<DeleteUserCubit>(
      create: (context) => DeleteUserCubit(
        profileRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        chatRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
    BlocProvider<InboxCubit>(
      create: (context) => InboxCubit(),
    ),
    BlocProvider<BecomeSellerCubit>(
      create: (context) => BecomeSellerCubit(
        sellerRequestRepository: context.read(),
        loginBloc: context.read(),
      ),
    ),
  ];
}
