import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetails = Provider.of<DetailsInfoProvider>(context, listen: true)
        .goodsInfo
        .data
        .goodInfo
        .goodsDetail;
    var isLeft = Provider.of<DetailsInfoProvider>(context, listen: true).isLeft;
    var isRight =
        Provider.of<DetailsInfoProvider>(context, listen: true).isRight;

    if (isLeft) {
      return Container(
        child: Html(data: goodsDetails),
      );
    }else{
      return Container(
        width: ScreenUtil().setWidth(750),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text('展示没有数据'),
      );
    }
  }
}
