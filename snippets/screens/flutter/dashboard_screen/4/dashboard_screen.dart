import 'package:flutter/material.dart';

class DashboardTheme {
  final Color primaryColor;
  final Color cardColor;
  final Color backgroundColor;
  final double cardElevation;
  final double cardRadius;
  final EdgeInsets cardPadding;

  const DashboardTheme({
    this.primaryColor = const Color(0xFF2196F3),
    this.cardColor = Colors.white,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.cardElevation = 2.0,
    this.cardRadius = 12.0,
    this.cardPadding = const EdgeInsets.all(16),
  });
}

class DashboardScreen extends StatelessWidget {
  final DashboardTheme? theme;
  final DashboardData? data;

  const DashboardScreen({
    Key? key,
    this.theme,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const DashboardTheme();
    final dashboardData = data ?? _defaultData;

    return Scaffold(
      backgroundColor: effectiveTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: effectiveTheme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsGrid(dashboardData.metrics, effectiveTheme),
            const SizedBox(height: 24),
            _buildSection('Recent Activity', effectiveTheme),
            const SizedBox(height: 12),
            _buildActivityList(dashboardData.activities, effectiveTheme),
            const SizedBox(height: 24),
            _buildSection('Quick Actions', effectiveTheme),
            const SizedBox(height: 12),
            _buildActionButtons(dashboardData.actions, effectiveTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(List<Metric> metrics, DashboardTheme theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => _MetricCard(
        metric: metrics[index],
        theme: theme,
      ),
    );
  }

  Widget _buildSection(String title, DashboardTheme theme) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildActivityList(List<Activity> activities, DashboardTheme theme) {
    return Card(
      elevation: theme.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.cardRadius),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => ListTile(
          leading: Icon(activities[index].icon, color: theme.primaryColor),
          title: Text(activities[index].title),
          subtitle: Text(activities[index].time),
        ),
      ),
    );
  }

  Widget _buildActionButtons(List<QuickAction> actions, DashboardTheme theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions
          .map((action) => ElevatedButton.icon(
                onPressed: action.onTap,
                icon: Icon(action.icon),
                label: Text(action.label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ))
          .toList(),
    );
  }

  static final _defaultData = DashboardData(
    metrics: [
      Metric(label: 'Total Sales', value: '\$12,450', icon: Icons.attach_money),
      Metric(label: 'Orders', value: '89', icon: Icons.shopping_cart),
      Metric(label: 'Customers', value: '234', icon: Icons.people),
      Metric(label: 'Revenue', value: '\$45,678', icon: Icons.trending_up),
    ],
    activities: [
      Activity(icon: Icons.payment, title: 'New order received', time: '2 min ago'),
      Activity(icon: Icons.person_add, title: 'New customer registered', time: '15 min ago'),
      Activity(icon: Icons.local_shipping, title: 'Order shipped', time: '1 hour ago'),
    ],
    actions: [
      QuickAction(icon: Icons.add, label: 'New Order', onTap: () {}),
      QuickAction(icon: Icons.bar_chart, label: 'Reports', onTap: () {}),
      QuickAction(icon: Icons.settings, label: 'Settings', onTap: () {}),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  final Metric metric;
  final DashboardTheme theme;

  const _MetricCard({required this.metric, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: theme.cardElevation,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.cardRadius),
      ),
      child: Padding(
        padding: theme.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(metric.icon, color: theme.primaryColor, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  metric.label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardData {
  final List<Metric> metrics;
  final List<Activity> activities;
  final List<QuickAction> actions;

  DashboardData({
    required this.metrics,
    required this.activities,
    required this.actions,
  });
}

class Metric {
  final String label;
  final String value;
  final IconData icon;

  Metric({required this.label, required this.value, required this.icon});
}

class Activity {
  final IconData icon;
  final String title;
  final String time;

  Activity({required this.icon, required this.title, required this.time});
}

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  QuickAction({required this.icon, required this.label, required this.onTap});
}
