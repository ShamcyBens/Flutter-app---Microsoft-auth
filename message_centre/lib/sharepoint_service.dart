import 'package:http/http.dart' as http;
import 'dart:convert';

class SharePointService {
  final String siteId = 'fdcb2ee4-2a99-4415-b1e1-4a5fed0108fe';
final String listId = '7f280fb8-0b92-454f-8f13-df8d5e280fe7';
  Future<List<dynamic>> fetchMessages(String token, String userDisplayName) async {
    final url =
        'https://graph.microsoft.com/v1.0/sites/$siteId/lists/$listId/items?expand=fields';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['value']
          .where((item) => item['fields']['Userr'] == userDisplayName)
          .toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> markAsRead(String token, String itemId) async {
    final url = 'https://graph.microsoft.com/v1.0/sites/$siteId/lists/$listId/items/$itemId';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'Redd': 'Yes',
        },
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to mark message as read');
    }
  }
}
