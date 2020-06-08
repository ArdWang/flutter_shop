import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/content.dart';
import './pages/index_page.dart';
import 'package:provider/provider.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
//import 'package:provide/provide.dart';
//import './provide/content.dart';
import './routers/routers.dart';
import './routers/application.dart';


void main(){
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>Counter()),
        ChangeNotifierProvider(create: (_)=>ChildCategory()),
        ChangeNotifierProvider(create: (_)=>CategoryGoodsListProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: Material(
        child: MaterialApp(
           title:'百姓生活+',

            onGenerateRoute: Application.router.generator,

           debugShowCheckedModeBanner:false,
           theme: ThemeData(
             primaryColor:Colors.pink,
           ),
           home: IndexPage(),
        ),
      ),
    );
  }
}

