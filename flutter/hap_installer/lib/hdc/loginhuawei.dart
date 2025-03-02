import 'dart:io';
import 'dart:async';

class Server {
  Future<void> start() async {
    var port = 8888;
    var server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    print('Listening on localhost:${port}');
    await for (var request in server) {
      if (request.uri.path == '/hello') {
        request.response
          ..statusCode = HttpStatus.ok
          ..write('Hello, Flutter HTTP Server!')
          ..close();
      } else {
        // 如果路径不匹配，返回 404
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('404 Not Found')
          ..close();
      }
    }
  }
}
