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
import androidx.compose.ui.unit.dp
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ReportsScreen() {
    var selectedCategory by remember { mutableStateOf("All") }
    var selectedStatus by remember { mutableStateOf("All") }
    var showingFilters by remember { mutableStateOf(false) }
    var showingCreateReport by remember { mutableStateOf(false) }

    val categories = listOf("All", "Financial", "Analytics", "Performance", "Marketing", "Security")
    val statuses = listOf("All", "Completed", "Generating", "Scheduled", "Failed")

    val reports = remember {
        listOf(
            ReportData(
                id = "1",
                title = "Monthly Revenue Report",
                description = "Comprehensive revenue analysis for the current month",
                category = "Financial",
                status = ReportStatus.Completed,
                createdDate = LocalDateTime.now().minusDays(2),
                completedDate = LocalDateTime.now().minusDays(1),
                size = "2.5 MB",
                type = "PDF"
            ),
            ReportData(
                id = "2",
                title = "User Engagement Analytics",
                description = "Detailed user behavior and engagement metrics",
                category = "Analytics",
                status = ReportStatus.Generating,
                createdDate = LocalDateTime.now().minusHours(4),
                completedDate = null,
                size = "1.8 MB",
                type = "Excel"
            ),
            ReportData(
                id = "3",
                title = "Performance Metrics Q1",
                description = "First quarter performance overview and KPIs",
                category = "Performance",
                status = ReportStatus.Completed,
                createdDate = LocalDateTime.now().minusDays(7),
                completedDate = LocalDateTime.now().minusDays(6),
                size = "3.2 MB",
                type = "PDF"
            ),
            ReportData(
                id = "4",
                title = "Customer Segmentation Analysis",
                description = "Customer demographic and behavioral segmentation",
                category = "Marketing",
                status = ReportStatus.Scheduled,
                createdDate = LocalDateTime.now().minusDays(1),
                completedDate = null,
                size = "TBD",
                type = "Excel"
            ),
            ReportData(
                id = "5",
                title = "Security Audit Report",
                description = "Monthly security assessment and recommendations",
                category = "Security",
                status = ReportStatus.Failed,
                createdDate = LocalDateTime.now().minusDays(3),
                completedDate = null,
                size = "N/A",
                type = "PDF"
            )
        )
    }

    val filteredReports = reports.filter { report ->
        val categoryMatch = selectedCategory == "All" || report.category == selectedCategory
        val statusMatch = selectedStatus == "All" || report.status.name == selectedStatus
        categoryMatch && statusMatch
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Reports") },
                actions = {
                    IconButton(onClick = { showingFilters = true }) {
                        Icon(Icons.Default.FilterList, contentDescription = "Filter")
                    }
                    IconButton(onClick = { showingCreateReport = true }) {
                        Icon(Icons.Default.Add, contentDescription = "Create Report")
                    }
                }
            )
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            item {
                SummaryCardsRow(reports)
            }

            item {
                FiltersRow(
                    selectedCategory = selectedCategory,
                    selectedStatus = selectedStatus,
                    categories = categories,
                    statuses = statuses,
                    onCategoryChanged = { selectedCategory = it },
                    onStatusChanged = { selectedStatus = it }
                )
            }

            items(filteredReports) { report ->
                ReportCard(
                    report = report,
                    onDownload = { /* Handle download */ },
                    onRetry = { /* Handle retry */ },
                    onViewDetails = { /* Handle view details */ },
                    onAction = { action -> /* Handle action */ }
                )
            }
        }
    }

    if (showingFilters) {
        FiltersDialog(
            selectedCategory = selectedCategory,
            selectedStatus = selectedStatus,
            categories = categories,
            statuses = statuses,
            onCategoryChanged = { selectedCategory = it },
            onStatusChanged = { selectedStatus = it },
            onDismiss = { showingFilters = false }
        )
    }

    if (showingCreateReport) {
        CreateReportDialog(
            categories = categories.drop(1), // Remove "All"
            onDismiss = { showingCreateReport = false },
            onCreate = { title, description, category ->
                // Handle create report
                showingCreateReport = false
            }
        )
    }
}

@Composable
private fun SummaryCardsRow(reports: List<ReportData>) {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                SummaryCardData("Total Reports", reports.size.toString(), Icons.Default.Description, Color(0xFF2196F3)),
                SummaryCardData("Completed", reports.count { it.status == ReportStatus.Completed }.toString(), Icons.Default.CheckCircle, Color(0xFF4CAF50)),
                SummaryCardData("Pending", reports.count { it.status != ReportStatus.Completed }.toString(), Icons.Default.Pending, Color(0xFFFF9800))
            )
        ) { card ->
            SummaryCard(card)
        }
    }
}

@Composable
private fun SummaryCard(card: SummaryCardData) {
    Card(
        modifier = Modifier
            .width(120.dp)
            .height(100.dp),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Icon(
                imageVector = card.icon,
                contentDescription = null,
                tint = card.color,
                modifier = Modifier.size(24.dp)
            )

            Text(
                text = card.value,
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                color = card.color
            )

            Text(
                text = card.title,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun FiltersRow(
    selectedCategory: String,
    selectedStatus: String,
    categories: List<String>,
    statuses: List<String>,
    onCategoryChanged: (String) -> Unit,
    onStatusChanged: (String) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        var categoryExpanded by remember { mutableStateOf(false) }
        var statusExpanded by remember { mutableStateOf(false) }

        ExposedDropdownMenuBox(
            expanded = categoryExpanded,
            onExpandedChange = { categoryExpanded = it },
            modifier = Modifier.weight(1f)
        ) {
            OutlinedTextField(
                value = selectedCategory,
                onValueChange = {},
                readOnly = true,
                label = { Text("Category") },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = categoryExpanded) },
                modifier = Modifier
                    .fillMaxWidth()
                    .menuAnchor()
            )

            ExposedDropdownMenu(
                expanded = categoryExpanded,
                onDismissRequest = { categoryExpanded = false }
            ) {
                categories.forEach { category ->
                    DropdownMenuItem(
                        text = { Text(category) },
                        onClick = {
                            onCategoryChanged(category)
                            categoryExpanded = false
                        }
                    )
                }
            }
        }

        ExposedDropdownMenuBox(
            expanded = statusExpanded,
            onExpandedChange = { statusExpanded = it },
            modifier = Modifier.weight(1f)
        ) {
            OutlinedTextField(
                value = selectedStatus,
                onValueChange = {},
                readOnly = true,
                label = { Text("Status") },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = statusExpanded) },
                modifier = Modifier
                    .fillMaxWidth()
                    .menuAnchor()
            )

            ExposedDropdownMenu(
                expanded = statusExpanded,
                onDismissRequest = { statusExpanded = false }
            ) {
                statuses.forEach { status ->
                    DropdownMenuItem(
                        text = { Text(status) },
                        onClick = {
                            onStatusChanged(status)
                            statusExpanded = false
                        }
                    )
                }
            }
        }
    }
}

@Composable
private fun ReportCard(
    report: ReportData,
    onDownload: () -> Unit,
    onRetry: () -> Unit,
    onViewDetails: () -> Unit,
    onAction: (String) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
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
                verticalAlignment = Alignment.Top
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = report.title,
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = report.description,
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                StatusBadge(report.status)
            }

            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(
                    listOf(
                        InfoChipData(report.category, Icons.Default.Folder, Color(0xFF2196F3)),
                        InfoChipData(report.type, Icons.Default.Description, Color(0xFF4CAF50)),
                        InfoChipData(report.size, Icons.Default.Storage, Color(0xFF9C27B0))
                    )
                ) { chip ->
                    InfoChip(chip)
                }
            }

            Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Schedule,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = "Created: ${report.createdDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))}",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                report.completedDate?.let { completedDate ->
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.Done,
                            contentDescription = null,
                            modifier = Modifier.size(16.dp),
                            tint = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = "Completed: ${completedDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))}",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                if (report.status == ReportStatus.Completed) {
                    Button(
                        onClick = onDownload,
                        modifier = Modifier.height(32.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Download,
                            contentDescription = null,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Download")
                    }
                }

                if (report.status == ReportStatus.Failed) {
                    Button(
                        onClick = onRetry,
                        colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error),
                        modifier = Modifier.height(32.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Refresh,
                            contentDescription = null,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Retry")
                    }
                }

                OutlinedButton(
                    onClick = onViewDetails,
                    modifier = Modifier.height(32.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.Visibility,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("View Details")
                }

                Spacer(modifier = Modifier.weight(1f))

                var expanded by remember { mutableStateOf(false) }
                Box {
                    IconButton(onClick = { expanded = true }) {
                        Icon(Icons.Default.MoreVert, contentDescription = "More actions")
                    }

                    DropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        DropdownMenuItem(
                            text = { Text("Duplicate") },
                            onClick = {
                                onAction("duplicate")
                                expanded = false
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Share") },
                            onClick = {
                                onAction("share")
                                expanded = false
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Delete") },
                            onClick = {
                                onAction("delete")
                                expanded = false
                            }
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun StatusBadge(status: ReportStatus) {
    val (color, icon) = when (status) {
        ReportStatus.Completed -> Color(0xFF4CAF50) to Icons.Default.CheckCircle
        ReportStatus.Generating -> Color(0xFF2196F3) to Icons.Default.Hourglass
        ReportStatus.Scheduled -> Color(0xFFFF9800) to Icons.Default.Schedule
        ReportStatus.Failed -> Color(0xFFF44336) to Icons.Default.Error
    }

    Surface(
        color = color.copy(alpha = 0.1f),
        shape = RoundedCornerShape(8.dp)
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = color,
                modifier = Modifier.size(14.dp)
            )
            Spacer(modifier = Modifier.width(4.dp))
            Text(
                text = status.name,
                style = MaterialTheme.typography.labelSmall,
                color = color,
                fontWeight = FontWeight.Medium
            )
        }
    }
}

@Composable
private fun InfoChip(chip: InfoChipData) {
    Surface(
        color = chip.color.copy(alpha = 0.1f),
        shape = RoundedCornerShape(6.dp)
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 6.dp, vertical = 3.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = chip.icon,
                contentDescription = null,
                tint = chip.color,
                modifier = Modifier.size(10.dp)
            )
            Spacer(modifier = Modifier.width(4.dp))
            Text(
                text = chip.text,
                style = MaterialTheme.typography.labelSmall,
                color = chip.color,
                fontWeight = FontWeight.Medium
            )
        }
    }
}

@Composable
private fun FiltersDialog(
    selectedCategory: String,
    selectedStatus: String,
    categories: List<String>,
    statuses: List<String>,
    onCategoryChanged: (String) -> Unit,
    onStatusChanged: (String) -> Unit,
    onDismiss: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Advanced Filters") },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                // Additional filter options can be added here
                Text("Additional filter options would go here")
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("Apply")
            }
        },
        dismissButton = {
            TextButton(onClick = {
                onCategoryChanged("All")
                onStatusChanged("All")
                onDismiss()
            }) {
                Text("Reset")
            }
        }
    )
}

@Composable
private fun CreateReportDialog(
    categories: List<String>,
    onDismiss: () -> Unit,
    onCreate: (String, String, String) -> Unit
) {
    var title by remember { mutableStateOf("") }
    var description by remember { mutableStateOf("") }
    var selectedCategory by remember { mutableStateOf(categories.first()) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Create New Report") },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                OutlinedTextField(
                    value = title,
                    onValueChange = { title = it },
                    label = { Text("Report Title") },
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = description,
                    onValueChange = { description = it },
                    label = { Text("Description") },
                    modifier = Modifier.fillMaxWidth(),
                    minLines = 3
                )

                var expanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = it }
                ) {
                    OutlinedTextField(
                        value = selectedCategory,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Category") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor()
                    )

                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        categories.forEach { category ->
                            DropdownMenuItem(
                                text = { Text(category) },
                                onClick = {
                                    selectedCategory = category
                                    expanded = false
                                }
                            )
                        }
                    }
                }
            }
        },
        confirmButton = {
            TextButton(
                onClick = { onCreate(title, description, selectedCategory) },
                enabled = title.isNotBlank()
            ) {
                Text("Generate")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}

// Data classes
private data class ReportData(
    val id: String,
    val title: String,
    val description: String,
    val category: String,
    val status: ReportStatus,
    val createdDate: LocalDateTime,
    val completedDate: LocalDateTime?,
    val size: String,
    val type: String
)

private enum class ReportStatus {
    Completed, Generating, Scheduled, Failed
}

private data class SummaryCardData(
    val title: String,
    val value: String,
    val icon: ImageVector,
    val color: Color
)

private data class InfoChipData(
    val text: String,
    val icon: ImageVector,
    val color: Color
)