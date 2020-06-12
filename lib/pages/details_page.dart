import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/details_tabbar.dart';


class DetailsPage extends StatelessWidget {

  final String goodsId;

  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          '商品详细页'
        ),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Container(
              child: ListView(
                children: <Widget>[
                  DetailsTopArea(),
                  DetailsExplain(),
                  DetailsTabBar(),
                ],
              ),
            );
          }else{
            return Text('加载中....');
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async{
    await Provider.of<DetailsInfoProvider>(context,listen: false).getGoodsInfo(goodsId);
    return '完成加载';
  }

}