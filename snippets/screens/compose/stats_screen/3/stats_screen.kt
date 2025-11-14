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
fun StatsScreen() {
    var selectedTimeframe by remember { mutableStateOf("This Month") }
    var selectedTab by remember { mutableStateOf(0) }

    val timeframes = listOf("Today", "This Week", "This Month", "This Quarter", "This Year")
    val tabTitles = listOf("Overview", "Performance", "Engagement", "Conversion")

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Detailed Statistics") },
                actions = {
                    var expanded by remember { mutableStateOf(false) }

                    ExposedDropdownMenuBox(
                        expanded = expanded,
                        onExpandedChange = { expanded = !expanded }
                    ) {
                        IconButton(
                            onClick = { expanded = true },
                            modifier = Modifier.menuAnchor()
                        ) {
                            Icon(Icons.Default.FilterList, contentDescription = "Filter")
                        }

                        ExposedDropdownMenu(
                            expanded = expanded,
                            onDismissRequest = { expanded = false }
                        ) {
                            timeframes.forEach { timeframe ->
                                DropdownMenuItem(
                                    text = { Text(timeframe) },
                                    onClick = {
                                        selectedTimeframe = timeframe
                                        expanded = false
                                    }
                                )
                            }
                        }
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // Tab selector
            ScrollableTabRow(
                selectedTabIndex = selectedTab,
                modifier = Modifier.fillMaxWidth(),
                edgePadding = 16.dp
            ) {
                tabTitles.forEachIndexed { index, title ->
                    Tab(
                        selected = selectedTab == index,
                        onClick = { selectedTab = index },
                        text = { Text(title) }
                    )
                }
            }

            // Content
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                when (selectedTab) {
                    0 -> {
                        // Overview
                        item { KPIGrid() }
                        item { TrendChart(selectedTimeframe) }
                        item { ComparisonChart() }
                        item { TopMetricsTable() }
                    }
                    1 -> {
                        // Performance
                        item { PerformanceMetrics() }
                        item { LoadTimeChart() }
                        item { ErrorRateChart() }
                        item { PerformanceBreakdown() }
                    }
                    2 -> {
                        // Engagement
                        item { EngagementMetrics() }
                        item { SessionDurationChart() }
                        item { PageViewsChart() }
                        item { UserBehaviorHeatmap() }
                    }
                    3 -> {
                        // Conversion
                        item { ConversionMetrics() }
                        item { ConversionFunnelChart() }
                        item { GoalCompletionChart() }
                        item { ConversionBreakdown() }
                    }
                }
            }
        }
    }
}

@Composable
private fun KPIGrid() {
    val kpis = listOf(
        KPIData("Total Revenue", "$245,890", "+18.5%", Icons.Default.AttachMoney, Color(0xFF4CAF50)),
        KPIData("Active Users", "12,456", "+12.3%", Icons.Default.People, Color(0xFF2196F3)),
        KPIData("Conversion Rate", "3.24%", "+0.8%", Icons.Default.TrendingUp, Color(0xFFFF9800)),
        KPIData("Avg Session", "4m 32s", "+15s", Icons.Default.Timer, Color(0xFF9C27B0))
    )

    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(kpis) { kpi ->
            KPICard(kpi)
        }
    }
}

@Composable
private fun KPICard(kpi: KPIData) {
    Card(
        modifier = Modifier
            .width(160.dp)
            .height(140.dp),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Box(
                    modifier = Modifier
                        .size(32.dp)
                        .background(
                            color = kpi.color.copy(alpha = 0.1f),
                            shape = RoundedCornerShape(8.dp)
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = kpi.icon,
                        contentDescription = null,
                        tint = kpi.color,
                        modifier = Modifier.size(20.dp)
                    )
                }

                Surface(
                    color = if (kpi.change.startsWith("+")) Color(0xFF4CAF50).copy(alpha = 0.1f) else Color(0xFFF44336).copy(alpha = 0.1f),
                    shape = RoundedCornerShape(4.dp)
                ) {
                    Text(
                        text = kpi.change,
                        style = MaterialTheme.typography.labelSmall,
                        color = if (kpi.change.startsWith("+")) Color(0xFF4CAF50) else Color(0xFFF44336),
                        fontWeight = FontWeight.SemiBold,
                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                    )
                }
            }

            Column {
                Text(
                    text = kpi.title,
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = kpi.value,
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = kpi.color
                )
            }
        }
    }
}

@Composable
private fun TrendChart(timeframe: String) {
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
                    text = "Revenue Trend - $timeframe",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )

                Row {
                    LegendItem("Current Period", Color(0xFF2196F3))
                    Spacer(modifier = Modifier.width(16.dp))
                    LegendItem("Previous Period", Color(0xFFFF9800))
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Multi-line chart placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(250.dp)
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
                        imageVector = Icons.Default.ShowChart,
                        contentDescription = null,
                        tint = Color(0xFF2196F3),
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Multi-Line Chart",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFF2196F3)
                    )
                    Text(
                        text = "Current vs Previous Period Comparison",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        textAlign = TextAlign.Center
                    )
                }
            }
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
                text = "Performance Comparison",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Grouped bar chart placeholder
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
                        imageVector = Icons.Default.BarChart,
                        contentDescription = null,
                        tint = Color(0xFF4CAF50),
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Grouped Bar Chart",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFF4CAF50)
                    )
                    Text(
                        text = "Revenue, Users, Orders, Sessions",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        textAlign = TextAlign.Center
                    )
                }
            }
        }
    }
}

@Composable
private fun TopMetricsTable() {
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
                text = "Top Performing Metrics",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Table header
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        MaterialTheme.colorScheme.surfaceVariant,
                        RoundedCornerShape(8.dp)
                    )
                    .padding(12.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = "Metric",
                    style = MaterialTheme.typography.labelMedium,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.weight(2f)
                )
                Text(
                    text = "Value",
                    style = MaterialTheme.typography.labelMedium,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.weight(1f),
                    textAlign = TextAlign.End
                )
                Text(
                    text = "Change",
                    style = MaterialTheme.typography.labelMedium,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.weight(1f),
                    textAlign = TextAlign.End
                )
                Text(
                    text = "Trend",
                    style = MaterialTheme.typography.labelMedium,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.weight(0.5f),
                    textAlign = TextAlign.End
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Table rows
            val tableData = listOf(
                TableRowData("Page Views", "45.2K", "+12.5%", true),
                TableRowData("Unique Visitors", "28.1K", "+8.3%", true),
                TableRowData("Bounce Rate", "32.1%", "-2.1%", false),
                TableRowData("Session Duration", "4:32", "+15.2%", true),
                TableRowData("Conversion Rate", "3.24%", "+8.7%", true)
            )

            tableData.forEachIndexed { index, row ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 12.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = row.metric,
                        style = MaterialTheme.typography.bodyMedium,
                        modifier = Modifier.weight(2f)
                    )
                    Text(
                        text = row.value,
                        style = MaterialTheme.typography.bodyMedium,
                        modifier = Modifier.weight(1f),
                        textAlign = TextAlign.End
                    )
                    Text(
                        text = row.change,
                        style = MaterialTheme.typography.bodyMedium,
                        color = if (row.isPositive) Color(0xFF4CAF50) else Color(0xFFF44336),
                        fontWeight = FontWeight.Medium,
                        modifier = Modifier.weight(1f),
                        textAlign = TextAlign.End
                    )
                    Icon(
                        imageVector = if (row.isPositive) Icons.Default.TrendingUp else Icons.Default.TrendingDown,
                        contentDescription = null,
                        tint = if (row.isPositive) Color(0xFF4CAF50) else Color(0xFFF44336),
                        modifier = Modifier
                            .weight(0.5f)
                            .size(16.dp)
                    )
                }

                if (index < tableData.size - 1) {
                    HorizontalDivider(
                        color = MaterialTheme.colorScheme.outlineVariant,
                        thickness = 0.5.dp
                    )
                }
            }
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

// Performance tab components
@Composable
private fun PerformanceMetrics() {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                KPIData("Avg Load Time", "2.4s", "-0.3s", Icons.Default.Speed, Color(0xFF4CAF50)),
                KPIData("Error Rate", "0.12%", "-0.05%", Icons.Default.ErrorOutline, Color(0xFFF44336))
            )
        ) { kpi ->
            KPICard(kpi)
        }
    }
}

@Composable
private fun LoadTimeChart() {
    GenericChart("Load Time Trend", "Load time performance over time", Color(0xFF4CAF50))
}

@Composable
private fun ErrorRateChart() {
    GenericChart("Error Rate", "System error rate monitoring", Color(0xFFF44336))
}

@Composable
private fun PerformanceBreakdown() {
    TopMetricsTable() // Reuse with performance context
}

// Engagement tab components
@Composable
private fun EngagementMetrics() {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                KPIData("Avg Session", "4m 32s", "+15s", Icons.Default.Timer, Color(0xFF2196F3)),
                KPIData("Pages/Session", "3.8", "+0.2", Icons.Default.Description, Color(0xFF4CAF50))
            )
        ) { kpi ->
            KPICard(kpi)
        }
    }
}

@Composable
private fun SessionDurationChart() {
    GenericChart("Session Duration", "Average session duration trends", Color(0xFF2196F3))
}

@Composable
private fun PageViewsChart() {
    GenericChart("Page Views", "Page view analytics", Color(0xFF9C27B0))
}

@Composable
private fun UserBehaviorHeatmap() {
    TopMetricsTable() // Placeholder for heatmap
}

// Conversion tab components
@Composable
private fun ConversionMetrics() {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                KPIData("Conv. Rate", "3.24%", "+0.8%", Icons.Default.TrendingUp, Color(0xFF4CAF50)),
                KPIData("Goal Complete", "1,234", "+156", Icons.Default.Flag, Color(0xFF2196F3))
            )
        ) { kpi ->
            KPICard(kpi)
        }
    }
}

@Composable
private fun ConversionFunnelChart() {
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
                text = "Conversion Funnel",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Funnel chart placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .background(
                        color = Color(0xFFE91E63).copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        imageVector = Icons.Default.FilterList,
                        contentDescription = null,
                        tint = Color(0xFFE91E63),
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Funnel Chart",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFFE91E63)
                    )
                    Text(
                        text = "Visit → Interest → Intent → Purchase",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        textAlign = TextAlign.Center
                    )
                }
            }
        }
    }
}

@Composable
private fun GoalCompletionChart() {
    GenericChart("Goal Completion", "Goal achievement tracking", Color(0xFF4CAF50))
}

@Composable
private fun ConversionBreakdown() {
    TopMetricsTable() // Reuse for conversion metrics
}

@Composable
private fun GenericChart(title: String, description: String, color: Color) {
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
                text = title,
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .background(
                        color = color.copy(alpha = 0.1f),
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
                        tint = color,
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = title,
                        style = MaterialTheme.typography.bodyMedium,
                        color = color
                    )
                    Text(
                        text = description,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        textAlign = TextAlign.Center
                    )
                }
            }
        }
    }
}

// Data classes
private data class KPIData(
    val title: String,
    val value: String,
    val change: String,
    val icon: ImageVector,
    val color: Color
)

private data class TableRowData(
    val metric: String,
    val value: String,
    val change: String,
    val isPositive: Boolean
)