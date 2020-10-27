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
  'LTC',
];

class CoinData {
  static final String _apiBaseUrl = "https://rest.coinapi.io/v1/exchangerate";
  static final String _apiKey = "<API-key-goes-here>";

  Future<dynamic> getData(String base, String quote) async {
    http.Response res =
        await http.get("$_apiBaseUrl/$base/$quote?apikey=$_apiKey");

    return jsonDecode(res.body);
  }
}
