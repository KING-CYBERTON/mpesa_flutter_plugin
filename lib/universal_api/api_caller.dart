import 'dart:convert';
import 'package:http/http.dart' as http;

//taken from https://github.com/komuw/zakah

class RequestHandler {
  ///setup values
  final String consumerKey;
  final String consumerSecret;
  final String b64keySecret;
  final String baseUrl;

  late String mAccessToken;
  DateTime? mAccessExpiresAt;

  ///For instantiation, create the key secret on the fly with received values.

  RequestHandler(
      {required this.consumerKey,
      required this.consumerSecret,
      required this.baseUrl})
      : b64keySecret =
            base64Url.encode((consumerKey + ":" + consumerSecret).codeUnits);

  Uri getAuthUrl() {
    ///Basically merges the various components of the provided params
    ///to generate one link for getting credentials before placing a request.
    Uri uri = new Uri(
        scheme: 'https',
        host: baseUrl,
        path: '/oauth/v1/generate',
        queryParameters: <String, String>{'grant_type': 'client_credentials'});
    return uri;
  }

  String generatePassword(
      {required String mPassKey,
      required String mShortCode,
      required String actualTimeStamp}) {
    ///Adds up the paybill no., the timestamp & passkey to generate a base64
    ///code to be added to the request body as unique password to auth
    ///the request in question.
    String readyPass = mShortCode + mPassKey + actualTimeStamp;

    var bytes = utf8.encode(readyPass);
    return base64.encode(bytes);
  }

  Future<void> setAccessToken() async {
    /// This method ensures that the token is in place before any request is
    /// placed.
    /// When called, it first checks if the previous token exists, if so, is it valid?
    /// if still valid(by expiry time measure), terminates to indicate that
    /// the token is set and ready for usage.
    DateTime now = new DateTime.now();
    if (mAccessExpiresAt != null) {
      if (now.isBefore(mAccessExpiresAt!)) {
        return;
      }
    }

    final response = await http.get(getAuthUrl(), headers: {
      "Accept": "application/json",
      "Authorization": "Basic ${b64keySecret}",
    });

    // if (response.statusCode == 200) {
    //   dynamic jsondecodeBody = jsonDecode(response.body);
    //   mAccessToken = jsondecodeBody["ac cess_token"].toString();
    //   mAccessExpiresAt = now.add(new Duration(
    //     seconds: int.parse(jsondecodeBody["expires_in"].toString())));
    // } else {
    //   throw Exception('Failed to fetch access token');
    // }
  }

  Uri generateSTKPushUrl() {
    Uri uri = new Uri(
        scheme: 'https',
        host: baseUrl,
        path: 'mpesa/stkpush/v1/processrequest');
    return uri;
  }

  // Future<Map<String, String>> mSTKRequest({
  //   required String mBusinessShortCode,
  //   required String nPassKey,
  //   required String mTransactionType,
  //   required String mTimeStamp,
  //   required double mAmount,
  //   required String partyA,
  //   required String partyB,
  //   required String mPhoneNumber,
  //   required Uri mCallBackURL,
  //   required String mAccountReference,
  //   String? mTransactionDesc
  // }) async {
  //   await setAccessToken();

  //   final stkPushPayload = {
  //     "BusinessShortCode": mBusinessShortCode,
  //     "Password": generatePassword(
  //         mShortCode: mBusinessShortCode, mPassKey: nPassKey, actualTimeStamp: mTimeStamp),
  //     "Timestamp": mTimeStamp,
  //     "Amount": mAmount,
  //     "PartyA": partyA,
  //     "PartyB": partyB,
  //     "PhoneNumber": mPhoneNumber,
  //     "CallBackURL": mCallBackURL.toString(),
  //     "AccountReference": mAccountReference,
  //     "TransactionDesc": mTransactionDesc ?? "",
  //     "TransactionType": mTransactionType
  //   };
  //   final Map<String, String> result = {};

  //   final response = await http.post(generateSTKPushUrl(),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $mAccessToken"
  //       },
  //       body: jsonEncode(stkPushPayload));

  //   dynamic mJsonDecodeBody = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     result["MerchantRequestID"] = mJsonDecodeBody["MerchantRequestID"].toString();
  //     result["CheckoutRequestID"] = mJsonDecodeBody["CheckoutRequestID"].toString();
  //     result["ResponseCode"] = mJsonDecodeBody["ResponseCode"].toString();
  //     result["ResponseDescription"] = mJsonDecodeBody["ResponseDescription"].toString();
  //     result["CustomerMessage"] = mJsonDecodeBody["CustomerMessage"].toString();
  //   } else {
  //     result["requestId"] = mJsonDecodeBody["requestId"].toString();
  //     result["errorCode"] = mJsonDecodeBody["errorCode"].toString();
  //     result["errorMessage"] = mJsonDecodeBody["errorMessage"].toString();
  //   }

  //   return result;
  // }
}
