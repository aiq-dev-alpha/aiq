import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedTimeframe = 'This Month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Statistics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            initialValue: selectedTimeframe,
            onSelected: (value) {
              setState(() {
                selectedTimeframe = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Today', child: Text('Today')),
              const PopupMenuItem(value: 'This Week', child: Text('This Week')),
              const PopupMenuItem(value: 'This Month', child: Text('This Month')),
              const PopupMenuItem(value: 'This Quarter', child: Text('This Quarter')),
              const PopupMenuItem(value: 'This Year', child: Text('This Year')),
            ],
            child: const Icon(Icons.filter_list),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Performance'),
            Tab(text: 'Engagement'),
            Tab(text: 'Conversion'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPerformanceTab(),
          _buildEngagementTab(),
          _buildConversionTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildKPIGrid(),
          const SizedBox(height: 20),
          _buildTrendChart(),
          const SizedBox(height: 20),
          _buildComparisonChart(),
          const SizedBox(height: 20),
          _buildTopMetricsTable(),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPerformanceMetrics(),
          const SizedBox(height: 20),
          _buildLoadTimeChart(),
          const SizedBox(height: 20),
          _buildErrorRateChart(),
          const SizedBox(height: 20),
          _buildPerformanceBreakdown(),
        ],
      ),
    );
  }

  Widget _buildEngagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildEngagementMetrics(),
          const SizedBox(height: 20),
          _buildSessionDurationChart(),
          const SizedBox(height: 20),
          _buildPageViewsChart(),
          const SizedBox(height: 20),
          _buildUserBehaviorHeatmap(),
        ],
      ),
    );
  }

  Widget _buildConversionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildConversionMetrics(),
          const SizedBox(height: 20),
          _buildConversionFunnelChart(),
          const SizedBox(height: 20),
          _buildGoalCompletionChart(),
          const SizedBox(height: 20),
          _buildConversionBreakdown(),
        ],
      ),
    );
  }

  Widget _buildKPIGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildKPICard('Total Revenue', '\$245,890', '+18.5%', Icons.attach_money, Colors.green),
        _buildKPICard('Active Users', '12,456', '+12.3%', Icons.people, Colors.blue),
        _buildKPICard('Conversion Rate', '3.24%', '+0.8%', Icons.trending_up, Colors.orange),
        _buildKPICard('Avg Session', '4m 32s', '+15s', Icons.timer, Colors.purple),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: change.startsWith('+') ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('+') ? Colors.green.shade700 : Colors.red.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Revenue Trend - $selectedTimeframe',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildChartLegend(),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text('\$${value.toInt()}K', style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final dates = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        return Text(dates[value.toInt() % dates.length], style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 35), FlSpot(1, 42), FlSpot(2, 38), FlSpot(3, 48), FlSpot(4, 45), FlSpot(5, 52),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
                    dotData: FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 28), FlSpot(1, 35), FlSpot(2, 31), FlSpot(3, 40), FlSpot(4, 38), FlSpot(5, 44),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        _buildLegendItem('Current Period', Colors.blue),
        const SizedBox(width: 16),
        _buildLegendItem('Previous Period', Colors.orange),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildComparisonChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Comparison',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: true),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final metrics = ['Revenue', 'Users', 'Orders', 'Sessions'];
                        return Text(metrics[value.toInt() % metrics.length], style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}%', style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: 85, color: Colors.blue, width: 16),
                      BarChartRodData(toY: 78, color: Colors.orange, width: 16),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(toY: 92, color: Colors.blue, width: 16),
                      BarChartRodData(toY: 88, color: Colors.orange, width: 16),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(toY: 76, color: Colors.blue, width: 16),
                      BarChartRodData(toY: 65, color: Colors.orange, width: 16),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(toY: 88, color: Colors.blue, width: 16),
                      BarChartRodData(toY: 82, color: Colors.orange, width: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMetricsTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Performing Metrics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              _buildTableHeader(),
              _buildTableRow('Page Views', '45.2K', '12.5%', Colors.green),
              _buildTableRow('Unique Visitors', '28.1K', '8.3%', Colors.green),
              _buildTableRow('Bounce Rate', '32.1%', '-2.1%', Colors.red),
              _buildTableRow('Session Duration', '4:32', '15.2%', Colors.green),
              _buildTableRow('Conversion Rate', '3.24%', '8.7%', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        _buildTableHeaderCell('Metric'),
        _buildTableHeaderCell('Value'),
        _buildTableHeaderCell('Change'),
        _buildTableHeaderCell('Trend'),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  TableRow _buildTableRow(String metric, String value, String change, Color changeColor) {
    return TableRow(
      children: [
        _buildTableCell(metric),
        _buildTableCell(value),
        _buildTableCell(change, color: changeColor),
        _buildTableCell(change.startsWith('+') ? '↗' : '↘', color: changeColor),
      ],
    );
  }

  Widget _buildTableCell(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: color != null ? FontWeight.w600 : null,
        ),
      ),
    );
  }

  // Performance tab methods
  Widget _buildPerformanceMetrics() {
    return Row(
      children: [
        Expanded(child: _buildKPICard('Avg Load Time', '2.4s', '-0.3s', Icons.speed, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildKPICard('Error Rate', '0.12%', '-0.05%', Icons.error_outline, Colors.red)),
      ],
    );
  }

  Widget _buildLoadTimeChart() {
    return _buildTrendChart(); // Reuse trend chart with different data context
  }

  Widget _buildErrorRateChart() {
    return _buildComparisonChart(); // Reuse comparison chart
  }

  Widget _buildPerformanceBreakdown() {
    return _buildTopMetricsTable(); // Reuse table with performance metrics
  }

  // Engagement tab methods
  Widget _buildEngagementMetrics() {
    return Row(
      children: [
        Expanded(child: _buildKPICard('Avg Session', '4m 32s', '+15s', Icons.timer, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildKPICard('Pages/Session', '3.8', '+0.2', Icons.pageview, Colors.green)),
      ],
    );
  }

  Widget _buildSessionDurationChart() {
    return _buildTrendChart();
  }

  Widget _buildPageViewsChart() {
    return _buildComparisonChart();
  }

  Widget _buildUserBehaviorHeatmap() {
    return _buildTopMetricsTable();
  }

  // Conversion tab methods
  Widget _buildConversionMetrics() {
    return Row(
      children: [
        Expanded(child: _buildKPICard('Conv. Rate', '3.24%', '+0.8%', Icons.trending_up, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildKPICard('Goal Complete', '1,234', '+156', Icons.flag, Colors.blue)),
      ],
    );
  }

  Widget _buildConversionFunnelChart() {
    return _buildComparisonChart();
  }

  Widget _buildGoalCompletionChart() {
    return _buildTrendChart();
  }

  Widget _buildConversionBreakdown() {
    return _buildTopMetricsTable();
  }
}