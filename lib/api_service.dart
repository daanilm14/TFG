import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String _baseUrl = "http://localhost/api.php";

  //Método para obtener un usuario según el id
  static Future getUserById(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl?action=get_usuario&id=$id"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }

}