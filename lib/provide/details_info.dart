import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import '../config/service_url.dart';
import 'dart:convert';

class DetailsInfoProvider with ChangeNotifier{
  DetailsModel goodsInfo = null;

  //从后台获取商品数据

  getGoodsInfo(String id){
    var formData = {'goodId':id};

    request(getGoodDetailById, formData:formData).then((value){
      var responseData = json.decode(value.toString());
      print(responseData);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

} 



