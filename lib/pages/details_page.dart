import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provide/details_info.dart';

class DetailsPage extends StatelessWidget {

  final String goodsId;

  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Container(
      child: Center(
        child:Text('商品id为: ${goodsId}'),
      ),
    );
  }

  void _getBackInfo(BuildContext context) async{
    await Provider.of<DetailsInfoProvider>(context,listen: true).getGoodsInfo(goodsId);
    print('加载完成!.......');
  }

}