
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/mandi_rate.dart';

class MandiRateService {
  // Android emulator uses 10.0.2.2 to reach your Windows host.
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<List<MandiRate>> fetchRates({String? city}) async {
    final queryParameters = <String, String>{};

    if (city != null && city != 'All cities') {
      queryParameters['city'] = city;
    }

    final uri = Uri.parse('$baseUrl/api/rates').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load mandi rates (HTTP ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (decoded['status'] != 'success') {
      throw Exception('The server could not return mandi rates.');
    }

    final ratesJson = decoded['rates'] as List<dynamic>;

    return ratesJson
        .map(
          (item) => MandiRate.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
