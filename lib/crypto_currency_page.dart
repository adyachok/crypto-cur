import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:numbers_stack/crypto_currency.dart';

class CryptoCurrencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CryptoCurrencyState();
  }
}

class CryptoCurrencyState extends State<CryptoCurrencyPage> {
  List<CryptoCurrency> cryptoCyrrecies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto currency tracker'),
      ),
      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sync),
        onPressed: _getCryptoCurrencyRates,
      ),
    );
  }

  void _getCryptoCurrencyRates() async {
    final response =
        await http.get('http://api.coinmarketcap.com/v2/ticker/?limit=10');

    if (response.statusCode == 200) {
      var data =
          ((json.decode(response.body) as Map)['data'] as Map<String, dynamic>);
      List<CryptoCurrency> currencies = [];
      data.forEach((String idx, dynamic val) {
        var rec = CryptoCurrency(
            name: val['name'],
            symbol: val['symbol'],
            rank: val['rank'],
            price: val['quotes']['USD']['price']);
        currencies.add(rec);
      });
      setState(() => this.cryptoCyrrecies = currencies);
    }
  }

  List<Widget> _buildList() {
    List<Widget> widgets = [];
    for (CryptoCurrency cur in this.cryptoCyrrecies) {
        var widget = ListTile(
          title: Text(cur.symbol),
          subtitle: Text(cur.name),
          leading: CircleAvatar(child: Text(cur.rank.toString()),),
          trailing: Text('\$${cur.price.toStringAsFixed(2)}'),
        );
        widgets.add(widget);
    }
    return widgets;
  }

  @override
  void initState() { 
    super.initState();
    this._getCryptoCurrencyRates();
  }
}
