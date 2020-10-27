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

  Future<Map<String, String>> getExchangeRates(String currency) async {
    Map<String, String> rates = Map();

    for (String crypto in cryptoList) {
      http.Response res =
          await http.get("$_apiBaseUrl/$crypto/$currency?apikey=$_apiKey");

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        rates[crypto] = data["rate"].toStringAsFixed(2);
      } else {
        throw "${res.statusCode}: No exchange rates found";
      }
    }

    return rates;
  }
}
