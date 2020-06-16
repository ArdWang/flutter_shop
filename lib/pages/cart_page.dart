import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provide/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

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

            return Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index){
                    return CartItem(cartList[index]);
                  }
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                ),
              ],
            );
          }else{
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async{
    await Provider.of<CartProvider>(context, listen: false).getCartInfo();
    return 'end';
  }




}