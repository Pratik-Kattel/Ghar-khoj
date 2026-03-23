import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:frontend/constants/api_endpoints.dart';
import 'package:frontend/services/api_clients.dart';
import 'package:frontend/services/get_user_data.dart';

class StripeService {
  final ApiClient apiClient;

  StripeService._({required this.apiClient});

  static late StripeService instance;

  static void init(ApiClient apiClient) {
    instance = StripeService._(apiClient: apiClient);
  }

  Future<bool> makePayment({
    required String houseId,
    required double amount,
    required String startDate,
    required String endDate
  }) async {
    try {
      final email = await GetUserDataRepo.getUserEmail();
      if (email == null) throw Exception("User not logged in");

      final res = await apiClient.post(ApiEndpoints.createPaymentIntent, {
        "amount": amount.toInt(),
        "currency": "usd",
        "houseId": houseId,
        "userEmail": email,
        "startDate":startDate,
        "endDate":endDate
      });

      final clientSecret = res["clientsecret"];
      if (clientSecret == null) throw Exception("No client secret");

      // Step 2 — Init payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "GharKhoj",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final paymentIntentId = clientSecret.split("_secret_")[0];

      final confirmRes = await apiClient.post(ApiEndpoints.confirmPayment, {
        "paymentIntentId": paymentIntentId,
        "houseId": houseId,
        "userEmail": email,
        "startDate":startDate,
        "endDate":endDate
      });

   if (kDebugMode) {
     print("Payment confirmed: $confirmRes");
   }
      return true;
    } on StripeException catch (e) {
      if (kDebugMode) {
        print("Stripe ERROR TYPE: ${e.error.code}");
      }
      if (kDebugMode) {
        print("Stripe ERROR MESSAGE: ${e.error.message}");
      }
      if (kDebugMode) {
        print("Stripe ERROR DETAILS: ${e.error.localizedMessage}");
      }
      return false;
    } catch (e) {
       print("Payment error TYPE: ${e.runtimeType}");
       print("Payment error DETAIL: $e");
      return false;
    }
  }
}
