import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/child_category.dart';
//import 'package:provide/provide.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
//import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
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
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _leftInkWell(context, index);
        },
        itemCount: list.length,
      ),
    );
  }

  Widget _leftInkWell(BuildContext context, int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        context.read<ChildCategory>().getChildCategory(childList, categoryId);
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(
          left: 10.0,
          top: 20.0,
        ),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
          ),
        ),
      ),
    );
  }

  //调试接口
  void _getCategory() async {
    await request(category).then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      //list.data.forEach((item)=>print(item.mallCategoryName));

      setState(() {
        list = category.data;
      });
      context
          .read<ChildCategory>()
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };

    await request(getMallGoods, formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      context.read<CategoryGoodsListProvider>().getGoodsList(goodsList.data);
    });
  }
}

//右边分类 小类右侧导航
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
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _rightInkWell(index, list[index]);
        },
      ),
    );
  }

  //点击
  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick =
        (index == context.read<ChildCategory>().childIndex) ? true : false;
    return InkWell(
      onTap: () {
        context.read<ChildCategory>().changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isClick ? Colors.pink : Colors.black,
          ),
        ),
      ),
    );
  }

  void _getGoodsList(String categorySubId) async {
      var data = {
        'categoryId': context.read<ChildCategory>().categoryId,
        'categorySubId': categorySubId,
        'page': 1
      };

      await request(getMallGoods, formData: data).then((val) {
        var data = json.decode(val.toString());
        CategoryGoodsListModel goodsList =
            CategoryGoodsListModel.fromJson(data);
        if (goodsList.data == null) {
          context.read<CategoryGoodsListProvider>().getGoodsList([]);
        } else {
          context
              .read<CategoryGoodsListProvider>()
              .getGoodsList(goodsList.data);
        }
      });
    }

}

//商品列表 可以上拉加载效果
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  var scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryListData> list =
        context.watch<CategoryGoodsListProvider>().goodsList;
    try{
      if(context.watch<ChildCategory>().page==1){
        //把列表位置 放到最上边
        scrollController.jumpTo(0.0);
      }
    }catch(e){
      print('进入页面第一次初始化:${e}');
    }
    if (list.length > 0) {
      return Expanded(
        child: Container(
          width: ScreenUtil().setWidth(570),
          child: EasyRefresh(
            footer: ClassicalFooter(
                bgColor: Colors.white,
                textColor: Colors.pink,
                infoColor: Colors.pink,
                loadedText: '加载完成',
                loadReadyText: '上拉加载...',
                loadingText: '正在加载...',
                loadFailedText: '加载失败',
                noMoreText: context.watch<ChildCategory>().noMoreText,
                infoText: '更新于 %T'),
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                return _listItemWidget(list, index);
              },
              itemCount: list.length,
            ),
            onLoad: () async {
              print('上拉加载更多....');
              _getMoreList();
            },
          ),
        ),
      );
    } else {
      return Text(
        '现在还没有数据!',
      );
    }

  }

  void _getMoreList() async {
      context.read<ChildCategory>().addPage();
      var data = {
        'categoryId': context.read<ChildCategory>().categoryId,
        'categorySubId': context.read<ChildCategory>().subId,
        'page': context.read<ChildCategory>().page
      };

      await request(getMallGoods, formData: data).then((val) {
        var data = json.decode(val.toString());
        CategoryGoodsListModel goodsList =
            CategoryGoodsListModel.fromJson(data);
        if (goodsList.data == null) {
          Fluttertoast.showToast(
            msg: '已经到底了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          context.read<ChildCategory>().changeNoMore('没有更多了!');
        } else {
          context
              .read<CategoryGoodsListProvider>()
              .getMoreList(goodsList.data);
        }
      });
    }
  

  Widget _goodsImage(List list, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  Widget _goodsName(List list, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28),
        ),
      ),
    );
  }

  Widget _goodsPrice(List list, index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          Text(
            '价格: ￥${list[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${list[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _listItemWidget(List list, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(list, index),
            Column(
              children: <Widget>[
                _goodsName(list, index),
                _goodsPrice(list, index),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
