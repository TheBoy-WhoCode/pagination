import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pagination/constants/app_constants.dart';

enum Method { POST, GET, PUT, DELETE, PATCH }

const BASE_URL = "";

class HttpClient {
  late Dio _dio;

  static header() => {"Content-Type": "application/json"};

  Future<HttpClient> init() async {
    _dio = Dio(BaseOptions(baseUrl: BASE_URL, headers: header()));
    initInterceptors();
    return this;
  }

  void initInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        logger.d("REQUEST[${options.method}] => PATH: ${options.path}, "
            " => Requset values: ${options.queryParameters}, => HEADERS: ${options.headers}");
        return handler.next(options);
      }, onResponse: (response, handler) {
        logger.d("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
        return handler.next(response);
      }, onError: (error, handler) {
        logger.d("ERROR[${error.response?.statusCode}]");
        return handler.next(error);
      }),
    );
  }

  Future<dynamic> request(
      String url, Method method, Map<String, dynamic>? params) async {
    Response response;

    try {
      if (method == Method.POST) {
        response = await _dio.post(url, data: params);
      } else if (method == Method.PATCH) {
        response = await _dio.patch(url);
      } else if (method == Method.DELETE) {
        response = await _dio.delete(url);
      } else {
        response = await _dio.get(url, queryParameters: params);
      }

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something wen't wrong");
      }
    } on SocketException {
      throw Exception("No Internet connection");
    } on FormatException {
      throw Exception("Bad Response format");
    } on DioError catch (e) {
      logger.e(e);
      throw Exception(e);
    } catch (e) {
      logger.e(e);
      throw Exception("Something wen't wrong");
    }
  }
}
