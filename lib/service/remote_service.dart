import 'package:http/http.dart' as http;
import 'package:sneaker_apps/models/SneakerModel.dart';

class RemoteService {
  Future<List<Sneaker>?> getSneakers() async {
    var client = http.Client();

    var uri = Uri.parse('https://shoes-api-liard.vercel.app/shoes');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return sneakerFromJson(json);
    } else {
      return <Sneaker>[];
    }
  }
}
