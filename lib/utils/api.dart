//
//
//
import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

class Api {
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final HttpClient _httpClient = new HttpClient();
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }
      // The response is sent as a Stream of bytes that we need
      // to convert to a `String`.
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      // Finally, the string is parsed into a JSON object.
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}

final String _url = 'flutter.udacity.com';
// final String _url = '../assets/database/database.json';
Future main() async {
  final uri = new Uri.https(_url, "/currency");
  final api = new Api();
  final result = await api._getJson(uri);
  print("result is: $result");
}
