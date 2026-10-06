class Subscription {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isMonthly;

  Subscription({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isMonthly,
  });

  double get monthlyCost => isMonthly ? amount : amount / 12;
}