
class MandiRate {
  final String id;
  final String commodityName;
  final String category;
  final String city;
  final String province;
  final String marketName;
  final double minPrice;
  final double maxPrice;
  final String unit;
  final DateTime rateDate;
  final String sourceName;
  final String sourceReference;

  const MandiRate({
    required this.id,
    required this.commodityName,
    required this.category,
    required this.city,
    required this.province,
    required this.marketName,
    required this.minPrice,
    required this.maxPrice,
    required this.unit,
    required this.rateDate,
    required this.sourceName,
    required this.sourceReference,
  });

  factory MandiRate.fromJson(Map<String, dynamic> json) {
    return MandiRate(
      id: json['id'].toString(),
      commodityName: json['commodity_name'] as String? ?? '',
      category: json['commodity_category'] as String? ?? 'Other',
      city: json['city_name'] as String? ?? '',
      province: json['province'] as String? ?? '',
      marketName: json['market_name'] as String? ?? '',
      minPrice: double.parse(json['min_price'].toString()),
      maxPrice: double.parse(json['max_price'].toString()),
      unit: json['unit'] as String? ?? '',
      rateDate: DateTime.parse(json['rate_date'].toString()),
      sourceName: json['source_name'] as String? ?? '',
      sourceReference: json['source_reference'] as String? ?? '',
    );
  }
}
