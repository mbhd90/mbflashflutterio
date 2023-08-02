import 'dart:async';
import 'dart:developer';

import 'package:bm_flash/modules/home/model/brand_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:bm_flash/modules/message/models/seller_messages_dto.dart';

import '/core/data/datasources/network_parser.dart';
import '/modules/category/model/filter_model.dart';
import '/modules/category/model/sub_category_model.dart';
import '/modules/home/model/product_model.dart';
import '../../../modules/authentication/models/set_password_model.dart';
import '../../../modules/authentication/models/user_login_response_model.dart';
import '../../../modules/cart/model/add_to_cart_model.dart';
import '../../../modules/cart/model/cart_response_model.dart';
import '../../../modules/cart/model/checkout_response_model.dart';
import '../../../modules/cart/model/coupon_response_model.dart';
import '../../../modules/category/model/child_category_model.dart';
import '../../../modules/category/model/product_categories_model.dart';
import '../../../modules/flash/model/flash_model.dart';
import '../../../modules/home/model/home_category_model.dart';
import '../../../modules/home/model/home_model.dart';
import '../../../modules/message/models/send_message_response_dto.dart';
import '../../../modules/order/model/order_model.dart';
import '../../../modules/product_details/model/product_details_model.dart';
import '../../../modules/product_details/model/submit_review_response.dart';
import '../../../modules/profile/controllers/change_password/change_password_cubit.dart';
import '../../../modules/profile/controllers/profile_edit/profile_edit_cubit.dart';
import '../../../modules/profile/model/address_model.dart';
import '../../../modules/profile/model/billing_shipping_model.dart';
import '../../../modules/profile/model/city_model.dart';
import '../../../modules/profile/model/country_model.dart';
import '../../../modules/profile/model/country_state_model.dart';
import '../../../modules/profile/model/edit_address_model.dart';
import '../../../modules/profile/model/user_info/user_updated_info.dart';
import '../../../modules/profile/model/user_with_country_response.dart';
import '../../../modules/profile/profile_offer/model/wish_list_model.dart';
import '../../../modules/search/model/search_response_model.dart';
import '../../../modules/seller/controller/become_seller_state_model.dart';
import '../../../modules/seller/seller_model.dart';
import '../../../modules/setting/model/all_about_model.dart';
import '../../../modules/setting/model/contact_us_mesage_model.dart';
import '../../../modules/setting/model/contact_us_mode.dart';
import '../../../modules/setting/model/faq_model.dart';
import '../../../modules/setting/model/privacy_policy_model.dart';
import '../../../modules/setting/model/website_setup_model.dart';
import '../../remote_urls.dart';
import '../../../i18n/i18n.dart';

Map<String, dynamic> myMap = {};

abstract class RemoteDataSource {
  Future<UserLoginResponseModel> signIn(Map<String, dynamic> body);

  Future<UserWithCountryResponse> userProfile(String token);

  Future<String> passwordChange(
      ChangePasswordStateModel changePassData, String token);

  Future<String> profileUpdate(ProfileEditStateModel user, String token);

  Future<UserProfileInfo> getProfileInfo(String token);
  Future<String> deleteUserAccount(String token);

  Future<EditAddressModel> editAddress(String id, String token);

  Future<String> sendForgotPassCode(Map<String, dynamic> body);

  Future<String> setPassword(SetPasswordModel body);

  Future<String> sendActiveAccountCode(String email);

  Future<String> activeAccountCodeSubmit(String code);

  Future<String> logOut(String tokne);

  Future<HomeModel> getHomeData();

  // Future<UserUpdatedInfo> getUpdatedInfo(String token);

  Future<String> updateProfileInformation(
      Map<String, String> dataMap, String token);

  Future<SearchResponseModel> getHighlightProducts(String keyWord, int page, int perPage);

  Future<SearchResponseModel> loadMoreProducts(
      String keyword, int page, int perPage);

  Future<List<ProductModel>> getBrandProducts(String slug, int page, int perPage);

  Future<WebsiteSetupModel> websiteSetup();

  Future<String> userRegister(Map<String, dynamic> userInfo);

  Future<AboutInformationModel> getAboutUsData();

  Future<List<SellerDto>> getAllCharts(String token);

  Future<SendMessageResponseDto> sendMessageToSeller(
      Map<String, dynamic> mapBody, String token);

  Future<List<FaqModel>> getFaqList();

  Future<PrivacyPolicyAndTermConditionModel> getPrivacyPolicy();

  Future<PrivacyPolicyAndTermConditionModel> getTermsAndCondition();

  Future<ContactUsModel> getContactUsContent();

  Future<bool> getContactUsMessageSend(ContactUsMessageModel body);

  Future<ProductDetailsModel> getProductDetails(String slug);

  Future<SubmitReviewResponseModel> submitReivew(
      Map<String, dynamic> reviewInfo, String token);

  Future<List<CountryStateModel>> statesByCountryId(
      String countryID, String token);

  Future<List<CountryModel>> getCountryList(String token);

  Future<List<CityModel>> citiesByStateId(String countryID, String token);

  Future<List<OrderModel>> orderList(String token);

  Future<OrderModel> getSingleOrder(String trackNumber, String token);

  Future<AddressBook> getShipingAndBillingAddress(String token);

  Future<AddressModel> getSingleAddress(String id, String token);

  Future<String> deleteAddress(String id, String token);

  Future<String> billingUpdate(Map<String, String> dataMap, String token);

  Future<String> updateAddress(
      String id, Map<String, String> dataMap, String token);

  Future<String> addAddress(Map<String, String> dataMap, String token);

  Future<String> shippingUpdate(Map<String, String> dataMap, String token);

  Future<List<WishListModel>> wishList(String token);

  Future<String> removeWishList(int id, String token);

  Future<String> clearWishList(String token);
  Future<String> becomeSellerRequest(String token, BecomeSellerStateModel body);

  Future<String> addWishList(int id, String token);

  Future<SearchResponseModel> searchProduct(Uri uri);

  Future<CartResponseModel> getCartProducts(String token);

  Future<SellerProductModel> getSellerProductLists(String slug, int page, int perPage);

  Future<List<ProductModel>> getallSellerProductLists(String slug, int page, int perPage);

  //Future<CartResponseModel> applyCoupon(String token, String coupon);

  /*Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency);*/

  Future<CheckoutResponseModel> getCheckoutData(
      String token, String couponCode);

  Future<String> incrementQuantity(String productId, String token);

  Future<String> removerCartItem(String productId, String token);

  Future<String> decrementQuantity(String productId, String token);

  Future<String> addToCart(AddToCartModel dataModel);

  Future<String> cashOnDeliveryPayment(Map<String, dynamic> body, String token);

  Future<String> payWithPaypal(Uri uri);

  Future<Map<String, dynamic>> payWithRazor(Uri uri);

  Future<String> paypalSuccess(Uri uri);

  //Future<String> stripePay(String token, Map<String, String> body);

  Future<String> bankPay(String token, Map<String, String> body);

  Future<CouponResponseModel> applyCoupon(String coupon, String token);

  Future<ProductCategoriesModel> getCategoryProducts(
      String slug, int page, int perPage);

  Future<List<ProductModel>> getSubCategoryProducts(String slug);

  Future<FlashModel> getFlashSale();

  Future<List<HomePageCategoriesModel>> getCategoryLists();
  
  Future<List<BrandModel>> getBrandLists();
  // Future<List<CategoriesModel>> getCategoryLists();

  Future<List<SubCategoryModel>> getSubCategoryLists(String id);

  Future<List<ChildCategoryModel>> getChildCategoryLists(String id);

  Future<List<ProductModel>> filterProducts(FilterModelDto dataModel,  String category, int page, int perPage);

  Future<List<ProductModel>> filterSellerProducts(FilterModelDto dataModel,  String seller, int page, int perPage);
}

typedef CallClientMethod = Future<http.Response> Function();

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000",
      receiveTimeout: const Duration(seconds: 3),
      // 15 seconds
      connectTimeout: const Duration(seconds: 3),
      sendTimeout: const Duration(seconds: 3),
      headers: {
        Headers.acceptHeader: 'application/json',
        Headers.contentTypeHeader: 'application/json',
      },
    ),
  );

  RemoteDataSourceImpl({required this.client});

  /*@override
  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    final body = {
      "amount": amount,
      "currency": currency,
      "payment_method_types[]": "card"
    };

    final uri = Uri.parse(RemoteUrls.paymentApi);

    final headers = {
      "Authorization": "Bearer ${RemoteUrls.secretKey}",
      "Content-Type": 'application/x-www-form-urlencoded',
      'Accept-Language': LanguageText.local()
    };
    final clientMethod = client.post(
      uri,
      headers: headers,
      body: body,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody;
  }*/

  @override
  Future<ProductDetailsModel> getProductDetails(String slug) async {
    final uri = Uri.parse(RemoteUrls.productDetail(slug));

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return ProductDetailsModel.fromMap(responseJsonBody);

    // try {
    //       } on TypeError catch (e) {
    //   debugPrint(e.toString());
    //   throw const ObjectToModelException(
    //       "Object to model data class convert exception");
    // } catch (e) {
    //   debugPrint(e.runtimeType.toString());
    //   debugPrint('error from remote data source file');
    //   throw const UnknowException('Unknown error');
    // }
  }

  // @override
  // Future<UserProfileInfo> getUpdatedInfo(String token) async {
  //   final uri = Uri.parse(RemoteUrls.userProfile(token));
  //
  //   final clientMethod = client.get(
  //     uri,
  //     headers: {'Accept-Language': LanguageText.local(), 'Content-Type': 'application/json'},
  //   );
  //   final responseJsonBody =
  //       await NetworkParser.callClientWithCatchException(() => clientMethod);
  //
  //   return UserProfileInfo.fromMap(responseJsonBody);
  // }

  @override
  Future<String> updateProfileInformation(
      Map<String, String> dataMap, String token) async {
    final uri = Uri.parse(RemoteUrls.updateProfile(token));

    final clientMethod = client.post(uri,
        headers: {'Accept': 'application/json'}, body: dataMap);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'] as String;
  }

  @override
  Future<CouponResponseModel> applyCoupon(String coupon, String token) async {
    final uri = Uri.parse(RemoteUrls.applyCoupon(coupon, token));
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return CouponResponseModel.fromMap(responseJsonBody['coupon']);
  }

  @override
  Future<String> decrementQuantity(String productId, String token) async {
    final uri = Uri.parse(RemoteUrls.decrementQuantity(productId, token));
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'];
  }

  @override
  Future<String> addToCart(AddToCartModel dataModel) async {
    final uri = Uri.parse(RemoteUrls.addToCart)
        .replace(queryParameters: dataModel.toMap());
    log(dataModel.toMap().toString(), name: "RDS");
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> cashOnDeliveryPayment(
      Map<String, dynamic> body, String token) async {
    final uri = Uri.parse(RemoteUrls.cashOnDelivery(token));
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    log(responseJsonBody.toString(), name: 'cashOnDeliveryPayment');

    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> payWithPaypal(Uri uri) async {
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    log(responseJsonBody.toString(), name: 'payWithPaypal');

    return responseJsonBody['approvalUrl'] as String;
  }

  @override
  Future<Map<String, dynamic>> payWithRazor(Uri uri) async {
    final clientMethod = client.get(
      uri,
      headers: {'Accept': 'application/json'},
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    log(responseJsonBody.toString(), name: 'payWithRazor');

    return responseJsonBody as Map<String, dynamic>;
  }

  @override
  Future<String> paypalSuccess(Uri uri) async {
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    log(responseJsonBody.toString(), name: 'paypalSuccess');

    return responseJsonBody['approvalUrl'] as String;
  }

  @override
  Future<String> incrementQuantity(String productId, String token) async {
    final uri = Uri.parse(RemoteUrls.incrementQuantity(productId, token));
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'];
  }

  @override
  Future<String> removerCartItem(String productId, String token) async {
    final uri = Uri.parse(RemoteUrls.removeCartItem(productId, token));
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'];
  }

  @override
  Future<CartResponseModel> getCartProducts(String token) async {
    final uri = Uri.parse(RemoteUrls.cartProduct(token));
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return CartResponseModel.fromMap(responseJsonBody);
  }

  @override
  Future<List<ProductModel>> getallSellerProductLists(String slug, int page, int perPage) async {
    final uri = Uri.parse(RemoteUrls.sellerProductsUrl(slug, page, perPage));
    print("--------- getallSellerProductLists URI ----------- ");
    print(uri);
    print("--------- getallSellerProductLists URI ----------- ");
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    
    final mapList = responseJsonBody['products']['data'] as List;

    return List<ProductModel>.from(mapList.map((e) => ProductModel.fromMap(e)));
  }

  @override
  Future<SellerProductModel> getSellerProductLists(String slug, int page, int perPage) async {
    final uri = Uri.parse(RemoteUrls.sellerDetailsUrl(slug, page, perPage));
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return SellerProductModel.fromMap(responseJsonBody);
  }

  @override
  Future<CheckoutResponseModel> getCheckoutData(
      String token, String couponCode) async {
    final uri = Uri.parse(RemoteUrls.cartCheckout(token, couponCode));
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return CheckoutResponseModel.fromMap(responseJsonBody);
  }

  @override
  Future<SearchResponseModel> searchProduct(Uri uri) async {
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    responseJsonBody['products']["max_price"] = responseJsonBody['max_price']?? 100000;
    return SearchResponseModel.fromMap(responseJsonBody['products']);
  }

  @override
  Future<AddressBook> getShipingAndBillingAddress(String token) async {
    final uri = Uri.parse(RemoteUrls.address(token));

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return AddressBook.fromMap(responseJsonBody);
  }

  @override
  Future<String> addAddress(
    Map<String, String> dataMap,
    String token,
  ) async {
    final uri = Uri.parse(RemoteUrls.addAddressUrl(token));

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: dataMap,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> updateAddress(
    String id,
    Map<String, String> dataMap,
    String token,
  ) async {
    final uri = Uri.parse(RemoteUrls.updateAddress(id, token));

    final clientMethod = client.put(
      uri,
      headers: {'Accept': 'application/json'},
      body: dataMap,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> billingUpdate(
    Map<String, String> dataMap,
    String token,
  ) async {
    final uri = Uri.parse(RemoteUrls.billingAddress(token));

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: dataMap,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> shippingUpdate(
    Map<String, String> dataMap,
    String token,
  ) async {
    final uri = Uri.parse(RemoteUrls.shippingAddress(token));

    final headers = {'Accept': 'application/json'};
    final clientMethod = client.post(
      uri,
      headers: headers,
      body: dataMap,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<List<WishListModel>> wishList(String token) async {
    final uri = Uri.parse(RemoteUrls.wishList(token));

    final headers = {'Accept': 'application/json'};
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    final wishlist = responseJsonBody['wishlists']['data'] as List?;
    if (wishlist == null) {
      return [];
    } else {
      return wishlist.map((e) {
        final mapData = e['product'] as Map<String, dynamic>;
        mapData.addAll({"wish_id": e['id']?.toInt() ?? 0});
        return WishListModel.fromMap(mapData);
      }).toList();
    }
  }

  @override
  Future<String> removeWishList(int id, String token) async {
    final uri = Uri.parse(RemoteUrls.removeWish(id, token));

    final headers = {'Accept': 'application/json'};
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> clearWishList(String token) async {
    final uri = Uri.parse(RemoteUrls.clearWishList(token));

    final headers = {'Accept': 'application/json'};
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> addWishList(int id, String token) async {
    final uri = Uri.parse(RemoteUrls.addWish(id, token));

    final headers = {'Accept': 'application/json'};
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'] as String;
  }

  @override
  Future<HomeModel> getHomeData() async {
    final uri = Uri.parse(RemoteUrls.homeUrl);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return HomeModel.fromMap(responseJsonBody);
  }

  @override
  Future<WebsiteSetupModel> websiteSetup() async {
    final uri = Uri.parse(RemoteUrls.websiteSetup);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    Map<String, dynamic> data = responseJsonBody['language'];
    data.forEach((key, value) {
      var newKey = key
          .toString()
          .replaceAll("-", " ")
          .replaceAll(",", "")
          .replaceAll(".", "")
          .replaceAll("'", "")
          .replaceAll("!", "")
          .replaceAll(' ', '_');
      myMap[newKey] = value;
    });
    return WebsiteSetupModel.fromMap(responseJsonBody);
  }

  @override
  Future<UserLoginResponseModel> signIn(Map body) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.userLogin);

    final clientMethod = client.post(uri, headers: headers, body: body);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return UserLoginResponseModel.fromMap(responseJsonBody);
  }

  @override
  Future<String> logOut(String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.userLogOut(token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'] as String;
  }

  @override
  Future<UserWithCountryResponse> userProfile(String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.userProfile(token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return UserWithCountryResponse.fromMap(responseJsonBody);
  }

  @override
  Future<String> passwordChange(
    ChangePasswordStateModel changePassData,
    String token,
  ) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.changePassword(token));

    final clientMethod =
        client.post(uri, headers: headers, body: changePassData.toMap());
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> profileUpdate(ProfileEditStateModel user, String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.updateProfile(token));

    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(user.toMap());

    request.headers.addAll(headers);
    if (user.image.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('image', user.image);
      request.files.add(file);
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'] as String;
  }

  @override
  Future<List<CountryStateModel>> statesByCountryId(
      String countryID, String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.stateByCountryId(countryID, token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['states'] as List;

    return List<CountryStateModel>.from(
        mapList.map((e) => CountryStateModel.fromMap(e)));
  }

  @override
  Future<List<CityModel>> citiesByStateId(String stateID, String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.citiesByStateId(stateID, token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['cities'] as List;

    return List<CityModel>.from(mapList.map((e) => CityModel.fromMap(e)));
  }

  @override
  Future<List<OrderModel>> orderList(String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.orderList(token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    final mapList = responseJsonBody['orders']['data'] as List;

    return List<OrderModel>.from(mapList.map((e) => OrderModel.fromMap(e)));
  }

  @override
  Future<OrderModel> getSingleOrder(String trackNumber, String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.singleOrder(trackNumber, token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return OrderModel.fromMap(responseJsonBody['order']);
  }

  @override
  Future<String> userRegister(Map<String, dynamic> userInfo) async {
    final uri = Uri.parse(RemoteUrls.userRegister);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: userInfo,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'];
  }

  @override
  Future<String> sendForgotPassCode(Map<String, dynamic> body) async {
    final uri = Uri.parse(RemoteUrls.sendForgetPassword);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'];
  }

  @override
  Future<String> setPassword(SetPasswordModel body) async {
    final uri = Uri.parse(RemoteUrls.storeResetPassword(body.code));

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body.toMap(),
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'];
  }

  @override
  Future<String> sendActiveAccountCode(String email) async {
    final uri = Uri.parse(RemoteUrls.resendRegisterCode);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: {'email': email},
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'];
  }

  @override
  Future<String> activeAccountCodeSubmit(String code) async {
    final uri = Uri.parse(RemoteUrls.userVerification(code));

    final clientMethod =
        client.get(uri, headers: {'Accept': 'application/json'});

    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'];
  }

  @override
  Future<AboutInformationModel> getAboutUsData() async {
    final uri = Uri.parse(RemoteUrls.aboutUs);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return AboutInformationModel.fromMap(responseJsonBody);
  }

  @override
  Future<bool> getContactUsMessageSend(ContactUsMessageModel body) async {
    final uri = Uri.parse(RemoteUrls.sendContactMessage);

    final clientMethod = client.post(
      uri,
      body: body.toMap(),
      headers: {'Accept': 'application/json'},
    );

    await NetworkParser.callClientWithCatchException(() => clientMethod);

    return true;
  }

  @override
  Future<ContactUsModel> getContactUsContent() async {
    final uri = Uri.parse(RemoteUrls.contactUs);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );

    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return ContactUsModel.fromMap(responseJsonBody['contact']);
  }

  @override
  Future<PrivacyPolicyAndTermConditionModel> getPrivacyPolicy() async {
    final uri = Uri.parse(RemoteUrls.privacyPolicy);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );

    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return PrivacyPolicyAndTermConditionModel.fromMap(
        responseJsonBody['privacyPolicy']);
  }

  @override
  Future<PrivacyPolicyAndTermConditionModel> getTermsAndCondition() async {
    final uri = Uri.parse(RemoteUrls.termsAndConditions);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );

    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return PrivacyPolicyAndTermConditionModel.fromMap(
        responseJsonBody['terms_conditions']);
  }

  @override
  Future<List<FaqModel>> getFaqList() async {
    final uri = Uri.parse(RemoteUrls.faq);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    final faqData = responseJsonBody['faqs'] as List?;
    return faqData != null
        ? faqData.map((e) => FaqModel.fromMap(e)).toList()
        : [];
  }

  @override
  Future<SubmitReviewResponseModel> submitReivew(
      Map<String, dynamic> reviewInfo, String token) async {
    final uri = Uri.parse(RemoteUrls.submitReviewUrl(token));

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: reviewInfo,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return SubmitReviewResponseModel.fromMap(responseJsonBody);
  }

  @override
  Future<ProductCategoriesModel> getCategoryProducts(
      String slug, int page, int perPage) async {
    final uri = Uri.parse(RemoteUrls.categoryProducts(slug, page, perPage));
      print("---------- getCategoryProducts --------------");
      print(uri);
      print("---------- getCategoryProducts --------------");
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return ProductCategoriesModel.fromMap(responseJsonBody);
  }

  @override
  Future<List<BrandModel>> getBrandLists() async {
    final uri = Uri.parse(RemoteUrls.brandLists);
    print("--- getBrandLists --");
    print(uri);
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    final mapList = responseJsonBody['brands'];

    return List<BrandModel>.from(
        mapList.map((e) => BrandModel.fromMap(e)));
  }

  @override
  Future<List<HomePageCategoriesModel>> getCategoryLists() async {
    final uri = Uri.parse(RemoteUrls.categoryLists);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    final mapList = responseJsonBody['categories'];

    return List<HomePageCategoriesModel>.from(
        mapList.map((e) => HomePageCategoriesModel.fromMap(e)));
  }

  @override
  Future<AddressModel> getSingleAddress(String id, String token) async {
    final uri = Uri.parse(RemoteUrls.singleAddress(id, token));

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return AddressModel.fromMap(responseJsonBody);
  }

  @override
  Future<String> deleteAddress(String id, String token) async {
    final uri = Uri.parse(RemoteUrls.singleAddress(id, token));

    final clientMethod = client.delete(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'];
  }

  @override
  Future<List<CountryModel>> getCountryList(String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.countryListUrl(token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['countries'] as List;

    return List<CountryModel>.from(mapList.map((e) => CountryModel.fromMap(e)));
  }

  @override
  Future<List<SubCategoryModel>> getSubCategoryLists(String id) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.subCategoryLists(id));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['subCategories'] as List;

    return List<SubCategoryModel>.from(
        mapList.map((e) => SubCategoryModel.fromMap(e)));
  }

  @override
  Future<List<ChildCategoryModel>> getChildCategoryLists(String id) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.childCategoryLists(id));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['childCategories'] as List;

    return List<ChildCategoryModel>.from(
        mapList.map((e) => ChildCategoryModel.fromMap(e)));
  }

  /*@override
  Future<String> stripePay(String token, Map<String, String> body) async {
    final uri = Uri.parse(RemoteUrls.payWithStripe(token));
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'];
  }*/

  @override
  Future<String> bankPay(String token, Map<String, String> body) async {
    final uri = Uri.parse(RemoteUrls.payWithBankUrl(token));
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body,
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'];
  }

  @override
  Future<SearchResponseModel> getHighlightProducts(String keyWord, int page, int perPage) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.highlightProductsUrl(keyWord, page, perPage));
    print("---- uri --- ");
    print(uri);
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    //final mapList = responseJsonBody['products']['data'] as List;
    return SearchResponseModel.fromMap(responseJsonBody['products']);
    //return List<ProductModel>.from(mapList.map((e) => ProductModel.fromMap(e)));
  }

  @override
  Future<SearchResponseModel> loadMoreProducts(
      String keyword, int page, int perPage) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.loadMoreProducts(keyword, page, perPage));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    //final mapList = responseJsonBody['products']['data'] as List;

    return SearchResponseModel.fromMap(responseJsonBody['products']);
    //return List<ProductModel>.from(mapList.map((e) => ProductModel.fromMap(e)));
  }

  @override
  Future<List<ProductModel>> getSubCategoryProducts(String slug) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.subCategoryProducts(slug));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['products']['data'] as List;

    return List<ProductModel>.from(mapList.map((e) => ProductModel.fromMap(e)));
  }

  @override
  Future<List<ProductModel>> filterSellerProducts(FilterModelDto dataModel, String seller, int page, int perPage) async {
    final uri = Uri.parse(RemoteUrls.filterUrl(page, perPage))
        .replace(queryParameters: dataModel.toMap("", seller, page, perPage));

  print("--- RemoteUrls.filterUrl -- ");
  print(uri);
  print("--- RemoteUrls.filterUrl -- ");

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['products']['data'] as List;

    return List<ProductModel>.from(mapList.map((e) => ProductModel.fromMap(e)));
  }

  @override
  Future<List<ProductModel>> filterProducts(FilterModelDto dataModel, String category, int page, int perPage) async {
    final uri = Uri.parse(RemoteUrls.filterUrl(page, perPage))
        .replace(queryParameters: dataModel.toMap(category, "", page, perPage));

  print("--- RemoteUrls.filterUrl -- ");
  print(uri);
  print("--- RemoteUrls.filterUrl -- ");

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['products']['data'] as List;

    return List<ProductModel>.from(mapList.map((e) => ProductModel.fromMap(e)));
  }

  @override
  Future<FlashModel> getFlashSale() async {
    final uri = Uri.parse(RemoteUrls.flashSaleUrl);

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return FlashModel.fromMap(responseJsonBody);
  }

  @override
  Future<List<ProductModel>> getBrandProducts(String slug, int page, int perPage) async {
    final uri = Uri.parse(RemoteUrls.brandProducts(slug, page, perPage));
    print(" ---- getBrandProducts ---- ");
    print(uri);
    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['products']['data'] as List;

    return List<ProductModel>.from(mapList.map((e) => ProductModel.fromMap(e)));
  }

  @override
  Future<EditAddressModel> editAddress(String id, String token) async {
    final uri = Uri.parse(RemoteUrls.editAddress(id, token));

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return EditAddressModel.fromMap(responseJsonBody);
  }

  @override
  Future<UserProfileInfo> getProfileInfo(String token) async {
    final uri = Uri.parse(RemoteUrls.userProfile(token));

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return UserProfileInfo.fromMap(responseJsonBody);
  }

  @override
  Future<List<SellerDto>> getAllCharts(String token) async {
    final uri = Uri.parse(RemoteUrls.allChartUrl(token));

    final clientMethod = client.get(
      uri,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['seller_list'] as List;

    return List<SellerDto>.from(mapList.map((e) => SellerDto.fromMap(e)));
  }

  @override
  Future<SendMessageResponseDto> sendMessageToSeller(
      Map<String, dynamic> mapBody, String token) async {
    final uri = Uri.parse(RemoteUrls.sendMsgToSeller(token));

    final clientMethod = client.post(
      uri,
      body: mapBody,
      headers: {
        'Accept-Language': LanguageText.local(),
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      },
    );
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);

    return SendMessageResponseDto.fromMap(responseJsonBody);
  }

  @override
  Future<String> deleteUserAccount(String token) async {
    final uri = Uri.parse(RemoteUrls.deleteUserAccount(token));
    final clientMethod = client.delete(uri);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'];
  }

  @override
  Future<String> becomeSellerRequest(
      String token, BecomeSellerStateModel body) async {
    final headers = {
      'Accept': 'application/json',
      'Accept-Language': LanguageText.local(),
      'Content-Type': 'application/json'
    };
    final uri = Uri.parse(RemoteUrls.becomeSellerRequest(token));

    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(body.toMap());

    request.headers.addAll(headers);
    if (body.bannerImage.isNotEmpty) {
      final file =
          await http.MultipartFile.fromPath('banner_image', body.bannerImage);
      request.files.add(file);
    }
    if (body.logo.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('logo', body.logo);
      request.files.add(file);
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'] as String;
  }
}
