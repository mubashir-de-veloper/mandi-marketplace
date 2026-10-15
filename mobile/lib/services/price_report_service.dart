
import 'dart:convert';

import 'package:http/http.dart' as http;

class PriceReportService {
  static const String baseUrl = 'https://mandi-marketplace-api.vercel.app';

  static const Map<String, int> cityIds = {
    'Karachi': 1,
    'Lahore': 2,
    'Rawalpindi': 3,
    'Multan': 4,
  };

  static const Map<String, int> commodityIds = {
    'Wheat': 1,
    'Rice': 2,
    'Maize': 3,
    'Cotton': 4,
    'Potato': 5,
    'Onion': 6,
    'Tomato': 7,
    'Apple': 9,
    'Banana': 10,
    'Mango': 11,
    'Sugarcane': 12,
  };

  Future<Map<String, dynamic>> submitReport({
    required String token,
    required String city,
    required String commodity,
    required double price,
    required String unit,
    String? notes,
  }) async {
    final cityId = cityIds[city];
    final commodityId = commodityIds[commodity];

    if (cityId == null || commodityId == null) {
      throw Exception('Please select a valid city and commodity.');
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/price-reports'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'city_id': cityId,
            'commodity_id': commodityId,
            'reported_price': price,
            'unit': unit,
            if (notes != null && notes.trim().isNotEmpty)
              'notes': notes.trim(),
          }),
        )
        .timeout(const Duration(seconds: 15));

    Map<String, dynamic> data;

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid response format.');
      }
      data = decoded;
    } on FormatException {
      throw Exception('The server returned an invalid response.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['message'] ?? 'Failed to submit price report.');
    }

    return data;
  }
  
  Future<List<Map<String, dynamic>>> fetchReports({
    String? city,
    String? commodity,
  }) async {
    final queryParameters = <String, String>{};

    if (city != null && city.isNotEmpty) {
      queryParameters['city'] = city;
    }

    if (commodity != null && commodity.isNotEmpty) {
      queryParameters['commodity'] = commodity;
    }

    final uri = Uri.parse('$baseUrl/api/price-reports')
        .replace(queryParameters: queryParameters.isEmpty
            ? null
            : queryParameters);

    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      if (decoded is Map<String, dynamic>) {
        throw Exception(
          decoded['message'] ?? 'Failed to load price reports.',
        );
      }
      throw Exception('Failed to load price reports.');
    }

    if (decoded is! Map<String, dynamic> ||
        decoded['reports'] is! List) {
      throw Exception('Invalid reports response from server.');
    }

    return (decoded['reports'] as List)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

}
