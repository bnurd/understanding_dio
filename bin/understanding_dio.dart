import 'package:dio/dio.dart';

void main(List<String> arguments) async {
  final dio = Dio();
  dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print('istek gönderildi');
      handler.next(options);
    },
    onResponse: (response, handler) {
      print('cevap alındı');
      print(response);
      handler.next(response);
    },
    onError: (e, handler) async {
      if (e.response.statusCode == 404) {
        /* 
        dio.interceptors.requestLock.lock();
        dio.interceptors.responseLock.lock();
 */
        var options = Options(headers: e.requestOptions.headers, method: e.requestOptions.method);
/* 
        dio.interceptors.requestLock.unlock();
        dio.interceptors.responseLock.unlock(); */

        var res = await dio.request('/todos/1', options: options);
        return handler.resolve(res);
      }

      handler.next(e);
    },
  ));

  var res = await dio.get('/todos/x');
  print(res.data);
  print('continue');
}
