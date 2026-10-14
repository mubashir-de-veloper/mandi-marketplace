
import 'package:flutter/material.dart';

import 'models/mandi_rate.dart';
import 'services/mandi_rate_service.dart';

const green = Color(0xFF176B3A);
const paleGreen = Color(0xFFE8F3E9);
const pageBg = Color(0xFFF6F8F5);

void main() => runApp(const MandiApp());

class MandiApp extends StatelessWidget {
  const MandiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mandi Marketplace',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: pageBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: green,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const MarketplaceShell(),
    );
  }
}

// Temporary UI data. These are NOT live mandi prices.
class Produce {
  final String name;
  final String urdu;
  final String category;
  final String emoji;
  final int price;
  final String unit;
  final String location;

  const Produce({
    required this.name,
    required this.urdu,
    required this.category,
    required this.emoji,
    required this.price,
    required this.unit,
    required this.location,
  });
}

const produceList = [
  Produce(
    name: 'Wheat',
    urdu: 'گندم',
    category: 'Grains',
    emoji: '🌾',
    price: 2800,
    unit: '40 kg',
    location: 'Gujranwala',
  ),
  Produce(
    name: 'Rice',
    urdu: 'چاول',
    category: 'Grains',
    emoji: '🌾',
    price: 3600,
    unit: '40 kg',
    location: 'Lahore',
  ),
  Produce(
    name: 'Potato',
    urdu: 'آلو',
    category: 'Vegetables',
    emoji: '🥔',
    price: 1500,
    unit: '40 kg',
    location: 'Gujranwala',
  ),
  Produce(
    name: 'Onion',
    urdu: 'پیاز',
    category: 'Vegetables',
    emoji: '🧅',
    price: 2200,
    unit: '40 kg',
    location: 'Lahore',
  ),
  Produce(
    name: 'Tomato',
    urdu: 'ٹماٹر',
    category: 'Vegetables',
    emoji: '🍅',
    price: 1800,
    unit: '40 kg',
    location: 'Faisalabad',
  ),
  Produce(
    name: 'Cotton',
    urdu: 'کپاس',
    category: 'Other',
    emoji: '🌱',
    price: 8500,
    unit: '40 kg',
    location: 'Multan',
  ),
];

String money(int value) => 'Rs. ${value.toString()}';

// Main app navigation

class MarketplaceShell extends StatefulWidget {
  const MarketplaceShell({super.key});

  @override
  State<MarketplaceShell> createState() => _MarketplaceShellState();
}

class _MarketplaceShellState extends State<MarketplaceShell> {
  int selectedIndex = 0;

  void openTab(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    const titles = [
      'Mandi Marketplace',
      'Official Mandi Rates',
      'Direct Marketplace',
      'My Account',
    ];

    return PopScope<Object?>(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && selectedIndex != 0) {
          setState(() => selectedIndex = 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titles[selectedIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.agriculture, size: 28),
          ),
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: [
            HomeScreen(onTabSelected: openTab),
            const RatesScreen(),
            const MarketplaceScreen(),
            const AccountScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: openTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_up),
              label: 'Rates',
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              label: 'Market',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}


// Screen 1: Home
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onTabSelected;

  const HomeScreen({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grow better.\nTrade smarter.',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Mandi rates and direct agricultural trading in one place.',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              SizedBox(height: 16),
              Icon(Icons.agriculture, color: Colors.white, size: 45),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          title: 'Explore',
          subtitle: 'What would you like to do?',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                icon: Icons.trending_up,
                title: 'Mandi Rates',
                subtitle: 'Check prices',
                onTap: () => onTabSelected(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FeatureCard(
                icon: Icons.storefront,
                title: 'Marketplace',
                subtitle: 'Browse produce',
                onTap: () => onTabSelected(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          title: 'Popular commodities',
          subtitle: 'Example prices for interface testing',
        ),
        const SizedBox(height: 10),
        ...produceList.take(4).map(
              (item) => ProduceCard(
            produce: item,
            onTap: () => openProduceDetails(context, item),
          ),
        ),
        const SizedBox(height: 12),
        const NoticeBox(
          text:
          'Sample data only. Prices are not verified official mandi rates.',
        ),
      ],
    );
  }
}

// Screen 2: Mandi rates with search and filters
class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}


class _RatesScreenState extends State<RatesScreen> {
  String search = '';
  String city = 'All cities';
  String category = 'All';

  final MandiRateService _rateService = MandiRateService();
  late Future<List<MandiRate>> _ratesFuture;

  @override
  void initState() {
    super.initState();
    _ratesFuture = _rateService.fetchRates();
  }

  void _loadRates() {
    setState(() {
      _ratesFuture = _rateService.fetchRates(
        city: city,
      );
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          title: 'Compare mandi prices',
          subtitle: 'Find commodities by name, category and city.',
        ),
        const SizedBox(height: 16),

        SearchBox(
          hint: 'Search wheat, rice, vegetables...',
          onChanged: (value) => setState(() => search = value),
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          initialValue: city,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_on_outlined),
            labelText: 'Select mandi / city',
          ),
          items: [
            'All cities',
            'Karachi',
            'Lahore',
            'Rawalpindi',
            'Multan',
          ].map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => city = value);
              _loadRates();
            }
          },
        ),
        const SizedBox(height: 16),

        const Text(
          'Commodity category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          children: ['All', 'Grains', 'Vegetables', 'Other'].map((value) {
            return ChoiceChip(
              label: Text(value),
              selected: category == value,
              onSelected: (_) => setState(() => category = value),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        FutureBuilder<List<MandiRate>>(
          future: _ratesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Column(
                children: [
                  const Icon(
                    Icons.cloud_off,
                    size: 42,
                  ),
                  const SizedBox(height: 8),
                  const Text('Could not load mandi rates.'),
                  const SizedBox(height: 8),
                  const Text(
                    'Check that your backend is running and try again.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _loadRates,
                    child: const Text('Retry'),
                  ),
                ],
              );
            }

            final rates = snapshot.data ?? [];

            final results = rates.where((rate) {
              final query = search.toLowerCase().trim();

              final matchesSearch =
                  '${rate.commodityName} ${rate.marketName} ${rate.city}'
                      .toLowerCase()
                      .contains(query);

              final matchesCategory =
                  category == 'All' || rate.category == category;

              return matchesSearch && matchesCategory;
            }).toList();

            if (results.isEmpty) {
              return const EmptyState(
                icon: Icons.search_off,
                title: 'No mandi rates found',
                subtitle: 'Try another name, category or city.',
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${results.length} mandi rates found',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                ...results.map((rate) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rate.commodityName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('${rate.marketName}, ${rate.city}'),
                          const SizedBox(height: 10),
                          Text(
                            'Rs. ${rate.minPrice.toStringAsFixed(2)}'
                            ' – Rs. ${rate.maxPrice.toStringAsFixed(2)}'
                            ' / ${rate.unit == 'pkr_per_100kg' ? '100 kg' : rate.unit == 'pkr_per_kg' ? 'kg' : rate.unit == 'pkr_per_dozen' ? 'dozen' : rate.unit}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Category: ${rate.category}'),
                          Text('Province: ${rate.province}'),
                          Text('Source: ${rate.sourceName}'),
                          Text(
                            'Date: ${rate.rateDate.toLocal().toString().split(' ').first}',
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 8),
                const NoticeBox(
                  text:
                      'Rates provided by PakDataHub. Check the source and date '
                      'before making buying or selling decisions.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// Screen 3: Direct marketplace
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String search = '';
  String category = 'All';

  @override
  Widget build(BuildContext context) {
    final results = produceList.where((item) {
      final matchesSearch =
      '${item.name} ${item.urdu} ${item.location}'
          .toLowerCase()
          .contains(search.toLowerCase());
      final matchesCategory =
          category == 'All' || item.category == category;
      return matchesSearch && matchesCategory;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(
          title: 'Buy directly',
          subtitle: 'Explore agricultural produce listings.',
        ),
        const SizedBox(height: 16),
        SearchBox(
          hint: 'Search produce or location...',
          onChanged: (value) => setState(() => search = value),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['All', 'Grains', 'Vegetables', 'Other'].map((value) {
            return ChoiceChip(
              label: Text(value),
              selected: category == value,
              onSelected: (_) => setState(() => category = value),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const NoticeBox(
          text:
          'These are example listings. Seller accounts, contact details and real orders are not connected yet.',
        ),
        const SizedBox(height: 12),
        ...results.map(
              (item) => MarketplaceProductCard(
            produce: item,
            onTap: () => openProduceDetails(context, item),
          ),
        ),
        if (results.isEmpty)
          const EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'No products found',
            subtitle: 'Try a different search or category.',
          ),
      ],
    );
  }
}

// Screen 4: Account
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 16),
        const CircleAvatar(
          radius: 43,
          backgroundColor: paleGreen,
          child: Icon(Icons.person, size: 48, color: green),
        ),
        const SizedBox(height: 14),
        const Text(
          'Welcome to Mandi Marketplace',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in or create an account to access marketplace features.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Login',
          icon: Icons.login,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterScreen()),
          ),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Create an account'),
          style: OutlinedButton.styleFrom(
            foregroundColor: green,
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.agriculture, color: green),
          title: Text('Farmer account'),
          subtitle: Text('Designed for agricultural producers'),
        ),
        const ListTile(
          leading: Icon(Icons.shopping_bag_outlined, color: green),
          title: Text('Buyer account'),
          subtitle: Text('Designed for produce buyers and traders'),
        ),
        const NoticeBox(
          text: 'Account screens are UI prototypes. No real login is active.',
        ),
      ],
    );
  }
}

// Product details screen, opened from reusable product cards
void openProduceDetails(BuildContext context, Produce item) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProductDetailsScreen(produce: item),
    ),
  );
}

class ProductDetailsScreen extends StatelessWidget {
  final Produce produce;

  const ProductDetailsScreen({super.key, required this.produce});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: paleGreen,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                produce.emoji,
                style: const TextStyle(fontSize: 85),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            produce.name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(produce.urdu, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text(
            money(produce.price),
            style: const TextStyle(
              color: green,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('Illustrative price per ${produce.unit}'),
          const SizedBox(height: 20),
          InfoRow(label: 'Category', value: produce.category),
          InfoRow(label: 'Example location', value: produce.location),
          InfoRow(label: 'Unit', value: produce.unit),
          const SizedBox(height: 24),
          const NoticeBox(
            text:
            'This is sample product information. Seller verification, availability and live pricing are not implemented.',
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Contact seller',
            icon: Icons.chat_outlined,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Seller contact will be added later.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Login form UI
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: FormPanel(
        title: 'Welcome back',
        subtitle: 'Enter your details to sign in.',
        children: [
          const AppInput(
            label: 'Email address',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 14),
          const AppInput(
            label: 'Password',
            icon: Icons.lock_outline,
            obscure: true,
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'Login',
            icon: Icons.login,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Authentication will be connected later.'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Registration form UI
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String role = 'Farmer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: FormPanel(
        title: 'Join the marketplace',
        subtitle: 'Choose your account type.',
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'Farmer',
                label: Text('Farmer'),
                icon: Icon(Icons.agriculture),
              ),
              ButtonSegment(
                value: 'Buyer',
                label: Text('Buyer'),
                icon: Icon(Icons.shopping_bag_outlined),
              ),
            ],
            selected: {role},
            onSelectionChanged: (value) {
              setState(() => role = value.first);
            },
          ),
          const SizedBox(height: 16),
          const AppInput(label: 'Full name', icon: Icons.person_outline),
          const SizedBox(height: 14),
          const AppInput(label: 'Phone number', icon: Icons.phone_outlined),
          const SizedBox(height: 14),
          const AppInput(
            label: 'Email address',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 14),
          const AppInput(
            label: 'Create password',
            icon: Icons.lock_outline,
            obscure: true,
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'Register as $role',
            icon: Icons.person_add_alt_1,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration will be connected later.'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable UI components

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class SearchBox extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const SearchBox({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: green),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: green),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProduceCard extends StatelessWidget {
  final Produce produce;
  final VoidCallback onTap;

  const ProduceCard({
    super.key,
    required this.produce,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        leading: CircleAvatar(
          backgroundColor: paleGreen,
          child: Text(produce.emoji, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(
          '${produce.name} (${produce.urdu})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${produce.unit} • ${produce.location}'),
        trailing: Text(
          money(produce.price),
          style: const TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MarketplaceProductCard extends StatelessWidget {
  final Produce produce;
  final VoidCallback onTap;

  const MarketplaceProductCard({
    super.key,
    required this.produce,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 82,
                decoration: BoxDecoration(
                  color: paleGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    produce.emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produce.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('${produce.category} • ${produce.location}'),
                    const SizedBox(height: 7),
                    Text(
                      '${money(produce.price)} / ${produce.unit}',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class NoticeBox extends StatelessWidget {
  final String text;

  const NoticeBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.brown),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.brown),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: green,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class AppInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;

  const AppInput({
    super.key,
    required this.label,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class FormPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const FormPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.black54)),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
