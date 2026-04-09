import 'package:flutter/foundation.dart';

class NovalnetPaymentParams {
  Map<String, dynamic> nnGetParams({
    required Map<String, dynamic> bodyParams,
    required String paymentType,
  }) {
    Map billing = bodyParams["billing"] ?? {};
    Map shipping = bodyParams["shipping"] ?? {};

    Map<String, dynamic> billingFormatted = {
      "city": billing["city"] ?? "",
      "country_code": billing["country_code"] ?? "",
      "house_no": billing["house_no"] ?? "",
      "street": billing["street"] ?? "",
      "zip": billing["zip"] ?? "",
    };

    Map<String, dynamic> shippingFormatted = {
      "city": shipping["city"] ?? "",
      "country_code": shipping["country_code"] ?? "",
      "house_no": shipping["house_no"] ?? "",
      "street": shipping["street"] ?? "",
      "zip": shipping["zip"] ?? "",
    };

    List walletPayments = ['GOOGLEPAY', 'APPLEPAY'];
    Map<String, dynamic> body = {
      "merchant": {
        "signature": bodyParams["signature"] ?? "",
        "tariff": bodyParams["tariff"] ?? "",
      },

      "customer": {
        "first_name": bodyParams["first_name"] ?? "",
        "last_name": bodyParams["last_name"] ?? "",
        "email": bodyParams["email"] ?? "",
        "birth_date": bodyParams["birth_date"] ?? "",
        "customer_no": bodyParams["customer_no"] ?? "",
        "tel": bodyParams["tel"] ?? "",
        "billing": billingFormatted,
        "shipping": shippingFormatted,
      },

      "transaction": {
        "payment_type": paymentType,
        "amount": bodyParams["amount"] ?? "",
        "order_no": bodyParams["order_no"] ?? "",
        "currency": bodyParams["currency"] ?? "",
        "test_mode": bodyParams["test_mode"] ?? "",
        "system_name": "NN_FLUTTER_SDK",
      },
      "custom": {"lang": bodyParams["lang"] ?? "EN"},
    };

    if (paymentType == "CREDITCARD") {
      Map<String, dynamic> hostedpage = {
        "display_payments": [paymentType],
        "skip_pages": ['CONFIRMATION_PAGE', 'SUCCESS_PAGE'],
        "hide_blocks": [
          'ADDRESS_FORM',
          'SHOP_INFO',
          'LANGUAGE_MENU',
          'HEADER',
          'TARIFF',
          "CANCEL_BUTTON",
        ],
      };
      final cssUrl = bodyParams["css_url"]?.toString();
      if (cssUrl != null && cssUrl.isNotEmpty) {
        hostedpage["css_url"] = cssUrl;
      }
      body["hosted_page"] = hostedpage;
    }
    Map<String, dynamic> transaction = body["transaction"];

    if (paymentType == "CREDITCARD") {
      transaction["return_url"] = bodyParams["return_url"] ?? "";
      transaction["error_return_url"] = bodyParams["error_return_url"] ?? "";
      body["transaction"] = transaction;
    }

    if (billing.isNotEmpty &&
        shipping.isNotEmpty &&
        mapEquals(billing, shipping)) {
      Map<String, dynamic> customer = body["customer"];
      customer["shipping"] = {"same_as_billing": "1"};
      body["customer"] = customer;
    }

    // Credit Card
    if (paymentType == "CREDITCARD") {
      transaction["payment_action"] = bodyParams["payment_action"] ?? "";
      transaction["enforce_3d"] = bodyParams["enforce_3d"] ?? "";
      body["transaction"] = transaction;
    }

    // Wallet Payments
    if (walletPayments.contains(paymentType)) {
      transaction["create_token"] = 1;
      transaction["payment_data"] = {
        "wallet_token": bodyParams["wallet_token"] ?? "",
      };
      body["transaction"] = transaction;
    }
    return body;
  }
}
