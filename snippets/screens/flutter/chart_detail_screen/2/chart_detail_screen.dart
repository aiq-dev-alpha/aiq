import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartDetailScreen extends StatefulWidget {
  const ChartDetailScreen({Key? key}) : super(key: key);

  @override
  State<ChartDetailScreen> createState() => _ChartDetailScreenState();
}

class _ChartDetailScreenState extends State<ChartDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedTimeframe = '7D';
  String selectedMetric = 'Revenue';
  bool showComparison = false;

  final List<String> timeframes = ['1D', '7D', '1M', '3M', '6M', '1Y'];
  final List<String> metrics = ['Revenue', 'Users', 'Orders', 'Sessions', 'Conversion'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text('$selectedMetric Analysis'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareChart,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportChart,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'fullscreen', child: Text('Fullscreen')),
              const PopupMenuItem(value: 'refresh', child: Text('Refresh Data')),
              const PopupMenuItem(value: 'settings', child: Text('Chart Settings')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chart'),
            Tab(text: 'Data'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildControlsSection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChartTab(),
                _buildDataTab(),
                _buildInsightsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricSelector(),
              ),
              const SizedBox(width: 16),
              _buildComparisonToggle(),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimeframeSelector(),
        ],
      ),
    );
  }

  Widget _buildMetricSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedMetric,
          items: metrics.map((metric) {
            return DropdownMenuItem<String>(
              value: metric,
              child: Row(
                children: [
                  _getMetricIcon(metric),
                  const SizedBox(width: 8),
                  Text(metric),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMetric = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildComparisonToggle() {
    return Row(
      children: [
        const Text('Compare'),
        const SizedBox(width: 8),
        Switch(
          value: showComparison,
          onChanged: (value) {
            setState(() {
              showComparison = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimeframeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: timeframes.map((timeframe) {
          final isSelected = selectedTimeframe == timeframe;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTimeframe = timeframe;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  timeframe,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMainChart(),
          const SizedBox(height: 20),
          _buildQuickStats(),
          const SizedBox(height: 20),
          if (showComparison) ...[
            _buildComparisonChart(),
            const SizedBox(height: 20),
          ],
          _buildTrendAnalysis(),
        ],
      ),
    );
  }

  Widget _buildDataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDataSummary(),
          const SizedBox(height: 20),
          _buildDataTable(),
          const SizedBox(height: 20),
          _buildDataExportOptions(),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildKeyInsights(),
          const SizedBox(height: 20),
          _buildTrendPredictions(),
          const SizedBox(height: 20),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildMainChart() {
    return Container(
      height: 400,
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
                '$selectedMetric Over Time',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildChartTypeToggle(),
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
                  horizontalInterval: _getChartInterval(),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatYAxisValue(value),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatXAxisValue(value),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    color: _getMetricColor(selectedMetric),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: _getMetricColor(selectedMetric).withOpacity(0.1),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: _getMetricColor(selectedMetric),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                  if (showComparison)
                    LineChartBarData(
                      spots: _getComparisonData(),
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 2,
                      dashArray: [5, 5],
                      dotData: FlDotData(show: false),
                    ),
                ],
              ),
            ),
          ),
          if (showComparison) _buildChartLegend(),
        ],
      ),
    );
  }

  Widget _buildChartTypeToggle() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.show_chart),
          onPressed: () {
            // Switch to line chart
          },
          tooltip: 'Line Chart',
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () {
            // Switch to bar chart
          },
          tooltip: 'Bar Chart',
        ),
        IconButton(
          icon: const Icon(Icons.pie_chart),
          onPressed: () {
            // Switch to pie chart
          },
          tooltip: 'Pie Chart',
        ),
      ],
    );
  }

  Widget _buildChartLegend() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem('Current Period', _getMetricColor(selectedMetric)),
          const SizedBox(width: 20),
          _buildLegendItem('Previous Period', Colors.orange),
        ],
      ),
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

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Current Value',
            _getCurrentValue(),
            _getMetricIcon(selectedMetric),
            _getMetricColor(selectedMetric),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Change',
            _getChangeValue(),
            Icons.trending_up,
            _getChangeColor(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Average',
            _getAverageValue(),
            Icons.show_chart,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart() {
    return Container(
      height: 200,
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
            'Period Comparison',
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
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final periods = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                        return Text(periods[value.toInt() % periods.length], style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 85, color: _getMetricColor(selectedMetric))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 78, color: _getMetricColor(selectedMetric))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 92, color: _getMetricColor(selectedMetric))]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 88, color: _getMetricColor(selectedMetric))]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysis() {
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
            'Trend Analysis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTrendItem('Overall Trend', 'Upward', Icons.trending_up, Colors.green),
          _buildTrendItem('Volatility', 'Moderate', Icons.show_chart, Colors.orange),
          _buildTrendItem('Seasonality', 'Weekly Pattern', Icons.calendar_today, Colors.blue),
          _buildTrendItem('Forecast', 'Positive Growth', Icons.insights, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildTrendItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Data Tab Methods
  Widget _buildDataSummary() {
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
            'Data Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSummaryItem('Total Points', '30')),
              Expanded(child: _buildSummaryItem('Min Value', '1.2K')),
              Expanded(child: _buildSummaryItem('Max Value', '8.7K')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
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
            'Raw Data',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade50),
                children: [
                  _buildTableHeader('Date'),
                  _buildTableHeader('Value'),
                  _buildTableHeader('Change'),
                ],
              ),
              ..._generateTableRows(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  List<TableRow> _generateTableRows() {
    return List.generate(10, (index) {
      return TableRow(
        children: [
          _buildTableCell('${DateTime.now().subtract(Duration(days: 9 - index)).day}/${DateTime.now().month}'),
          _buildTableCell('${(3000 + (index * 200)).toString()}'),
          _buildTableCell('+${(5 + (index * 0.5)).toStringAsFixed(1)}%'),
        ],
      );
    });
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(text),
    );
  }

  Widget _buildDataExportOptions() {
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
            'Export Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting to CSV...')),
                    );
                  },
                  icon: const Icon(Icons.file_download),
                  label: const Text('CSV'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting to Excel...')),
                    );
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text('Excel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting to PDF...')),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('PDF'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Insights Tab Methods
  Widget _buildKeyInsights() {
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
            'Key Insights',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Peak Performance',
            'Highest $selectedMetric was recorded on March 15th',
            Icons.star,
            Colors.orange,
          ),
          _buildInsightItem(
            'Growth Pattern',
            '18.5% increase compared to previous period',
            Icons.trending_up,
            Colors.green,
          ),
          _buildInsightItem(
            'Weekly Trend',
            'Consistent growth every Wednesday',
            Icons.calendar_today,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendPredictions() {
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
            'AI Predictions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPredictionItem('Next Week', '+12.3%', Colors.green),
          _buildPredictionItem('Next Month', '+8.7%', Colors.blue),
          _buildPredictionItem('Next Quarter', '+15.2%', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
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
            'Recommendations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            'Focus on Wednesdays',
            'Amplify marketing efforts on Wednesdays for maximum impact',
            Icons.lightbulb,
          ),
          _buildRecommendationItem(
            'Monitor Volatility',
            'Set up alerts for significant deviations from trend',
            Icons.warning,
          ),
          _buildRecommendationItem(
            'Optimize Peak Hours',
            'Increase resource allocation during peak performance times',
            Icons.schedule,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionItem(String period, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(period)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Icon _getMetricIcon(String metric) {
    switch (metric) {
      case 'Revenue':
        return const Icon(Icons.attach_money, size: 16);
      case 'Users':
        return const Icon(Icons.people, size: 16);
      case 'Orders':
        return const Icon(Icons.shopping_cart, size: 16);
      case 'Sessions':
        return const Icon(Icons.access_time, size: 16);
      case 'Conversion':
        return const Icon(Icons.trending_up, size: 16);
      default:
        return const Icon(Icons.show_chart, size: 16);
    }
  }

  Color _getMetricColor(String metric) {
    switch (metric) {
      case 'Revenue':
        return Colors.green;
      case 'Users':
        return Colors.blue;
      case 'Orders':
        return Colors.orange;
      case 'Sessions':
        return Colors.purple;
      case 'Conversion':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  double _getChartInterval() {
    switch (selectedMetric) {
      case 'Revenue':
        return 1000;
      case 'Users':
        return 500;
      default:
        return 100;
    }
  }

  String _formatYAxisValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toInt().toString();
  }

  String _formatXAxisValue(double value) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[value.toInt() % 7];
  }

  List<FlSpot> _getChartData() {
    // Generate sample data based on selected metric and timeframe
    return [
      FlSpot(0, 3500),
      FlSpot(1, 4200),
      FlSpot(2, 3800),
      FlSpot(3, 5100),
      FlSpot(4, 4700),
      FlSpot(5, 6200),
      FlSpot(6, 5800),
    ];
  }

  List<FlSpot> _getComparisonData() {
    // Generate comparison data (previous period)
    return [
      FlSpot(0, 2800),
      FlSpot(1, 3500),
      FlSpot(2, 3100),
      FlSpot(3, 4000),
      FlSpot(4, 3800),
      FlSpot(5, 4400),
      FlSpot(6, 4100),
    ];
  }

  String _getCurrentValue() {
    switch (selectedMetric) {
      case 'Revenue':
        return '\$5.8K';
      case 'Users':
        return '2.4K';
      case 'Orders':
        return '156';
      case 'Sessions':
        return '3.2K';
      case 'Conversion':
        return '3.24%';
      default:
        return 'N/A';
    }
  }

  String _getChangeValue() {
    return '+18.5%';
  }

  Color _getChangeColor() {
    return Colors.green;
  }

  String _getAverageValue() {
    switch (selectedMetric) {
      case 'Revenue':
        return '\$4.7K';
      case 'Users':
        return '2.1K';
      case 'Orders':
        return '142';
      case 'Sessions':
        return '2.8K';
      case 'Conversion':
        return '3.12%';
      default:
        return 'N/A';
    }
  }

  void _shareChart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing chart...')),
    );
  }

  void _exportChart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting chart...')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'fullscreen':
        // Navigate to fullscreen view
        break;
      case 'refresh':
        // Refresh data
        break;
      case 'settings':
        // Show chart settings
        break;
    }
  }
}