
import 'package:flutter/material.dart';
import '../services/price_report_service.dart';

class PriceReportsScreen extends StatefulWidget {
  const PriceReportsScreen({super.key});

  @override
  State<PriceReportsScreen> createState() => _PriceReportsScreenState();
}

class _PriceReportsScreenState extends State<PriceReportsScreen> {
  final PriceReportService _service = PriceReportService();

  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;
  String? _error;
  String? _city;
  String? _commodity;

  final List<String> _cities = [
    'Karachi',
    'Lahore',
    'Rawalpindi',
    'Multan',
  ];

  final List<String> _commodities = [
  'Wheat',
  'Rice',
  'Maize',
  'Cotton',
  'Potato',
  'Onion',
  'Tomato',
  'Apple',
  'Banana',
  'Mango',
  'Sugarcane',
];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final reports = await _service.fetchReports(
        city: _city,
        commodity: _commodity,
      );
      if (!mounted) return;

      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'Date unavailable';

    final date = DateTime.tryParse(value.toString())?.toLocal();
    if (date == null) return 'Date unavailable';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          initialValue: _city,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All cities'),
                            ),
                            ..._cities.map(
                              (city) => DropdownMenuItem<String?>(
                                value: city,
                                child: Text(city),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _city = value);
                            _loadReports();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          initialValue: _commodity,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Commodity',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All commodities'),
                            ),
                            ..._commodities.map(
                              (commodity) => DropdownMenuItem<String?>(
                                value: commodity,
                                child: Text(commodity),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _commodity = value);
                            _loadReports();
                          },
                        ),
                      ),
                      IconButton(
                        tooltip: 'Refresh reports',
                        onPressed: _loadReports,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),

          ),
          Expanded(
            child: _buildReportList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadReports,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_reports.isEmpty) {
      return const Center(
        child: Text('No street-price reports found.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReports,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];

          final commodity =
              report['commodity_name']?.toString() ?? 'Unknown commodity';
          final city = report['city_name']?.toString() ?? 'Unknown city';
          final unit = report['unit']?.toString() ?? '';
          final status =
              report['verification_status']?.toString() ?? 'pending';
          final price =
              double.tryParse(report['reported_price'].toString()) ?? 0;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          commodity,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(status).withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: _statusColor(status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18),
                      const SizedBox(width: 5),
                      Expanded(child: Text(city)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rs. ${price.toStringAsFixed(2)} / $unit',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(report['observed_at']),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if ((report['notes']?.toString() ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Note: ${report['notes']}'),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
