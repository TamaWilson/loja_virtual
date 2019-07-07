import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:http/http.dart' as http;

class ShipCard extends StatefulWidget {
  @override
  _ShipCardState createState() => _ShipCardState();
}

class _ShipCardState extends State<ShipCard> {

  double normal;
  double express;

  int _radioValue;
  String userCep;

  @override
  void initState()  {
    super.initState();
    userCep =  UserModel.of(context).userData["cep"];
     _getShip("04510", userCep).then((value) {
      normal = value;
    });
     _getShip("04014", userCep).then((value) {
      express = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _handleRadioValueChange(int value) {
      setState(() {
        _radioValue = value;

        switch (_radioValue) {
          case 0:
            CartModel.of(context).setShipPrice(normal);
            break;
          case 1:
            CartModel.of(context).setShipPrice(express);
            break;
        }
      });
    }

    return Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            title: Text(
              "Cálcular Frete",
              textAlign: TextAlign.start,
              style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
            leading: Icon(Icons.location_on),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text("Normal")
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text("Expresso")
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        );
  }

  Future<double> _getShip(String type, String cep) async {
    String url =
        "http://www.onfoccus.com.br/flutter/calculador-frete-flutter.php?"
        "key=lojaFlutter&servico=$type&cep_origem=$cep&cep_destino=70040001&comprimento=20&altura=5&largura=15&peso=3";

    http.Response response = await http.get(url);
    Map<String, dynamic> data = json.decode(response.body);
    double price = double.parse(data["valor"]);

    return price;
  }
}
