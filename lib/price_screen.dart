import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, String> exchangeRates = Map();
  String selectedCurrency = "USD";
  bool isWaiting = true;
  CoinData coinData = CoinData();

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> items = currenciesList
        .map((currency) =>
            DropdownMenuItem(child: Text(currency), value: currency))
        .toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        // Avoid unnecessary loading.
        if (selectedCurrency != value) {
          updateCoinData();
          setState(() {
            selectedCurrency = value;
          });
        }
      },
    );
  }

  CupertinoPicker getPicker() {
    List<Text> items =
        currenciesList.map((currency) => Text(currency)).toList();

    return CupertinoPicker(
      itemExtent: 32.0,
      children: items,
      onSelectedItemChanged: (index) {
        // Avoid unnecessary loading.
        if (selectedCurrency != currenciesList[index]) {
          updateCoinData();
          setState(() {
            selectedCurrency = currenciesList[index];
          });
        }
      },
    );
  }

  Widget getCryptoCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoList
          .map((crypto) => CryptoCard(
                cryptoCurrency: crypto,
                selectedCurrency: selectedCurrency,
                rate: isWaiting ? "?" : exchangeRates[crypto],
              ))
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    updateCoinData();
  }

  void updateCoinData() async {
    try {
      isWaiting = true;
      var data = await coinData.getExchangeRates(selectedCurrency);
      isWaiting = false;
      // await is not allowed inside setState.
      setState(() {
        exchangeRates = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getCryptoCards(),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 40.0),
            color: Colors.green,
            child: Platform.isIOS ? getPicker() : getDropdownButton(),
          )
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key key,
    @required this.cryptoCurrency,
    @required this.selectedCurrency,
    @required this.rate,
  }) : super(key: key);

  final String cryptoCurrency;
  final String selectedCurrency;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
      child: Card(
        color: Colors.lightGreen,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Text(
            '1 $cryptoCurrency = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
