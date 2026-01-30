class AdminAnalytics {
  final double totalSales;
  final int totalOrders;
  final int totalUsers;
  final double todayRevenue;
  final List<SalesData> weeklySales;

  AdminAnalytics({
    required this.totalSales,
    required this.totalOrders,
    required this.totalUsers,
    required this.todayRevenue,
    required this.weeklySales,
  });
}

class SalesData {
  final String day;
  final double amount;

  SalesData(this.day, this.amount);
}
