package com.aiq.screens.compose

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChartDetailScreen() {
    var selectedTimeframe by remember { mutableStateOf("7D") }
    var selectedMetric by remember { mutableStateOf("Revenue") }
    var showComparison by remember { mutableStateOf(false) }
    var selectedTab by remember { mutableStateOf(0) }

    val timeframes = listOf("1D", "7D", "1M", "3M", "6M", "1Y")
    val metrics = listOf("Revenue", "Users", "Orders", "Sessions", "Conversion")
    val tabTitles = listOf("Chart", "Data", "Insights")

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("$selectedMetric Analysis") },
                actions = {
                    IconButton(onClick = { /* Share chart */ }) {
                        Icon(Icons.Default.Share, contentDescription = "Share")
                    }
                    IconButton(onClick = { /* Export chart */ }) {
                        Icon(Icons.Default.FileDownload, contentDescription = "Export")
                    }
                    var expanded by remember { mutableStateOf(false) }
                    Box {
                        IconButton(onClick = { expanded = true }) {
                            Icon(Icons.Default.MoreVert, contentDescription = "More")
                        }
                        DropdownMenu(
                            expanded = expanded,
                            onDismissRequest = { expanded = false }
                        ) {
                            DropdownMenuItem(
                                text = { Text("Fullscreen") },
                                onClick = { expanded = false }
                            )
                            DropdownMenuItem(
                                text = { Text("Refresh Data") },
                                onClick = { expanded = false }
                            )
                            DropdownMenuItem(
                                text = { Text("Chart Settings") },
                                onClick = { expanded = false }
                            )
                        }
                    }
                }
            )
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            item {
                ControlsSection(
                    selectedMetric = selectedMetric,
                    selectedTimeframe = selectedTimeframe,
                    showComparison = showComparison,
                    metrics = metrics,
                    timeframes = timeframes,
                    onMetricChanged = { selectedMetric = it },
                    onTimeframeChanged = { selectedTimeframe = it },
                    onComparisonToggled = { showComparison = it }
                )
            }

            item {
                TabSelector(
                    selectedTab = selectedTab,
                    tabTitles = tabTitles,
                    onTabSelected = { selectedTab = it }
                )
            }

            item {
                Spacer(modifier = Modifier.height(16.dp))
            }

            when (selectedTab) {
                0 -> {
                    // Chart content
                    item {
                        ChartContent(selectedMetric, selectedTimeframe, showComparison)
                    }
                }
                1 -> {
                    // Data content
                    item {
                        DataContent()
                    }
                }
                2 -> {
                    // Insights content
                    item {
                        InsightsContent(selectedMetric)
                    }
                }
            }
        }
    }
}

@Composable
private fun ControlsSection(
    selectedMetric: String,
    selectedTimeframe: String,
    showComparison: Boolean,
    metrics: List<String>,
    timeframes: List<String>,
    onMetricChanged: (String) -> Unit,
    onTimeframeChanged: (String) -> Unit,
    onComparisonToggled: (Boolean) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                var expanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = it },
                    modifier = Modifier.weight(1f)
                ) {
                    OutlinedTextField(
                        value = selectedMetric,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Metric") },
                        leadingIcon = {
                            Icon(getMetricIcon(selectedMetric), contentDescription = null)
                        },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor()
                    )

                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        metrics.forEach { metric ->
                            DropdownMenuItem(
                                text = { Text(metric) },
                                leadingIcon = { Icon(getMetricIcon(metric), contentDescription = null) },
                                onClick = {
                                    onMetricChanged(metric)
                                    expanded = false
                                }
                            )
                        }
                    }
                }

                Spacer(modifier = Modifier.width(16.dp))

                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Compare")
                    Spacer(modifier = Modifier.width(8.dp))
                    Switch(
                        checked = showComparison,
                        onCheckedChange = onComparisonToggled
                    )
                }
            }

            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                contentPadding = PaddingValues(horizontal = 4.dp)
            ) {
                items(timeframes) { timeframe ->
                    FilterChip(
                        selected = selectedTimeframe == timeframe,
                        onClick = { onTimeframeChanged(timeframe) },
                        label = { Text(timeframe) }
                    )
                }
            }
        }
    }
}

@Composable
private fun TabSelector(
    selectedTab: Int,
    tabTitles: List<String>,
    onTabSelected: (Int) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        shape = RoundedCornerShape(12.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(MaterialTheme.colorScheme.surfaceVariant)
                .padding(4.dp)
        ) {
            tabTitles.forEachIndexed { index, title ->
                val isSelected = selectedTab == index
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .height(40.dp),
                    onClick = { onTabSelected(index) },
                    color = if (isSelected) MaterialTheme.colorScheme.surface else Color.Transparent,
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Box(
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = title,
                            style = MaterialTheme.typography.bodyMedium,
                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal,
                            color = if (isSelected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun ChartContent(selectedMetric: String, selectedTimeframe: String, showComparison: Boolean) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        MainChart(selectedMetric, selectedTimeframe, showComparison)
        QuickStats(selectedMetric)
        if (showComparison) {
            ComparisonChart()
        }
        TrendAnalysis()
    }
}

@Composable
private fun MainChart(selectedMetric: String, selectedTimeframe: String, showComparison: Boolean) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "$selectedMetric Over Time",
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold
                )

                Row {
                    IconButton(onClick = { /* Line chart */ }) {
                        Icon(
                            Icons.Default.ShowChart,
                            contentDescription = "Line Chart",
                            tint = MaterialTheme.colorScheme.primary
                        )
                    }
                    IconButton(onClick = { /* Bar chart */ }) {
                        Icon(
                            Icons.Default.BarChart,
                            contentDescription = "Bar Chart",
                            tint = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                    IconButton(onClick = { /* Pie chart */ }) {
                        Icon(
                            Icons.Default.PieChart,
                            contentDescription = "Pie Chart",
                            tint = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Main chart placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(300.dp)
                    .background(
                        color = getMetricColor(selectedMetric).copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        imageVector = Icons.Default.ShowChart,
                        contentDescription = null,
                        tint = getMetricColor(selectedMetric),
                        modifier = Modifier.size(64.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Interactive $selectedMetric Chart",
                        style = MaterialTheme.typography.headlineSmall,
                        color = getMetricColor(selectedMetric),
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        text = "Timeframe: $selectedTimeframe",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    if (showComparison) {
                        Text(
                            text = "With comparison data",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            if (showComparison) {
                Spacer(modifier = Modifier.height(16.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.Center
                ) {
                    LegendItem("Current Period", getMetricColor(selectedMetric))
                    Spacer(modifier = Modifier.width(20.dp))
                    LegendItem("Previous Period", Color(0xFFFF9800))
                }
            }
        }
    }
}

@Composable
private fun QuickStats(selectedMetric: String) {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                StatData("Current Value", getCurrentValue(selectedMetric), getMetricIcon(selectedMetric), getMetricColor(selectedMetric)),
                StatData("Change", "+18.5%", Icons.Default.TrendingUp, Color(0xFF4CAF50)),
                StatData("Average", getAverageValue(selectedMetric), Icons.Default.ShowChart, Color(0xFF2196F3))
            )
        ) { stat ->
            StatCard(stat)
        }
    }
}

@Composable
private fun StatCard(stat: StatData) {
    Card(
        modifier = Modifier
            .width(120.dp)
            .height(80.dp),
        shape = RoundedCornerShape(8.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(12.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Icon(
                imageVector = stat.icon,
                contentDescription = null,
                tint = stat.color,
                modifier = Modifier.size(20.dp)
            )

            Text(
                text = stat.value,
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = stat.color
            )

            Text(
                text = stat.title,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
private fun ComparisonChart() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Period Comparison",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(150.dp)
                    .background(
                        color = Color(0xFF9C27B0).copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        imageVector = Icons.Default.BarChart,
                        contentDescription = null,
                        tint = Color(0xFF9C27B0),
                        modifier = Modifier.size(32.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Weekly Comparison",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFF9C27B0)
                    )
                }
            }
        }
    }
}

@Composable
private fun TrendAnalysis() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Trend Analysis",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            val trends = listOf(
                TrendData("Overall Trend", "Upward", Icons.Default.TrendingUp, Color(0xFF4CAF50)),
                TrendData("Volatility", "Moderate", Icons.Default.ShowChart, Color(0xFFFF9800)),
                TrendData("Seasonality", "Weekly Pattern", Icons.Default.CalendarToday, Color(0xFF2196F3)),
                TrendData("Forecast", "Positive Growth", Icons.Default.Psychology, Color(0xFF9C27B0))
            )

            trends.forEach { trend ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = trend.icon,
                        contentDescription = null,
                        tint = trend.color,
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        text = trend.title,
                        style = MaterialTheme.typography.bodyMedium,
                        modifier = Modifier.weight(1f)
                    )
                    Text(
                        text = trend.value,
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Medium,
                        color = trend.color
                    )
                }
            }
        }
    }
}

@Composable
private fun DataContent() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        DataSummary()
        DataTable()
        DataExportOptions()
    }
}

@Composable
private fun DataSummary() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Data Summary",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                DataSummaryItem("Total Points", "30")
                DataSummaryItem("Min Value", "1.2K")
                DataSummaryItem("Max Value", "8.7K")
            }
        }
    }
}

@Composable
private fun DataSummaryItem(title: String, value: String) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = value,
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF2196F3)
        )
        Text(
            text = title,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun DataTable() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Raw Data",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Table placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .background(
                        color = MaterialTheme.colorScheme.surfaceVariant,
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        imageVector = Icons.Default.TableChart,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Data Table",
                        style = MaterialTheme.typography.bodyLarge,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Text(
                        text = "Date | Value | Change",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

@Composable
private fun DataExportOptions() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Export Options",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Button(
                    onClick = { /* Export CSV */ },
                    modifier = Modifier.weight(1f)
                ) {
                    Icon(Icons.Default.FileDownload, contentDescription = null, modifier = Modifier.size(16.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("CSV")
                }

                Button(
                    onClick = { /* Export Excel */ },
                    modifier = Modifier.weight(1f)
                ) {
                    Icon(Icons.Default.TableChart, contentDescription = null, modifier = Modifier.size(16.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Excel")
                }

                Button(
                    onClick = { /* Export PDF */ },
                    modifier = Modifier.weight(1f)
                ) {
                    Icon(Icons.Default.PictureAsPdf, contentDescription = null, modifier = Modifier.size(16.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("PDF")
                }
            }
        }
    }
}

@Composable
private fun InsightsContent(selectedMetric: String) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        KeyInsights(selectedMetric)
        TrendPredictions()
        Recommendations()
    }
}

@Composable
private fun KeyInsights(selectedMetric: String) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Key Insights",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            val insights = listOf(
                InsightData(
                    "Peak Performance",
                    "Highest $selectedMetric was recorded on March 15th",
                    Icons.Default.Star,
                    Color(0xFFFF9800)
                ),
                InsightData(
                    "Growth Pattern",
                    "18.5% increase compared to previous period",
                    Icons.Default.TrendingUp,
                    Color(0xFF4CAF50)
                ),
                InsightData(
                    "Weekly Trend",
                    "Consistent growth every Wednesday",
                    Icons.Default.CalendarToday,
                    Color(0xFF2196F3)
                )
            )

            insights.forEach { insight ->
                InsightRow(insight)
            }
        }
    }
}

@Composable
private fun InsightRow(insight: InsightData) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        verticalAlignment = Alignment.Top
    ) {
        Box(
            modifier = Modifier
                .size(32.dp)
                .background(
                    color = insight.color.copy(alpha = 0.1f),
                    shape = RoundedCornerShape(8.dp)
                ),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = insight.icon,
                contentDescription = null,
                tint = insight.color,
                modifier = Modifier.size(16.dp)
            )
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column {
            Text(
                text = insight.title,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.Bold
            )
            Text(
                text = insight.description,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun TrendPredictions() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "AI Predictions",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            val predictions = listOf(
                PredictionData("Next Week", "+12.3%", Color(0xFF4CAF50)),
                PredictionData("Next Month", "+8.7%", Color(0xFF2196F3)),
                PredictionData("Next Quarter", "+15.2%", Color(0xFF9C27B0))
            )

            predictions.forEach { prediction ->
                PredictionRow(prediction)
            }
        }
    }
}

@Composable
private fun PredictionRow(prediction: PredictionData) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = prediction.period,
            style = MaterialTheme.typography.bodyMedium
        )

        Surface(
            color = prediction.color.copy(alpha = 0.1f),
            shape = RoundedCornerShape(8.dp)
        ) {
            Text(
                text = prediction.value,
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Bold,
                color = prediction.color,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
            )
        }
    }
}

@Composable
private fun Recommendations() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Recommendations",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            val recommendations = listOf(
                RecommendationData(
                    "Focus on Wednesdays",
                    "Amplify marketing efforts on Wednesdays for maximum impact",
                    Icons.Default.Lightbulb
                ),
                RecommendationData(
                    "Monitor Volatility",
                    "Set up alerts for significant deviations from trend",
                    Icons.Default.Warning
                ),
                RecommendationData(
                    "Optimize Peak Hours",
                    "Increase resource allocation during peak performance times",
                    Icons.Default.Schedule
                )
            )

            recommendations.forEach { recommendation ->
                RecommendationRow(recommendation)
            }
        }
    }
}

@Composable
private fun RecommendationRow(recommendation: RecommendationData) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        verticalAlignment = Alignment.Top
    ) {
        Icon(
            imageVector = recommendation.icon,
            contentDescription = null,
            tint = Color(0xFF2196F3),
            modifier = Modifier.size(20.dp)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Column {
            Text(
                text = recommendation.title,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.Bold
            )
            Text(
                text = recommendation.description,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun LegendItem(label: String, color: Color) {
    Row(
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(12.dp)
                .background(
                    color = color,
                    shape = RoundedCornerShape(2.dp)
                )
        )
        Spacer(modifier = Modifier.width(6.dp))
        Text(
            text = label,
            style = MaterialTheme.typography.labelSmall
        )
    }
}

// Helper functions
private fun getMetricIcon(metric: String): ImageVector {
    return when (metric) {
        "Revenue" -> Icons.Default.AttachMoney
        "Users" -> Icons.Default.People
        "Orders" -> Icons.Default.ShoppingCart
        "Sessions" -> Icons.Default.Schedule
        "Conversion" -> Icons.Default.TrendingUp
        else -> Icons.Default.BarChart
    }
}

private fun getMetricColor(metric: String): Color {
    return when (metric) {
        "Revenue" -> Color(0xFF4CAF50)
        "Users" -> Color(0xFF2196F3)
        "Orders" -> Color(0xFFFF9800)
        "Sessions" -> Color(0xFF9C27B0)
        "Conversion" -> Color(0xFFF44336)
        else -> Color(0xFF2196F3)
    }
}

private fun getCurrentValue(metric: String): String {
    return when (metric) {
        "Revenue" -> "$5.8K"
        "Users" -> "2.4K"
        "Orders" -> "156"
        "Sessions" -> "3.2K"
        "Conversion" -> "3.24%"
        else -> "N/A"
    }
}

private fun getAverageValue(metric: String): String {
    return when (metric) {
        "Revenue" -> "$4.7K"
        "Users" -> "2.1K"
        "Orders" -> "142"
        "Sessions" -> "2.8K"
        "Conversion" -> "3.12%"
        else -> "N/A"
    }
}

// Data classes
private data class StatData(
    val title: String,
    val value: String,
    val icon: ImageVector,
    val color: Color
)

private data class TrendData(
    val title: String,
    val value: String,
    val icon: ImageVector,
    val color: Color
)

private data class InsightData(
    val title: String,
    val description: String,
    val icon: ImageVector,
    val color: Color
)

private data class PredictionData(
    val period: String,
    val value: String,
    val color: Color
)

private data class RecommendationData(
    val title: String,
    val description: String,
    val icon: ImageVector
)