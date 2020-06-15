import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provide/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<String> testList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List cartList = Provider.of<CartProvider>(context, listen: true).cartList;
            return ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index){
                return ListTile(
                   title: Text(cartList[index].goodsName), 
                );
              },
            );
          }else{
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async{
    await Provider.of<CartProvider>(context, listen: true).getCartInfo();
    return 'end';
  }




}