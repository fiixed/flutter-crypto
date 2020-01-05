import 'dart:convert' as json;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List currencies;

  HomePage(this.currencies);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];

  Future<List> getCurrencies() async {
    String cryptoUrl = 'https://api.coinmarketcap.com/v1/ticker/?limit=50';
    http.Response response = await http.get(cryptoUrl);
    return json.jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto App'),
        elevation: defaultTheme.platform == TargetPlatform.iOS ? 0.0 : 5.0,
      ),
      body: _cryptoWidget(),
    );
  }

  Widget _cryptoWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: widget.currencies.length,
              itemBuilder: (BuildContext context, int index) {
                final Map currency = widget.currencies[index];
                final MaterialColor color = _colors[index % _colors.length];

                return _getListItemUi(currency, color);
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile _getListItemUi(Map currency, MaterialColor color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(currency['name'][0]),
      ),
      title: Text(
        currency['name'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: _getSubtitleText(
        currency['price_usd'],
        currency['percent_change_1h'],
      ),
      isThreeLine: true,
    );
  }

  Widget _getSubtitleText(String priceUSD, String percentageChange) {
    TextSpan priceTextWidget = TextSpan(
      text: '\$$priceUSD\n',
      style: TextStyle(color: Colors.black),
    );
    String percentageChangeText = '1 hour: $percentageChange%';
    TextSpan percentageChangeTextWidget;

    if (double.parse(percentageChange) > 0) {
      percentageChangeTextWidget = TextSpan(
        text: percentageChangeText,
        style: TextStyle(color: Colors.green),
      );
    } else {
      percentageChangeTextWidget = TextSpan(
          text: percentageChangeText, style: TextStyle(color: Colors.red));
    }

    return RichText(
      text: TextSpan(children: [priceTextWidget, percentageChangeTextWidget]),
    );
  }
}
