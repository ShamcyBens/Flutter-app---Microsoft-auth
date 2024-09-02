import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import 'message_list_screen.dart';

class AuthService {
  final String clientId = '54856745-010f-4f93-bbed-18bd50ae4ce1';
  final String tenantId = '35f1f37c-39e4-473f-aa04-b69304f53ad2';
  final String redirectUri = 'https://cloudcenterglobal.sharepoint.com/sites/MessageCentre';
  final String clientSecret = 'RYr8Q~A6zzv2rFDeTa1OBQabQ.gE1rl8mYHdmXde';

  final Logger _logger = Logger('AuthService');

  AuthService() {
    // Configure the logger
    Logger.root.level = Level.ALL; // Log all messages
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<String?> login(BuildContext context) async {
    final url = Uri.https(
      'login.microsoftonline.com',
      '/$tenantId/oauth2/v2.0/authorize',
      {
        'client_id': clientId,
        'response_type': 'code',
        'redirect_uri': redirectUri,
        'response_mode': 'query',
        'scope': 'User.Read Sites.Read.All',
        'state': '12345',
      },
    ).toString();

    _logger.info('Auth URL: $url');

    try {
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: 'https',
      );

      _logger.info('Auth Result: $result');

      final code = Uri.parse(result).queryParameters['code'];

      if (code == null) {
        throw Exception('No code returned from Microsoft');
      }

      _logger.info('Auth Code: $code');

      final tokenUrl = 'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token';
      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'scope': 'https://graph.microsoft.com/.default',
          'code': code,
          'redirect_uri': redirectUri,
          'grant_type': 'authorization_code',
          'client_secret': clientSecret,
        },
      );

      _logger.info('Token Response: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to get token');
      }

      final tokenData = json.decode(response.body);
      final accessToken = tokenData['access_token'];

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => MessageListScreen(token: accessToken)),
      );

      return accessToken;
    } catch (e) {
      _logger.severe('Login Error: $e');
      rethrow;
    }
  }
}

