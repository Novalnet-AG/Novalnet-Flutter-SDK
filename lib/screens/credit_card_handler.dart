import 'package:flutter/material.dart';
import 'package:novalnetsdk/novalnet_util.dart';
import '../novalnet_payment_params.dart';
import 'hosted_payment_page.dart';

class CreditCardHandler {
  static Future<Map<String, dynamic>?> handleRedirect(
    BuildContext context, {
    required String paymentType,
    required Map<String, dynamic> bodyParams,
  }) async {
    try {
      final paymentRequest = NovalnetPaymentParams().nnGetParams(
        bodyParams: bodyParams,
        paymentType: paymentType,
      );

      final response = await NovalnetUtil.sendRequest(
        paymentRequest,
        bodyParams["payment_action"],
        bodyParams["access_key"],
      );

      if (response.isEmpty ||
          (response["status"] == "FAILURE") ||
          (response["result"]?["status"] == "FAILURE")) {
        return NovalnetUtil.getErrorMessage(response, bodyParams["lang"]);
      }

      String redirectUrl = response["result"]?["redirect_url"] ?? "";

      if (redirectUrl.isEmpty) {
        return {
          "status": "FAILURE",
          "message": NovalnetUtil.localize(
            "REDIRECT_URL_EMPTY",
            bodyParams["lang"],
          ),
        };
      }

      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HostedPaymentPage(
            url: redirectUrl,
            accessKey: bodyParams["access_key"] ?? "",
            returnUrl: bodyParams["return_url"] ?? "",
            errorReturnUrl: bodyParams["error_return_url"] ?? "",
            lang: bodyParams["lang"] ?? "en",
          ),
        ),
      );
    } catch (e) {
      return {"status": "FAILURE", "message": "Something went wrong $e"};
    }
  }
}
