
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/price_report_service.dart';

class StreetPriceReportScreen extends StatefulWidget {
  const StreetPriceReportScreen({super.key});

  @override
  State<StreetPriceReportScreen> createState() =>
      _StreetPriceReportScreenState();
}

class _StreetPriceReportScreenState
    extends State<StreetPriceReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  final _authService = AuthService();
  final _reportService = PriceReportService();

  String _city = 'Lahore';
  String _commodity = 'Wheat';
  String _unit = '40kg';
  bool _isLoading = false;

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _authService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Please log in before submitting a report.');
      }

      await _reportService.submitReport(
        token: token,
        city: _city,
        commodity: _commodity,
        price: double.parse(_priceController.text.trim()),
        unit: _unit,
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;

      _priceController.clear();
      _notesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Price report submitted for verification.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Report a street price',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Share a local price to help farmers and buyers compare market rates.',
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _city,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    items: [
                      'Karachi',
                      'Lahore',
                      'Rawalpindi',
                      'Multan',
                    ].map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _city = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _commodity,
                    decoration: const InputDecoration(
                      labelText: 'Commodity',
                      prefixIcon: Icon(Icons.grass_outlined),
                    ),
                    items: [
                      'Wheat',
                      'Rice',
                      'Potato',
                      'Onion',
                      'Tomato',
                      'Sugarcane',
                      'Cotton',
                    ].map((commodity) {
                      return DropdownMenuItem(
                        value: commodity,
                        child: Text(commodity),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _commodity = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Observed price (PKR)',
                      hintText: 'e.g. 3300',
                      prefixIcon: Icon(Icons.currency_exchange),
                    ),
                    validator: (value) {
                      final price = double.tryParse(value?.trim() ?? '');
                      if (price == null || !price.isFinite || price <= 0) {
                        return 'Enter a valid price greater than zero.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: const InputDecoration(
                      labelText: 'Price unit',
                      prefixIcon: Icon(Icons.scale_outlined),
                    ),
                    items: ['kg', '40kg', '100kg', 'dozen', 'piece']
                        .map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _unit = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'Market name or additional details',
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _submitReport,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      _isLoading ? 'Submitting...' : 'Submit price report',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Submitted reports remain pending until verified. '
          'Enter prices you have actually observed.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
