import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination/features/home/controller/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagination"),
      ),
      body: Obx(
        () {
          return ListView.builder(
            controller: controller.scroll,
            itemBuilder: (context, index) {
              if (controller.loadMore &&
                  controller.articles.length - 1 == index) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListTile(
                title: Text(controller.articles[index].title!),
              );
            },
            itemCount: controller.articles.length,
          );
        },
      ),
    );
  }
}
