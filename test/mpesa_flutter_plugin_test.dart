// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
// import 'package:mpesa_flutter_plugin/payment_enums.dart';
// import 'dart:convert';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   const MethodChannel channel = MethodChannel('mpesa_flutter_plugin');

//   setUp(() {
//     // Mock the method call handler for the platform channel.
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       // Simulate a successful response from the M-Pesa STK push request.
//       if (methodCall.method == 'initializeMpesaSTKPush') {
//         return jsonEncode({
//           'MerchantRequestID': '12345',
//           'CheckoutRequestID': '67890',
//           'ResponseCode': '0',
//           'ResponseDescription': 'Success. Request accepted for processing',
//           'CustomerMessage': 'Success. Request accepted for processing',
//         });
//       }
//       return null;
//     });
//   });

//   tearDown(() {
//     // Clean up the mock method call handler.
//     channel.setMockMethodCallHandler(null);
//   });

//   test('initializeMpesaSTKPush', () async {
//     // Set up the M-Pesa consumer key and secret.
//     MpesaFlutterPlugin.setConsumerKey('vwHm2YcbY1wWwUf78SAA98aZF0JWG9je');
//     MpesaFlutterPlugin.setConsumerSecret('kvN0RNOGn4sX4rgM');

//     // Define the required parameters for the STK push request.
//     final businessShortCode = '174379';
//     final transactionType = TransactionType.CustomerPayBillOnline;
//     final amount = 1.0;
//     final partyA = '254712345678';
//     final partyB = '174379';
//     final callBackURL = Uri.parse('https://example.com/callback');
//     final accountReference = 'account_reference';
//     final transactionDesc = 'test transaction';
//     final phoneNumber = '254707709923';
//     final baseUri = Uri.parse('https://sandbox.safaricom.co.ke');
//     final passKey =
//         'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';

//     // Perform the STK push request and verify the response.
//     final response = await MpesaFlutterPlugin.initializeMpesaSTKPush(
//       businessShortCode: businessShortCode,
//       transactionType: transactionType,
//       amount: amount,
//       partyA: partyA,
//       partyB: partyB,
//       callBackURL: callBackURL,
//       accountReference: accountReference,
//       transactionDesc: transactionDesc,
//       phoneNumber: phoneNumber,
//       baseUri: baseUri,
//       passKey: passKey,
//     );

//     expect(response, {
//       'MerchantRequestID': '12345',
//       'CheckoutRequestID': '67890',
//       'ResponseCode': '0',
//       'ResponseDescription': 'Success. Request accepted for processing',
//       'CustomerMessage': 'Success. Request accepted for processing',
//     });
//   });
// }
