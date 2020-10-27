import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  double rate = -1.0;
  CoinData coinData = CoinData();

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> items = currenciesList
        .map((c) => DropdownMenuItem(child: Text(c), value: c))
        .toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        updateCoinData();
      },
    );
  }

  CupertinoPicker getPicker() {
    List<Text> items = currenciesList.map((c) => Text(c)).toList();

    return CupertinoPicker(
      itemExtent: 32.0,
      children: items,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = items[index].data;
        });
        updateCoinData();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateCoinData();
  }

  void updateCoinData() async {
    var data = await coinData.getData("BTC", selectedCurrency);
    setState(() {
      rate = data["rate"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Text(
                  '1 BTC = ${rate > 0.0 ? rate.toStringAsFixed(2) : "?"} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 40.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getPicker() : getDropdownButton(),
          )
        ],
      ),
    );
  }
}
