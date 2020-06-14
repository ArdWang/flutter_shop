import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import '../config/service_url.dart';
import 'dart:convert';

class DetailsInfoProvider with ChangeNotifier{
  DetailsModel goodsInfo;

  bool isLeft = true;
  bool isRight = false;

  //tabbar的切换方法
  changeLeftAndRight(String changeState){
    if(changeState=='left'){
      isLeft = true;
      isRight = false;
    }else{
      isRight = true;
      isLeft = false;
    }
    notifyListeners();
  }


  //从后台获取商品数据
  getGoodsInfo(String id) async{
    var formData = {'goodId':id};

    await request(getGoodDetailById, formData:formData).then((value){
      var responseData = json.decode(value.toString());
      print(responseData);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

} 



