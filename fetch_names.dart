import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const url = 'https://data.unesco.org/api/explore/v2.1/catalog/datasets/whc001/records?limit=43&lang=en&refine=region%3A%22Asia%20and%20the%20Pacific%22&refine=states_names%3A%22India%22';
  try {
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    final results = data['results'] as List;
    for (var res in results) {
       print(res['name_en']);
    }
  } catch (e) {
    print(e);
  }
}
