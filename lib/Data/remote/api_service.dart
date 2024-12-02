import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final http.Client httpClient;

  ApiService({required this.baseUrl, required this.httpClient});

  Future<Map<String, dynamic>> request({
    required String endpoint,
    String method = 'GET',
    String? customUrl,
    dynamic body, // Allow binary data or JSON
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers, // Allow custom headers
  }) async {
    // Construct URL with query parameters if provided
    Uri url;
    if (queryParameters != null) {
      url = Uri.parse('$baseUrl$endpoint').replace(
          queryParameters: queryParameters
              .map((key, value) => MapEntry(key, value.toString())));
    } else if (customUrl != null) {
      url = Uri.parse(customUrl);
    } else {
      url = Uri.parse('$baseUrl$endpoint');
    }

    late http.Response response;
    final defaultHeaders = {'Content-Type': 'application/json'};
    final mergedHeaders =
        headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    switch (method.toUpperCase()) {
      case 'POST':
        response = await httpClient.post(url,
            body: body is Map<String, dynamic> ? jsonEncode(body) : body,
            headers: mergedHeaders);
        break;
      case 'PUT':
        response =
            await httpClient.put(url, body: body, headers: mergedHeaders);
        break;
      case 'DELETE':
        response = await httpClient.delete(url, headers: mergedHeaders);
        break;
      case 'GET':
      default:
        response = await httpClient.get(url, headers: mergedHeaders);
        break;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {}; // Return an empty map for non-JSON responses
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
