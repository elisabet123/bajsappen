import 'dart:io';

import 'package:bajsappen/poop.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String url =
    'https://0o8oj4xmff.execute-api.eu-west-1.amazonaws.com/default/bajsappen';

// curl -XPUT https://0o8oj4xmff.execute-api.eu-west-1.amazonaws.com/default/bajsappen --data-binary '{"person":"abc", "poop":{"dateTime":567, "hardness":5}}' -H 'Content-Type:application/json'
// only int, no float
class Remote {
  addPoop(Poop poop) {}

  Future<List<Poop>> getAllPoops() async {
    return [];
  }

  deletePoop(Poop poop) async {}
}

class RemoteStorage extends Remote {
  final String prefix;

  RemoteStorage(this.prefix);

  addPoop(Poop poop) async {
    Map body = {'person': prefix, 'poop': poop.asMap()};
    http.Response response = await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw new HttpException(
          "could not add, status code: ${response.statusCode}");
    }
  }

  Future<List<Poop>> getAllPoops() async {
    http.Response response = await http.get(url + '?person=' + prefix,
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      List<Poop> poopList = [];
      list.forEach((element) => poopList.add(new Poop(
          DateTime.fromMillisecondsSinceEpoch(element['dateTime']),
          element['hardness'],
          element['rating'])));

      return poopList;
    }
    throw new HttpException("OH NO ${response.statusCode}");
  }

  deletePoop(Poop poop) async {
    http.Response response = await http.delete(
        '$url?person=$prefix&poop=${poop.dateTime.millisecondsSinceEpoch}');
    if (response.statusCode != 200) {
      throw new HttpException(
          "could not delete, status code: ${response.statusCode}");
    }
  }
}
