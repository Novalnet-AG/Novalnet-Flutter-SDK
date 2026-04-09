import 'novalnetsdk_platform_interface.dart';
import 'package:flutter/material.dart';
import 'config_loader.dart';
import 'screens/google_pay_handler.dart';
import 'screens/apple_pay_handler.dart';
import 'screens/credit_card_handler.dart';

class NovalnetSDK {
  Future<String?> getPlatformVersion() {
    return NovalnetsdkPlatform.instance.getPlatformVersion();
  }

  static Future<dynamic> openWalletPaymentHandler(
    BuildContext context, {
    Map<String, dynamic>? bodyParams,
    required String paymentType,
    required Map<String, dynamic> token,
  }) async {
    Map<String, dynamic> finalParams = {};

    // Priority: manual > yaml
    if (bodyParams != null && bodyParams.isNotEmpty) {
      finalParams = bodyParams;
    } else {
      finalParams = await ConfigLoader.loadConfig();
    }

    if (finalParams.isEmpty) {
      return {"status": "FAILURE", "message": "Missing payment configuration"};
    }

    if (paymentType == 'GOOGLEPAY') {
      return await GooglePayHandler.startPayment(
        context,
        finalParams,
        token,
        paymentType,
      );
    } else if (paymentType == 'APPLEPAY') {
      return await ApplePayHandler.startPayment(
        context,
        finalParams,
        token,
        paymentType,
      );
    }
  }

  static Future<dynamic> openCreditCard(
    BuildContext context, {
    Map<String, dynamic>? bodyParams,
    required String paymentType,
  }) async {
    Map<String, dynamic> finalParams = {};

    // Priority: manual > yaml
    if (bodyParams != null && bodyParams.isNotEmpty) {
      finalParams = bodyParams;
    } else {
      finalParams = await ConfigLoader.loadConfig();
    }

    if (finalParams.isEmpty) {
      return {"status": "FAILURE", "message": "Missing payment configuration"};
    }

    return await CreditCardHandler.handleRedirect(
      context,
      paymentType: paymentType,
      bodyParams: finalParams,
    );
  }
}
