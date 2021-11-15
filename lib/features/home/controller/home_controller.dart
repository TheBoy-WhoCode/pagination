import 'package:get/get.dart';
import 'package:pagination/constants/app_constants.dart';
import 'package:pagination/core/network/http_client.dart';
import 'package:pagination/features/home/model/article_model.dart';
import 'package:dio/dio.dart' as d;

class HomeController extends GetxController with StateMixin, ScrollMixin {
  final _articles = <Article>[].obs;
  var page = 1;
  var loadMore = true;
  late final httpClient;

  @override
  void onInit() {
    httpClient = HttpClient();
    loadData();
    super.onInit();
  }

  loadData() async {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['pageSize'] = 10;
    map['apiKey'] = "f8a44a81a0bf4accae1c84801bc178ec";
    map['country'] = "us";

    try {
      final result = await httpClient.request("top-headlines", Method.GET, map);

      if (result != null) {
        if (result is d.Response) {
          var data = articleModelFromJson(result.data);
          logger.d(data);
          if (data != null) {
            _articles.addAll(data.articles ?? []);
            loadMore = true;
          } else {
            loadMore = false;
          }
        }
      } else {
        loadMore = false;
      }
    } on Exception catch (e) {
      logger.e(e);
      Get.snackbar("Error", "$e");
    }
  }

  @override
  Future<void> onEndScroll() async {
    if (loadMore) {
      page++;
      await loadData();
    }
    logger.i("onEndScroll: Called");
  }

  @override
  Future<void> onTopScroll() async {
    logger.i("OnTopScroll: called");
  }
}
