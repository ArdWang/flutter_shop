import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/child_category.dart';
//import 'package:provide/provide.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../model/category.dart';


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
            Column(
              children: <Widget>[
                RightCategoryNav(),
              ],
            ),
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

  var listIndex = 0;

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
          return _leftInkWell(context,index);
        },
        itemCount: list.length,
      ),
    );
  }


  Widget _leftInkWell(BuildContext context,int index){
    bool isClick = false;
    isClick = (index == listIndex)?true:false;
    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        context.read<ChildCategory>().getChildCategory(childList);

      },
      child: Container(
        height:ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(
          left:10.0,
          top:20.0,
        ),
        decoration: BoxDecoration(
          color: isClick?Colors.black12:Colors.white,
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

//右边分类
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  //List list = ['名酒','宝丰','北京二锅头','舍得','五粮液','茅台','剑蓝春','三百'];

  @override
  Widget build(BuildContext context) {
    final list = context.watch<ChildCategory>().childCategoryList;
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
        color:Colors.white,
        border:Border(
          bottom:BorderSide(
            width:1,
            color:Colors.black12,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index){
          return _rightInkWell(list[index]);
        },
      ),
    );
  }

  //点击
  Widget _rightInkWell(BxMallSubDto item){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child:Text(
          item.mallSubName,
          style: TextStyle(
            fontSize:ScreenUtil().setSp(28),
          ),
        ),
      ),
    );
  }

}