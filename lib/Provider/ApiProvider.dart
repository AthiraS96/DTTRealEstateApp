import 'dart:convert';
import 'package:dtt_real_estate/Items/House.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://intern.d-tt.nl/api/house";
  final String accessKey = "98bww4ezuzfePCYFxJEWyszbUXc7dxRx";

  Future<List<House>> fetchHouses() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Access-Key': '$accessKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(response.body);
      return data.map((json) => House.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load houses');
    }
  }
}
