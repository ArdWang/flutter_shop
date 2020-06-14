import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cart_info.dart';
import '../model/cart_list.dart';

class CartProvider with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cartList = [];

  List<CartListModel> cartList12 = [];
  save(goodsId, goodsName, count, price, images) async {
    //try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cartString = prefs.getString('cartInfo');
      print(cartString);
      var temp=cartString==null?[]:json.decode(cartString.toString());

      List tempList = (temp as List).cast();
      //cartList12 = CartListModel.toModel(tempList);

      bool isHave = false;
      int ival = 0;

      tempList.forEach((item) {
        if (item['goodsId'] == goodsId) {
          tempList[ival]['count'] = item['count'] + 1;
          //cartList[ival].count++;
          isHave = true;
        }
        ival++;
      });

      if (!isHave) {
        tempList.add({
          'goodsId': goodsId,
          'goodsName': goodsName,
          'count': count,
          'price': price,
          'images': images
        });
      }

      cartString = json.encode(tempList).toString();
      print(cartString);

      prefs.setString('cartInfo', cartString);
    //}catch(e){

    //}

    notifyListeners();

  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('cartInfo');
    print('清空完成------------------');
    notifyListeners();
  }
}
