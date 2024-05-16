import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

Dio dio = Dio();

Future<Response> getIt(
  String url,
) async {
  Logger().i(url);
  final result = await dio.get(url);
  Logger().d(result.data);
  return result;
}

Future<Response> postIt(
  String url,
) async {
  Logger().i(url);
  final result = await dio.post(url);
  Logger().d(result.data);
  return result;
}
