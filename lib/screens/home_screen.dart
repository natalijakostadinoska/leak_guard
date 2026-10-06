import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data to get it looking great instantly
  final List<Subscription> _subscriptions = [
    Subscription(id: '1', title: 'Netflix', amount: 15.99, category: 'Entertainment', isMonthly: true),
    Subscription(id: '2', title: 'GitHub Copilot', amount: 100.00, category: 'Software', isMonthly: false),
    Subscription(id: '3', title: 'Cloud Hosting', amount: 12.00, category: 'Utilities', isMonthly: true),
    Subscription(id: '4', title: 'Spotify', amount: 10.99, category: 'Entertainment', isMonthly: true),
  ];

  double get _totalMonthlySpend {
    return _subscriptions.fold(0.0, (sum, item) => sum + item.monthlyCost);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('LeakGuard 💸', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimated Monthly Leak', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(_totalMonthlySpend),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Chart Section
            const Text('Category Breakdown', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(color: Colors.blueAccent, value: 26.98, title: 'Ent.', radius: 50),
                    PieChartSectionData(color: Colors.purpleAccent, value: 8.33, title: 'Soft.', radius: 50),
                    PieChartSectionData(color: Colors.tealAccent, value: 12.00, title: 'Util.', radius: 50),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // List of Subscriptions
            const Text('Active Leaks', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subscriptions.length,
              itemBuilder: (context, index) {
                final sub = _subscriptions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(sub.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: Text(sub.category, style: const TextStyle(color: Colors.grey)),
                    trailing: Text(
                      currencyFormat.format(sub.amount),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // TODO: Pop open a modal bottom sheet to add a new subscription
        },
      ),
    );
  }
}