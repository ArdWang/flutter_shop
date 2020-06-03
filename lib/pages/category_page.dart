import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    //_getCategory();
    return Scaffold(
      appBar: AppBar(
        title:Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
          ],
        ),
      ),
    );
  }
}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List list = [];

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border:Border(
          right:BorderSide(width:1, color:Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemBuilder: (context, index){
          return _leftInkWell(index);
        },
        itemCount: list.length,
      ),
    );
  }


  Widget _leftInkWell(int index){
    return InkWell(
      onTap: (){},
      child: Container(
        height:ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(
          left:10.0,
          top:20.0,
        ),
        decoration: BoxDecoration(
          color:Colors.white,
          border:Border(
            bottom:BorderSide(width:1.0, color:Colors.black12),
          ),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(
            fontSize:ScreenUtil().setSp(28),
          ),
        ),
      ),
    );
  }


   //调试接口
  void _getCategory() async{
    await request(category).then((val){
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      //list.data.forEach((item)=>print(item.mallCategoryName));

      setState(() {
        list = category.data;
      });

    });
  }

}