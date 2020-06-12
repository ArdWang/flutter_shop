import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {

  const DetailsTopArea({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try{
      var goodsInfo = Provider.of<DetailsInfoProvider>(context,listen: true).goodsInfo.data.goodInfo;
      
        if(goodsInfo !=null ){
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImage(goodsInfo.image1),
                _goodsName(goodsInfo.goodsName),
                _goodsNum(goodsInfo.goodsSerialNumber),
                _goodsPrice(goodsInfo.presentPrice, goodsInfo.oriPrice)
              ],
            ),
          );
        }else{
          return Text('正在加载中.....');
        }
    }catch(e){
      return Text("正在加载中....");
    }
  }

  // 商品图片
  Widget _goodsImage(url){
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740.0),

    );
  }

  //商品名称
  Widget _goodsName(name){
    return Container(
      width: ScreenUtil().setWidth(740.0),
      padding: EdgeInsets.only(left:15.0),
      child: Text(
        name,
        style:TextStyle(
          fontSize: ScreenUtil().setSp(30.0)
        ),
      ),
    );
  }

  //商品编号
  Widget _goodsNum(num){
    return Container(
      width: ScreenUtil().setWidth(730.0),
      padding: EdgeInsets.only(left:15.0),
      margin: EdgeInsets.only(top:8.0),
      child: Text(
        '编号：${num}',
        style:TextStyle(
          color:Colors.black12,
        ),
      ),
    );
  }

  //商品价格
  Widget _goodsPrice(presentPrice, oriPrice) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 8),
      child: Row(
        children: <Widget>[
          Text(
            '￥$presentPrice',
            style: TextStyle(
                color: Colors.deepOrangeAccent, fontSize: ScreenUtil().setSp(40)),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(35),
          ),
          Text('市场价：',
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenUtil().setSp(30))),
          SizedBox(
            width: ScreenUtil().setWidth(25),
          ),
          Text(
            '￥$oriPrice',
            style: TextStyle(
                color: Colors.black26,
                fontSize: ScreenUtil().setSp(35),
                decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

}