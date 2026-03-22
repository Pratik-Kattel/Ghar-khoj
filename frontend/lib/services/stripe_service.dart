// import 'package:frontend/constants/stripe_keys.dart';
// import 'package:frontend/services/api_clients.dart';
//
// class StripeService {
//   final ApiClient apiClient;
//   StripeService._({required this.apiClient});
//
//   static late StripeService instance;
//   static void init(ApiClient apiClient){
//     instance=StripeService._(apiClient: apiClient);
//   }
//
//   Future<void> makePayment() async{
//     try{
//       String? result=await _createPaymentIntent(10, "usd");
//     }
//     catch(e){
//       print(e);
//     }
//   }
//   Future<String?> _createPaymentIntent(int amount,String currency) async{
//     try{
//       var res=await apiClient.post("https://api.stripe.com/v1/payment_intents", {
//         "amount":_calculateAmount(amount),
//         "currency":currency,
//       },
//       headers: {
//         "Authorization":"Bearer$secretKey",
//         "Content_Type":"application/x-www-form-urlencoded"
//       }
//       );
//       print(res);
//       return res['client_secret'];
//     }
//     catch(e){
//       print(e);
//     }
//     return null;
//
//   }
//   String _calculateAmount(int amount){
//     final calculatedAmount=amount*100;
//     return calculatedAmount.toString();
//   }
// }