import 'package:flutter/material.dart';
import 'package:flutter_shop/config/service_url.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;

  List<Map> hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  String homePageContentes = '正在获取数据';

  //默认经纬度
  var formData = {'lon': '32.162746', 'lat': '118.703763'};

  @override
  void initState() {
    super.initState();
    //_getHotGoods();
    print('11111');
  }

  @override
  Widget build(BuildContext context) {
    // print('设备像素密度：${ScreenUtil.pixelRatio}');
    // print('设备的高：${ScreenUtil.screenHeight}');
    // print('设备宽：${ScreenUtil.screenWidth}');

    return Scaffold(
      appBar: AppBar(title: Text('百胜生活+')),
      body: FutureBuilder(
        future: request(homePageContent, formData: formData),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navgatorList = (data['data']['category'] as List).cast();
            String adPicture =
                data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommandList =
                (data['data']['recommend'] as List).cast();
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];

            List<Map> floor1List = (data['data']['floor1'] as List).cast();
            List<Map> floor2List = (data['data']['floor2'] as List).cast();
            List<Map> floor3List = (data['data']['floor3'] as List).cast();

            return EasyRefresh(
                /*header: ClassicalHeader(
                  refreshText: '下拉刷新',
                  refreshReadyText: '释放刷新',
                  refreshingText: '正在刷新...',
                  refreshedText: '刷新完成',
                  refreshFailedText: '刷新失败',
                  noMoreText: '没有更多',
                  infoText: '更新于 %T',
                ),*/
                footer: ClassicalFooter(
                    loadedText: '加载完成',
                    loadReadyText: '释放加载',
                    loadingText: '正在加载...',
                    loadFailedText: '加载失败',
                    noMoreText: '',
                    infoText: '更新于 %T'),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(
                      swiperDataList: swiper,
                    ),
                    TopNavgator(navgatorList: navgatorList),
                    AdBanner(adPicture: adPicture),
                    LeaderPhone(
                        leaderImage: leaderImage, leaderPhone: leaderPhone),
                    Recommend(recommendList: recommandList),
                    FloorTitle(picture_address: floor1Title),
                    FloorContent(floorGoodsList: floor1List),
                    FloorTitle(picture_address: floor2Title),
                    FloorContent(floorGoodsList: floor2List),
                    FloorTitle(picture_address: floor3Title),
                    FloorContent(floorGoodsList: floor3List),
                    _hotGoods(),
                  ],
                ),
                onLoad: () async {
                  print('开始加载更多......');
                  var formData = {'page': page};
                  await request(homePageBelowConten, formData: formData)
                      .then((val) {
                    var data = json.decode(val.toString());
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                });
          } else {
            return Center(
              child: Text('加载中....'),
            );
          }
        },
      ),
    );
  }

  // void _getHotGoods() {
  //   var formData = {'page': page};
  //   request(homePageBelowConten, formData: formData).then((val) {
  //     var data = json.decode(val.toString());
  //     List<Map> newGoodsList = (data['data'] as List).cast();
  //     setState(() {
  //       hotGoodsList.addAll(newGoodsList);
  //       page++;
  //     });
  //   });
  // }

  //标题界面
  Widget hotTitle = Container(
    margin: EdgeInsets.only(
      top: 10.0,
    ),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text(
      '🔥火爆专区',
      style: TextStyle(
        fontSize: 20.0,
      ),
    ),
    padding: EdgeInsets.all(
      5.0,
    ),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  val['image'],
                  width: ScreenUtil().setWidth(370),
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '￥${val['mallPrice']}',
                    ),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                        color: Colors.black26,
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        //流式布局
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  //获取热销商品数据
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

// 首页轮播图片
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            '${swiperDataList[index]['image']}',
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// TopNavigator
class TopNavgator extends StatelessWidget {
  final List navgatorList;

  TopNavgator({Key key, this.navgatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navgatorList.length > 10) {
      this.navgatorList.removeLast();
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navgatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告Banner
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcherURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launcherURL() async {
    String url = 'tel:' + leaderPhone;
    //String url = 'http://jspang.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问.异常';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  const Recommend({Key key, this.recommendList}) : super(key: key);

  //标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 4.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12),
          )),
      child: Text('商品推荐',
          style: TextStyle(
            color: Colors.pink,
          )),
    );
  }

  //商品单独项方法
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表方法
  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(386),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList(),
        ],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;

  const FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

//楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods(),
        ],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
          onTap: () {
            print('点击了楼层');
          },
          child: Image.network(goods['image'])),
    );
  }
}
