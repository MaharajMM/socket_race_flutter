import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;

void initSocket() {
  socket =
      IO.io('https://socketrace-production.up.railway.app', <String, dynamic>{
    'transports': ['websocket'],
    //'autoConnect': false,
  });
}
// 10.0.2.2