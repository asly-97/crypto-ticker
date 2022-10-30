import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'BNB',
  'CAKE',
];

class CoinData {
  static final String _coin_api_url = 'https://rest.coinapi.io/v1/exchangerate';

  //First apikey
  static final String _apikey = '46BECF70-0113-480D-A958-B102F5E921E8';
  //Second apikey
  //static final String _apikey = '0022E030-55F8-4038-9313-CE531C10A268';

  static Future getCoinData({
    required String coin,
    required String currency,
  }) async {
    String url = '$_coin_api_url/$coin/$currency?apikey=$_apikey';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw 'Problem with the get request!';
    }

    String body = response.body;
    var data = jsonDecode(body);

    double rate;
    try {
      rate = data['rate'];
    } catch (e) {
      print(e);
      return '?';
    }
    return rate.toInt();
  }
}
