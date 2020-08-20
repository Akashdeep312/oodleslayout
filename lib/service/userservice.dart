import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:layoutoodles/models/users.dart';

class UserService {
  static Future<List<Users>> fetchUsers() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/users');

    if (response.statusCode == 200) {
      // if the server did return a 200 OK response,
      // then return userlist from response.
      return usersFromJson(response.body);
    } else {
      // if the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Users');
    }
  }
}
