import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.first;

  Map<String, dynamic> coinRate = Map<String, dynamic>();

  Widget iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) pickerItems.add(Text(currency));

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList.elementAt(selectedIndex);
          updateCoinsData();
        });
      },
      children: pickerItems,
    );
  }

  Widget androidDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      items.add(DropdownMenuItem(
        value: currency,
        child: Text(currency),
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          updateCoinsData();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    for (String coin in cryptoList) {
      coinRate[coin] = '?';
    }

    updateCoinsData();
  }

  void updateCoinsData() async {
    coinRate.forEach((coin, rate) async {
      coinRate[coin] = '?';
      var newRate =
          await CoinData.getCoinData(coin: coin, currency: selectedCurrency);
      setState(() {
        coinRate[coin] = newRate;
      });
    });
  }

  Widget coinCardList() {
    List<Widget> list = [];
    for (String coin in cryptoList) {
      list.add(Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $coin = ${coinRate[coin]} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
    return Column(
      children: list,
    );
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
          coinCardList(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
