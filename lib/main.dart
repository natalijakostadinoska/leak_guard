import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LeakGuardApp());
}

class Subscription {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isMonthly;
  final DateTime nextPaymentDate;
  final String currency;
  final bool isFreeTrial;

  Subscription({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isMonthly,
    required this.nextPaymentDate,
    required this.currency,
    this.isFreeTrial = false,
  });

  double get monthlyCost => isMonthly ? amount : amount / 12;
  double get yearlyCost => isMonthly ? amount * 12 : amount;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category': category,
    'isMonthly': isMonthly,
    'nextPaymentDate': nextPaymentDate.toIso8601String(),
    'currency': currency,
    'isFreeTrial': isFreeTrial,
  };

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json['id'] ?? DateTime.now().toIso8601String(),
    title: json['title'] ?? 'Unknown',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    category: json['category'] ?? 'Other',
    isMonthly: json['isMonthly'] ?? true,
    nextPaymentDate: json['nextPaymentDate'] != null
        ? DateTime.parse(json['nextPaymentDate'])
        : DateTime.now(),
    currency: json['currency'] ?? '\$',
    isFreeTrial: json['isFreeTrial'] ?? false,
  );
}

class AppStrings {
  final String title;
  final String monthlyLeak;
  final String yearlyProjection;
  final String activeCount;
  final String categoryBreakdown;
  final String activeLeaks;
  final String noLeaks;
  final String addNewLeak;
  final String editLeak;
  final String serviceNameHint;
  final String amountHint;
  final String categoryLabel;
  final String currencyLabel;
  final String billedMonthly;
  final String freeTrialLabel;
  final String trialBadge;
  final String nextPaymentLabel;
  final String saveButton;
  final String monthly;
  final String yearly;
  final String searchHint;
  final String allCategory;
  final String trialsCategory;
  final String settingsTitle;
  final String exportData;
  final String clearAllData;
  final String dataExported;
  final String arcadeTitle;

  // Categories
  final String catEntertainment;
  final String catSoftware;
  final String catUtilities;
  final String catOther;

  // Chart short titles
  final String chartEnt;
  final String chartSoft;
  final String chartUtil;
  final String chartOther;

  const AppStrings({
    required this.title,
    required this.monthlyLeak,
    required this.yearlyProjection,
    required this.activeCount,
    required this.categoryBreakdown,
    required this.activeLeaks,
    required this.noLeaks,
    required this.addNewLeak,
    required this.editLeak,
    required this.serviceNameHint,
    required this.amountHint,
    required this.categoryLabel,
    required this.currencyLabel,
    required this.billedMonthly,
    required this.freeTrialLabel,
    required this.trialBadge,
    required this.nextPaymentLabel,
    required this.saveButton,
    required this.monthly,
    required this.yearly,
    required this.searchHint,
    required this.allCategory,
    required this.trialsCategory,
    required this.settingsTitle,
    required this.exportData,
    required this.clearAllData,
    required this.dataExported,
    required this.arcadeTitle,
    required this.catEntertainment,
    required this.catSoftware,
    required this.catUtilities,
    required this.catOther,
    required this.chartEnt,
    required this.chartSoft,
    required this.chartUtil,
    required this.chartOther,
  });

  static const en = AppStrings(
    title: 'LeakGuard',
    monthlyLeak: 'Estimated Monthly Leak',
    yearlyProjection: 'Yearly Projection',
    activeCount: 'Active Subscriptions',
    categoryBreakdown: 'Category Breakdown',
    activeLeaks: 'Active Leaks',
    noLeaks: 'No matching leaks found.',
    addNewLeak: 'Add New Leak',
    editLeak: 'Edit Leak',
    serviceNameHint: 'Service Name (e.g. Spotify)',
    amountHint: 'Amount',
    categoryLabel: 'Category',
    currencyLabel: 'Currency',
    billedMonthly: 'Billed Monthly?',
    freeTrialLabel: 'Is Free Trial?',
    trialBadge: 'FREE TRIAL',
    nextPaymentLabel: 'Next Payment Date',
    saveButton: 'Save Leak',
    monthly: 'Monthly',
    yearly: 'Yearly',
    searchHint: 'Search subscriptions...',
    allCategory: 'All',
    trialsCategory: 'Trials ⚡',
    settingsTitle: 'Settings & Arcade 🕹️',
    exportData: 'Export Backup (JSON)',
    clearAllData: 'Delete All Data',
    dataExported: 'Backup copied to clipboard!',
    arcadeTitle: 'Snake Arcade 🐍',
    catEntertainment: 'Entertainment',
    catSoftware: 'Software',
    catUtilities: 'Utilities',
    catOther: 'Other',
    chartEnt: 'Ent.',
    chartSoft: 'Soft.',
    chartUtil: 'Util.',
    chartOther: 'Oth.',
  );

  static const mk = AppStrings(
    title: 'LeakGuard',
    monthlyLeak: 'Проценет месечен трошок',
    yearlyProjection: 'Проценка на годишно ниво',
    activeCount: 'Активни претплати',
    categoryBreakdown: 'Поделба по категории',
    activeLeaks: 'Активни претплати',
    noLeaks: 'Нема пронајдени претплати.',
    addNewLeak: 'Додај нова претплата',
    editLeak: 'Уреди претплата',
    serviceNameHint: 'Име на сервис (пр. Spotify)',
    amountHint: 'Сума',
    categoryLabel: 'Категорија',
    currencyLabel: 'Валута',
    billedMonthly: 'Месечна наплата?',
    freeTrialLabel: 'Бесплатен период (Trial)?',
    trialBadge: 'БЕСПЛАТЕН ПЕРИОД',
    nextPaymentLabel: 'Следна дата за плаќање',
    saveButton: 'Зачувај',
    monthly: 'Месечно',
    yearly: 'Годишно',
    searchHint: 'Пребарај претплати...',
    allCategory: 'Сите',
    trialsCategory: 'Пробни ⚡',
    settingsTitle: 'Подесувања & Аркада 🕹️',
    exportData: 'Извези резервна копија (JSON)',
    clearAllData: 'Избриши ги сите податоци',
    dataExported: 'Податоците се зачувани во клипборд!',
    arcadeTitle: 'Змија Аркада 🐍',
    catEntertainment: 'Забава',
    catSoftware: 'Софтвер',
    catUtilities: 'Комуналии',
    catOther: 'Друго',
    chartEnt: 'Заб.',
    chartSoft: 'Соф.',
    chartUtil: 'Ком.',
    chartOther: 'Дру.',
  );
}

class LeakGuardApp extends StatelessWidget {
  const LeakGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeakGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Custom Logo Widget representing Shield + Financial Guard
class LeakGuardLogo extends StatelessWidget {
  final double size;
  const LeakGuardLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.shield_outlined, color: Colors.white.withOpacity(0.3), size: size * 0.85),
          const Icon(Icons.security, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMkd = false;
  String _searchQuery = '';
  String _selectedFilterCategory = 'All';
  String _displayCurrency = '\$';

  List<Subscription> _subscriptions = [
    Subscription(id: '1', title: 'Netflix', amount: 15.99, category: 'Entertainment', isMonthly: true, nextPaymentDate: DateTime.now().add(const Duration(days: 3)), currency: '\$', isFreeTrial: false),
    Subscription(id: '2', title: 'GitHub Copilot', amount: 100.00, category: 'Software', isMonthly: false, nextPaymentDate: DateTime.now().add(const Duration(days: 45)), currency: '\$', isFreeTrial: false),
    Subscription(id: '3', title: 'Cloud Hosting', amount: 12.00, category: 'Utilities', isMonthly: true, nextPaymentDate: DateTime.now().add(const Duration(days: 12)), currency: '\$', isFreeTrial: true),
  ];

  final Map<String, Color> _categoryColors = {
    'Entertainment': Colors.blueAccent,
    'Software': Colors.purpleAccent,
    'Utilities': Colors.tealAccent,
    'Other': Colors.orangeAccent,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? subsJson = prefs.getString('subscriptions');
    final bool? savedLang = prefs.getBool('is_mkd');

    if (subsJson != null) {
      final List decoded = jsonDecode(subsJson);
      setState(() {
        _subscriptions = decoded.map((item) => Subscription.fromJson(item)).toList();
        if (savedLang != null) _isMkd = savedLang;
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_subscriptions.map((s) => s.toJson()).toList());
    await prefs.setString('subscriptions', encoded);
    await prefs.setBool('is_mkd', _isMkd);
  }

  double _convertToDisplayCurrency(double usdAmount, String originalCurrency) {
    double inUsd = usdAmount;
    if (originalCurrency == '€') inUsd = usdAmount * 1.08;
    if (originalCurrency == 'MKD') inUsd = usdAmount / 58.0;

    if (_displayCurrency == '€') return inUsd * 0.93;
    if (_displayCurrency == 'MKD') return inUsd * 58.0;
    return inUsd;
  }

  double get _totalMonthlySpend {
    return _subscriptions.fold(0.0, (sum, item) {
      final convertedMonthly = _convertToDisplayCurrency(item.monthlyCost, item.currency);
      return sum + convertedMonthly;
    });
  }

  double get _totalYearlySpend {
    return _subscriptions.fold(0.0, (sum, item) {
      final convertedYearly = _convertToDisplayCurrency(item.yearlyCost, item.currency);
      return sum + convertedYearly;
    });
  }

  Map<String, double> get _categoryTotals {
    final Map<String, double> totals = {};
    for (var sub in _subscriptions) {
      final converted = _convertToDisplayCurrency(sub.monthlyCost, sub.currency);
      totals.update(sub.category, (value) => value + converted, ifAbsent: () => converted);
    }
    return totals;
  }

  List<Subscription> get _filteredSubscriptions {
    return _subscriptions.where((sub) {
      final matchesSearch = sub.title.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = true;
      if (_selectedFilterCategory == 'Trials') {
        matchesCategory = sub.isFreeTrial;
      } else if (_selectedFilterCategory != 'All') {
        matchesCategory = sub.category == _selectedFilterCategory;
      }
      return matchesSearch && matchesCategory;
    }).toList();
  }

  String _getLocalizedCategoryName(String categoryKey, AppStrings strings) {
    switch (categoryKey) {
      case 'Entertainment': return strings.catEntertainment;
      case 'Software': return strings.catSoftware;
      case 'Utilities': return strings.catUtilities;
      case 'Other': return strings.catOther;
      case 'Trials': return strings.trialsCategory;
      default: return categoryKey;
    }
  }

  String _getChartTitle(String categoryKey, AppStrings strings) {
    switch (categoryKey) {
      case 'Entertainment': return strings.chartEnt;
      case 'Software': return strings.chartSoft;
      case 'Utilities': return strings.chartUtil;
      case 'Other': return strings.chartOther;
      default: return categoryKey;
    }
  }

  void _saveSubscription(Subscription sub, {bool isEditing = false}) {
    setState(() {
      if (isEditing) {
        final index = _subscriptions.indexWhere((s) => s.id == sub.id);
        if (index != -1) _subscriptions[index] = sub;
      } else {
        _subscriptions.add(sub);
      }
    });
    _saveData();
  }

  void _deleteSubscription(String id) {
    setState(() {
      _subscriptions.removeWhere((sub) => sub.id == id);
    });
    _saveData();
  }

  void _cycleDisplayCurrency() {
    setState(() {
      if (_displayCurrency == '\$') {
        _displayCurrency = '€';
      } else if (_displayCurrency == '€') {
        _displayCurrency = 'MKD';
      } else {
        _displayCurrency = '\$';
      }
    });
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return const SettingsAndGameSheet();
      },
    );
  }

  void _showFormModal(BuildContext context, {Subscription? subscriptionToEdit}) {
    final strings = _isMkd ? AppStrings.mk : AppStrings.en;
    final isEditing = subscriptionToEdit != null;

    final titleController = TextEditingController(text: subscriptionToEdit?.title ?? '');
    final amountController = TextEditingController(text: subscriptionToEdit != null ? subscriptionToEdit.amount.toString() : '');
    String selectedCategory = subscriptionToEdit?.category ?? 'Entertainment';
    String selectedCurrency = subscriptionToEdit?.currency ?? '\$';
    bool isMonthly = subscriptionToEdit?.isMonthly ?? true;
    bool isFreeTrial = subscriptionToEdit?.isFreeTrial ?? false;
    DateTime selectedDate = subscriptionToEdit?.nextPaymentDate ?? DateTime.now().add(const Duration(days: 30));

    final categoryOptions = {
      'Entertainment': strings.catEntertainment,
      'Software': strings.catSoftware,
      'Utilities': strings.catUtilities,
      'Other': strings.catOther,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? strings.editLeak : strings.addNewLeak,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: strings.serviceNameHint,
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: strings.amountHint,
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: selectedCurrency,
                          dropdownColor: const Color(0xFF2A2A2A),
                          style: const TextStyle(color: Colors.white),
                          items: ['\$', '€', 'MKD']
                              .map((curr) => DropdownMenuItem(value: curr, child: Text(curr)))
                              .toList(),
                          onChanged: (val) => setModalState(() => selectedCurrency = val!),
                          decoration: InputDecoration(labelText: strings.currencyLabel, labelStyle: const TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    dropdownColor: const Color(0xFF2A2A2A),
                    style: const TextStyle(color: Colors.white),
                    items: categoryOptions.entries
                        .map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value)))
                        .toList(),
                    onChanged: (val) => setModalState(() => selectedCategory = val!),
                    decoration: InputDecoration(labelText: strings.categoryLabel, labelStyle: const TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text(strings.billedMonthly, style: const TextStyle(color: Colors.white)),
                    value: isMonthly,
                    onChanged: (val) => setModalState(() => isMonthly = val),
                    activeColor: const Color(0xFF6366F1),
                  ),
                  SwitchListTile(
                    title: Text(strings.freeTrialLabel, style: const TextStyle(color: Colors.white)),
                    value: isFreeTrial,
                    onChanged: (val) => setModalState(() => isFreeTrial = val),
                    activeColor: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${strings.nextPaymentLabel}: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          );
                          if (pickedDate != null) {
                            setModalState(() => selectedDate = pickedDate);
                          }
                        },
                        child: const Text('Pick Date', style: TextStyle(color: Color(0xFF6366F1))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                      onPressed: () {
                        if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                          final amount = double.tryParse(amountController.text) ?? 0.0;
                          final newSub = Subscription(
                            id: isEditing ? subscriptionToEdit.id : DateTime.now().toIso8601String(),
                            title: titleController.text,
                            amount: amount,
                            category: selectedCategory,
                            isMonthly: isMonthly,
                            nextPaymentDate: selectedDate,
                            currency: selectedCurrency,
                            isFreeTrial: isFreeTrial,
                          );
                          _saveSubscription(newSub, isEditing: isEditing);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(strings.saveButton, style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = _isMkd ? AppStrings.mk : AppStrings.en;
    final currencyFormat = NumberFormat.currency(symbol: _displayCurrency);
    final categoryTotals = _categoryTotals;
    final filteredList = _filteredSubscriptions;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const LeakGuardLogo(size: 34),
            const SizedBox(width: 10),
            Text(strings.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () => _showSettingsModal(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() => _isMkd = !_isMkd);
                _saveData();
              },
              child: Text(
                _isMkd ? '🇲🇰 MKD' : '🇬🇧 ENG',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card with Currency Switcher
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(strings.monthlyLeak, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      GestureDetector(
                        onTap: _cycleDisplayCurrency,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Currency: $_displayCurrency 🔄',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(_totalMonthlySpend),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.yearlyProjection, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(currencyFormat.format(_totalYearlySpend), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(strings.activeCount, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text('${_subscriptions.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category Breakdown Chart
            Text(strings.categoryBreakdown, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: categoryTotals.isEmpty
                  ? Center(child: Text(strings.noLeaks, style: const TextStyle(color: Colors.grey)))
                  : PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: categoryTotals.entries.map((entry) {
                    final color = _categoryColors[entry.key] ?? Colors.grey;
                    final chartTitle = _getChartTitle(entry.key, strings);
                    return PieChartSectionData(
                      color: color,
                      value: entry.value,
                      title: chartTitle,
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: strings.searchHint,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),

            // Category & Trial Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Trials', 'Entertainment', 'Software', 'Utilities', 'Other'].map((cat) {
                  final isSelected = _selectedFilterCategory == cat;
                  final label = cat == 'All'
                      ? strings.allCategory
                      : (cat == 'Trials' ? strings.trialsCategory : _getLocalizedCategoryName(cat, strings));
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      selectedColor: cat == 'Trials' ? Colors.amber[700] : const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF1E1E1E),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: cat == 'Trials' ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => setState(() => _selectedFilterCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Active Leaks List Header
            Text(strings.activeLeaks, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            filteredList.isEmpty
                ? Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text(strings.noLeaks, style: const TextStyle(color: Colors.grey))))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final sub = filteredList[index];
                final billingText = sub.isMonthly ? strings.monthly : strings.yearly;
                final localizedCategory = _getLocalizedCategoryName(sub.category, strings);
                final formattedDate = DateFormat('MMM dd, yyyy').format(sub.nextPaymentDate);

                final daysLeft = sub.nextPaymentDate.difference(DateTime.now()).inDays;
                final urgencyColor = daysLeft <= 3 ? Colors.redAccent : (daysLeft <= 7 ? Colors.orangeAccent : Colors.grey);

                return Dismissible(
                  key: Key(sub.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteSubscription(sub.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: sub.isFreeTrial ? Border.all(color: Colors.amber.withOpacity(0.5), width: 1.5) : null,
                    ),
                    child: ListTile(
                      onTap: () => _showFormModal(context, subscriptionToEdit: sub),
                      title: Row(
                        children: [
                          Text(sub.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          if (sub.isFreeTrial) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                strings.trialBadge,
                                style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '$localizedCategory • $billingText\n📅 $formattedDate (${daysLeft}d left)',
                        style: TextStyle(color: urgencyColor, height: 1.4, fontSize: 13),
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${sub.currency}${sub.amount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                        ],
                      ),
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
        onPressed: () => _showFormModal(context),
      ),
    );
  }
}

// Settings sheet that embeds the Snake Game
class SettingsAndGameSheet extends StatefulWidget {
  const SettingsAndGameSheet({super.key});

  @override
  State<SettingsAndGameSheet> createState() => _SettingsAndGameSheetState();
}

class _SettingsAndGameSheetState extends State<SettingsAndGameSheet> {
  static const int rows = 15;
  static const int columns = 15;
  List<int> snake = [42, 41, 40];
  int food = 55;
  String direction = 'RIGHT';
  bool isPlaying = false;
  int score = 0;
  int highScore = 0;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('snake_high_score') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    if (score > highScore) {
      highScore = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('snake_high_score', highScore);
    }
  }

  void startGame() {
    setState(() {
      snake = [42, 41, 40];
      food = 55;
      direction = 'RIGHT';
      isPlaying = true;
      score = 0;
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      setState(() {
        updateSnake();
        if (checkGameOver()) {
          timer.cancel();
          isPlaying = false;
          _saveHighScore();
        }
      });
    });
  }

  void updateSnake() {
    int newHead = snake.first;
    switch (direction) {
      case 'UP':
        newHead -= columns;
        break;
      case 'DOWN':
        newHead += columns;
        break;
      case 'LEFT':
        newHead -= 1;
        break;
      case 'RIGHT':
        newHead += 1;
        break;
    }

    snake.insert(0, newHead);

    if (newHead == food) {
      score += 10;
      generateFood();
    } else {
      snake.removeLast();
    }
  }

  void generateFood() {
    final random = Random();
    do {
      food = random.nextInt(rows * columns);
    } while (snake.contains(food));
  }

  bool checkGameOver() {
    int head = snake.first;
    if (direction == 'LEFT' && head % columns == columns - 1) return true;
    if (direction == 'RIGHT' && head % columns == 0) return true;
    if (head < 0 || head >= rows * columns) return true;

    for (int i = 1; i < snake.length; i++) {
      if (snake[i] == head) return true;
    }

    return false;
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings & Arcade 🕹️',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.file_download, color: Colors.white70),
            title: const Text('Export Backup (JSON)', style: TextStyle(color: Colors.white)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final data = prefs.getString('subscriptions') ?? '[]';
              await Clipboard.setData(ClipboardData(text: data));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup copied to clipboard!')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text('Delete All Data', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared. Restart app.')),
                );
              }
            },
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Snake Arcade 🐍 (Score: $score | High: $highScore)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                onPressed: isPlaying ? null : startGame,
                child: Text(isPlaying ? 'Playing...' : 'Start Game', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rows * columns,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns),
                itemBuilder: (context, index) {
                  Color cellColor = Colors.transparent;
                  if (snake.contains(index)) {
                    cellColor = const Color(0xFF6366F1);
                  } else if (index == food) {
                    cellColor = Colors.orangeAccent;
                  }
                  return Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (isPlaying)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left, color: Colors.white, size: 36),
                  onPressed: () {
                    if (direction != 'RIGHT') setState(() => direction = 'LEFT');
                  },
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_up, color: Colors.white, size: 36),
                      onPressed: () {
                        if (direction != 'DOWN') setState(() => direction = 'UP');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 36),
                      onPressed: () {
                        if (direction != 'UP') setState(() => direction = 'DOWN');
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right, color: Colors.white, size: 36),
                  onPressed: () {
                    if (direction != 'LEFT') setState(() => direction = 'RIGHT');
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}