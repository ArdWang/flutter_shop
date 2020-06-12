import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DetailsTabBar extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    var isLeft = Provider.of<DetailsInfoProvider>(context,listen: true).isLeft;
    var isRight = Provider.of<DetailsInfoProvider>(context,listen: true).isRight;

    return Container(
      margin: EdgeInsets.only(top:15.0),
      child: Row(
        children:<Widget>[
          _myTabBarLeft(context, isLeft),
          _myTabBarRight(context, isRight),
        ],
      ),
    );
  }

  //左边的TabBar
  Widget _myTabBarLeft(BuildContext context, bool isLeft){
    return InkWell(
      onTap: (){
        Provider.of<DetailsInfoProvider>(context, listen: false).changeLeftAndRight("left");
      },

      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
           bottom: BorderSide(
             width: 1.0,
             color: isLeft?Colors.pink:Colors.black12
           ), 
          ),
        ),
        child: Text(
          '详情',
          style: TextStyle(
            color: isLeft?Colors.pink:Colors.black12,
          ),
        ),
      ),
    );
  }

   //右边的TabBar
  Widget _myTabBarRight(BuildContext context, bool isRight){
    return InkWell(
      onTap: (){
        Provider.of<DetailsInfoProvider>(context, listen: false).changeLeftAndRight("right");
      },

      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
           bottom: BorderSide(
             width: 1.0,
             color: isRight?Colors.pink:Colors.black12
           ), 
          ),
        ),
        child: Text(
          '评论',
          style: TextStyle(
            color: isRight?Colors.pink:Colors.black12,
          ),
        ),
      ),
    );
  }

}
