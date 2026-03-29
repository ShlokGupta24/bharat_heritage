import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const url = 'https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd000001bc8ddd549e7e466e55b288106bb080ed&format=json&limit=5';
  final response = await http.get(Uri.parse(url));
  final data = json.decode(response.body);
  print(data['records'][0]);
}
