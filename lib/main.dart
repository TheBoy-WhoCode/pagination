import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination/core/network/http_client.dart';
import 'package:pagination/features/home/view/home_view.dart';

void main() {
  initService();
  runApp(const MyApp());
}

initService() async {
  await Get.putAsync<HttpClient>(() => HttpClient().init());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}
