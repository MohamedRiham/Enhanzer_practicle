import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> postRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      // Send POST request with a timeout
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      // Categorize response status codes
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success
        return jsonDecode(response.body);

      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Client-side errors
        throw Exception(
          'Client Error: ${response.statusCode} - ${response.reasonPhrase}\nResponse: ${response.body}',
        );
      } else if (response.statusCode >= 500) {
        // Server-side errors
        throw Exception(
          'Server Error: ${response.statusCode} - ${response.reasonPhrase}\nResponse: ${response.body}',
        );
      } else {
        // Unexpected status code
        throw Exception(
          'Unexpected Error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on http.ClientException catch (e) {
      // Handle client exceptions
      throw Exception('Client Exception: $e');
    } on TimeoutException catch (e) {
      // Handle timeout
      throw Exception('Request Timeout: $e');
    } catch (error) {
      // Handle all other errors
      throw Exception('Failed to perform POST request: $error');
    }
  }
}
