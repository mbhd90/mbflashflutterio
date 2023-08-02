import './fr.dart';
import './en.dart';
import 'dart:io' show Platform;

class LanguageText {
  static String local() {
    String languageCode = Platform.localeName.split('_')[0];
    return languageCode;
  }

  static bool isFr() {
    return LanguageText.local() == "fr";
  }

  static String noInternet() {
    return isFr() ? Fr.noInternet : En.noInternet;
  }

  static String dataFormatException() {
    return isFr() ? Fr.dataFormatException : En.dataFormatException;
  }

  static String requestTimeout() {
    return isFr() ? Fr.requestTimeout : En.requestTimeout;
  }

  static String serviceUnavailable() {
    return isFr() ? Fr.serviceUnavailable : En.serviceUnavailable;
  }

  static String requestNotFound() {
    return isFr() ? Fr.requestNotFound : En.requestNotFound;
  }

  static String methodNotAllowed() {
    return isFr() ? Fr.methodNotAllowed : En.methodNotAllowed;
  }

  static String internalServerError() {
    return isFr() ? Fr.internalServerError : En.internalServerError;
  }

  static String errorWithServer() {
    return isFr() ? Fr.errorWithServer : En.errorWithServer;
  }

  static String unknownError() {
    return isFr() ? Fr.unknownError : En.unknownError;
  }

  static String credentialsNotMatch() {
    return isFr() ? Fr.credentialsNotMatch : En.credentialsNotMatch;
  }

  static String notCachedYet() {
    return isFr() ? Fr.notCachedYet : En.notCachedYet;
  }

  static String waitStartSendingCode() {
    return isFr() ? Fr.waitStartSendingCode : En.waitStartSendingCode;
  }

  static String waitSendingCode() {
    return isFr() ? Fr.waitSendingCode : En.waitSendingCode;
  }

  static String customerReview() {
    return isFr() ? Fr.customerReview : En.customerReview;
  }

  static String bannerProducts() {
    return isFr() ? Fr.bannerProducts : En.bannerProducts;
  }

  static String notification() {
    return isFr() ? Fr.notification : En.notification;
  }

  static String activeLocation() {
    return isFr() ? Fr.activeLocation : En.activeLocation;
  }

  static String language() {
    return isFr() ? Fr.language : En.language;
  }

  static String oneClicKLogin() {
    return isFr() ? Fr.oneClicKLogin : En.oneClicKLogin;
  }

  static String darkMode() {
    return isFr() ? Fr.darkMode : En.darkMode;
  }
}
