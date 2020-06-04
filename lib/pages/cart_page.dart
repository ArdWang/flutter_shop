import 'package:flutter/material.dart';
//import 'package:provide/provide.dart';

import 'package:provider/provider.dart';
import '../provide/content.dart';
//import '../provide/content.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          children:<Widget>[
            Number(),
            MyButton(),
          ],
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //Counter c = Provider.of<Counter>(context);
    return Container(
      margin: EdgeInsets.only(top:200),
      child: Text(
            '${context.watch<Counter>().value}',
            style: Theme.of(context).textTheme.headline4,
          ),
      
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: (){
          context.read<Counter>().increment();
        },
        child: Text('递增'),
      ),
    );
  }
}