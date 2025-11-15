import 'package:flutter/material.dart';

abstract class DashboardStyler {
  Color get primaryColor;
  Color get secondaryColor;
  Color get backgroundColor;
  Widget buildStatCard(StatItem stat);
  Widget buildChartPlaceholder();
  List<Widget> buildQuickLinks(List<QuickLink> links);
}

class CompactDashboardStyle implements DashboardStyler {
  @override
  Color get primaryColor => const Color(0xFF1976D2);

  @override
  Color get secondaryColor => const Color(0xFF64B5F6);

  @override
  Color get backgroundColor => const Color(0xFFFAFAFA);

  @override
  Widget buildStatCard(StatItem stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(stat.icon, color: Colors.white, size: 28),
          const Spacer(),
          Text(
            stat.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildChartPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.bar_chart, size: 64, color: primaryColor.withOpacity(0.3)),
      ),
    );
  }

  @override
  List<Widget> buildQuickLinks(List<QuickLink> links) {
    return links.map((link) {
      return InkWell(
        onTap: link.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(link.icon, color: primaryColor, size: 32),
              const SizedBox(height: 8),
              Text(
                link.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class DashboardScreen extends StatelessWidget {
  final DashboardStyler styler;
  final DashboardContent content;

  const DashboardScreen({
    Key? key,
    DashboardStyler? styler,
    DashboardContent? content,
  })  : styler = styler ?? const CompactDashboardStyle(),
        content = content ?? const DashboardContent(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = content.stats.isEmpty ? _defaultStats() : content.stats;
    final links = content.quickLinks.isEmpty ? _defaultLinks() : content.quickLinks;

    return Scaffold(
      backgroundColor: styler.backgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: styler.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) => styler.buildStatCard(stats[index]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            styler.buildChartPlaceholder(),
            const SizedBox(height: 24),
            const Text(
              'Quick Links',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: styler.buildQuickLinks(links),
            ),
          ],
        ),
      ),
    );
  }

  List<StatItem> _defaultStats() {
    return [
      StatItem(icon: Icons.people, label: 'Users', value: '1,234'),
      StatItem(icon: Icons.shopping_bag, label: 'Sales', value: '\$5,678'),
      StatItem(icon: Icons.star, label: 'Reviews', value: '4.8'),
      StatItem(icon: Icons.trending_up, label: 'Growth', value: '+12%'),
    ];
  }

  List<QuickLink> _defaultLinks() {
    return [
      QuickLink(icon: Icons.add_box, label: 'New Item', onTap: () {}),
      QuickLink(icon: Icons.analytics, label: 'Analytics', onTap: () {}),
      QuickLink(icon: Icons.people, label: 'Users', onTap: () {}),
      QuickLink(icon: Icons.settings, label: 'Settings', onTap: () {}),
      QuickLink(icon: Icons.help, label: 'Help', onTap: () {}),
      QuickLink(icon: Icons.notifications, label: 'Alerts', onTap: () {}),
    ];
  }
}

class DashboardContent {
  final List<StatItem> stats;
  final List<QuickLink> quickLinks;

  const DashboardContent({
    this.stats = const [],
    this.quickLinks = const [],
  });
}

class StatItem {
  final IconData icon;
  final String label;
  final String value;

  StatItem({required this.icon, required this.label, required this.value});
}

class QuickLink {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  QuickLink({required this.icon, required this.label, required this.onTap});
}
