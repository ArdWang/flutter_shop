import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

//https://www.easy-mock.com 模拟器请求接口

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();

  String showText = '欢迎你来到美好人间高级会所';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('美好人间'),
        ),
        body: SingleChildScrollView( //解决界面溢出的问题
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: '美女类型',
                      helperText: '请输入你喜欢的类型'),
                  autofocus: false,
                ),
                RaisedButton(
                  onPressed: _choiceAction,
                  child: Text('选择完毕'),
                ),
                Text(
                  showText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _choiceAction() {
    print('开始选择你喜欢的类型...........');
    if (typeController.text.toString() == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text("美女类型不能为空!")));
    } else {
      getHttp(typeController.text.toString()).then((val) {
        setState(() {
          showText = val['data']['name'].toString();
        });
      });
    }
  }

  // Future getHttp(String typeText) async {
  //   try {
  //     Response response;
  //     var data = {'name': typeText};
  //     response = await Dio().get(
  //         'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian',
  //         queryParameters: data);

  //     return response.data;
  //   } catch (e) {
  //     return print(e);
  //   }
  // }

   Future getHttp(String typeText) async {
    try {
      Response response;
      var data = {'name': typeText};
      response = await Dio().post(
          'https://www.easy-mock.com/mock/5ed2357f2dc586778abb2e23/bsshop/post_dabaojian',
          queryParameters: data);

      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}
