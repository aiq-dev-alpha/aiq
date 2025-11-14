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
fun AnalyticsScreen() {
    var selectedPeriod by remember { mutableStateOf("7d") }
    var selectedTab by remember { mutableStateOf(0) }

    val periods = listOf("24h", "7d", "30d", "90d")
    val periodLabels = listOf("Last 24 hours", "Last 7 days", "Last 30 days", "Last 90 days")
    val tabTitles = listOf("Overview", "Revenue", "Users")

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Analytics") },
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
                            Icon(Icons.Default.DateRange, contentDescription = "Select period")
                        }

                        ExposedDropdownMenu(
                            expanded = expanded,
                            onDismissRequest = { expanded = false }
                        ) {
                            periods.forEachIndexed { index, period ->
                                DropdownMenuItem(
                                    text = { Text(periodLabels[index]) },
                                    onClick = {
                                        selectedPeriod = period
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
            TabSelector(
                selectedTab = selectedTab,
                tabTitles = tabTitles,
                onTabSelected = { selectedTab = it }
            )

            // Content based on selected tab
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                when (selectedTab) {
                    0 -> {
                        // Overview content
                        item {
                            OverviewMetricsRow()
                        }
                        item {
                            PerformanceChart("Performance Overview")
                        }
                        item {
                            TrafficSourcesChart()
                        }
                        item {
                            TopPagesChart()
                        }
                    }
                    1 -> {
                        // Revenue content
                        item {
                            RevenueMetricsRow()
                        }
                        item {
                            PerformanceChart("Revenue Trend")
                        }
                        item {
                            RevenueBreakdownChart()
                        }
                    }
                    2 -> {
                        // Users content
                        item {
                            UserMetricsRow()
                        }
                        item {
                            PerformanceChart("User Growth")
                        }
                        item {
                            UserDemographicsChart()
                        }
                    }
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
private fun OverviewMetricsRow() {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                MetricData("Page Views", "45.2K", "+12.5%", Color(0xFF2196F3)),
                MetricData("Sessions", "12.8K", "+8.2%", Color(0xFF4CAF50)),
                MetricData("Bounce Rate", "32.1%", "-2.1%", Color(0xFFFF9800))
            )
        ) { metric ->
            MetricCard(metric)
        }
    }
}

@Composable
private fun RevenueMetricsRow() {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                MetricData("Total Revenue", "$125.4K", "+15.2%", Color(0xFF4CAF50)),
                MetricData("Avg. Order", "$87.50", "+3.1%", Color(0xFF2196F3))
            )
        ) { metric ->
            MetricCard(metric)
        }
    }
}

@Composable
private fun UserMetricsRow() {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                MetricData("Total Users", "25.8K", "+22.1%", Color(0xFF2196F3)),
                MetricData("New Users", "3.2K", "+18.5%", Color(0xFF4CAF50))
            )
        ) { metric ->
            MetricCard(metric)
        }
    }
}

@Composable
private fun MetricCard(metric: MetricData) {
    Card(
        modifier = Modifier
            .width(140.dp)
            .height(100.dp),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = metric.title,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )

            Text(
                text = metric.value,
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                color = metric.color
            )

            Text(
                text = metric.change,
                style = MaterialTheme.typography.labelSmall,
                color = if (metric.change.startsWith("+")) Color(0xFF4CAF50) else Color(0xFFF44336),
                fontWeight = FontWeight.Medium
            )
        }
    }
}

@Composable
private fun PerformanceChart(title: String) {
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

            // Chart placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .background(
                        color = Color(0xFF2196F3).copy(alpha = 0.1f),
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
                        text = "Line Chart Placeholder",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFF2196F3)
                    )
                    Text(
                        text = "Implement with Compose Charts or similar",
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
private fun TrafficSourcesChart() {
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
                text = "Traffic Sources",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth()
            ) {
                // Pie chart placeholder
                Box(
                    modifier = Modifier
                        .size(150.dp)
                        .background(
                            color = Color(0xFF4CAF50).copy(alpha = 0.1f),
                            shape = RoundedCornerShape(8.dp)
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Default.PieChart,
                            contentDescription = null,
                            tint = Color(0xFF4CAF50),
                            modifier = Modifier.size(48.dp)
                        )
                        Text(
                            text = "Pie Chart",
                            style = MaterialTheme.typography.labelMedium,
                            color = Color(0xFF4CAF50)
                        )
                    }
                }

                Spacer(modifier = Modifier.width(20.dp))

                // Legend
                Column(
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    val sources = listOf(
                        LegendData("Direct", Color(0xFF2196F3)),
                        LegendData("Social", Color(0xFF4CAF50)),
                        LegendData("Search", Color(0xFFFF9800)),
                        LegendData("Referral", Color(0xFF9C27B0))
                    )

                    sources.forEach { source ->
                        Row(
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(12.dp)
                                    .background(
                                        color = source.color,
                                        shape = RoundedCornerShape(4.dp)
                                    )
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = source.label,
                                style = MaterialTheme.typography.bodySmall
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun TopPagesChart() {
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
                text = "Top Performing Pages",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Bar chart placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
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
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Bar Chart Placeholder",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFF9C27B0)
                    )
                    Text(
                        text = "Implement with your preferred chart library",
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
private fun RevenueBreakdownChart() {
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
                text = "Revenue by Category",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth()
            ) {
                // Donut chart placeholder
                Box(
                    modifier = Modifier
                        .size(150.dp)
                        .background(
                            color = Color(0xFFFF9800).copy(alpha = 0.1f),
                            shape = RoundedCornerShape(8.dp)
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Default.DonutSmall,
                            contentDescription = null,
                            tint = Color(0xFFFF9800),
                            modifier = Modifier.size(48.dp)
                        )
                        Text(
                            text = "Donut Chart",
                            style = MaterialTheme.typography.labelMedium,
                            color = Color(0xFFFF9800)
                        )
                    }
                }

                Spacer(modifier = Modifier.width(20.dp))

                // Categories
                Column(
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    val categories = listOf(
                        CategoryData("Products", "$45K", Color(0xFF2196F3)),
                        CategoryData("Services", "$30K", Color(0xFF4CAF50)),
                        CategoryData("Subscriptions", "$25K", Color(0xFFFF9800))
                    )

                    categories.forEach { category ->
                        Row(
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(12.dp)
                                    .background(
                                        color = category.color,
                                        shape = RoundedCornerShape(4.dp)
                                    )
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Column {
                                Text(
                                    text = category.name,
                                    style = MaterialTheme.typography.bodySmall
                                )
                                Text(
                                    text = category.value,
                                    style = MaterialTheme.typography.labelSmall,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun UserDemographicsChart() {
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
                text = "User Demographics",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Horizontal bar chart placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .background(
                        color = Color(0xFF673AB7).copy(alpha = 0.1f),
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
                        tint = Color(0xFF673AB7),
                        modifier = Modifier.size(48.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Horizontal Bar Chart",
                        style = MaterialTheme.typography.bodyMedium,
                        color = Color(0xFF673AB7)
                    )
                    Text(
                        text = "Age group demographics",
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
private data class MetricData(
    val title: String,
    val value: String,
    val change: String,
    val color: Color
)

private data class LegendData(
    val label: String,
    val color: Color
)

private data class CategoryData(
    val name: String,
    val value: String,
    val color: Color
)