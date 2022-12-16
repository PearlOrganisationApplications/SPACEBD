import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'model/api_model.dart';

class GetData {
  static Future<DataModel?> getInfoData() async {
    Map mapData = {
      'key': Constants.key,
      'code': Constants.code,
      'erp_name': Constants.erpName,
      'app_name': Constants.appName
    };
    final response =
        await http.post(Uri.parse(Constants.pageUrl), body: mapData);
    if (response.statusCode == 200) {
      return DataModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error");
    }
    return null;
  }
}
