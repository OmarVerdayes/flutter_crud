import 'dart:convert';
import 'package:http/http.dart' as http;

class DataHelper {

  var url = "https://7j6rqe8mkd.execute-api.us-east-1.amazonaws.com/Prod/lambda/";



  Future<http.Response> addVehicle(String marcaC, String modeloC, String tipoC, String materialC) async {
    Map<String, String> data = {
      "marca": marcaC,
      "modelo": modeloC,
      "tipo": tipoC,
      "material": materialC
    };

    var body = json.encode(data);
    try {
      var response = await http.post(
        Uri.parse(url),
        body: body,
      );
      return response;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<http.Response> updateVehicle(String id, String marcaC, String modeloC, String tipoC, String materialC) async {
    Map<String, String> data = {
      "id": id,
      "marca": marcaC,
      "modelo": modeloC,
      "tipo": tipoC,
      "material": materialC
    };
    print('${data}');
    var body = json.encode(data);
    print('${body}');
    try {
      var response = await http.put(
        Uri.parse(url),
        body: body,
      );
      return response;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<http.Response> deleteVehicle(String id) async {
    Map<String, String> data = {
      "id": id,
    };
    var body = json.encode(data);
    try {
      var response = await http.delete(
        Uri.parse(url),
        body: body,
      );
      return response;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
