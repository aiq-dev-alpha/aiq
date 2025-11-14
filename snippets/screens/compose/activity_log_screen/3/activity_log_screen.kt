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
import java.time.temporal.ChronoUnit

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ActivityLogScreen() {
    var selectedFilter by remember { mutableStateOf("All") }
    var selectedUser by remember { mutableStateOf("All Users") }
    var searchText by remember { mutableStateOf("") }
    var showingFilters by remember { mutableStateOf(false) }
    var showingSearch by remember { mutableStateOf(false) }

    val filters = listOf("All", "Purchase", "Account", "Payment", "Profile", "Security", "Review", "System", "Support")
    val users = listOf("All Users", "John Smith", "Sarah Wilson", "Mike Johnson", "Emma Davis", "Alex Rodriguez", "Admin", "System")

    val activities = remember {
        getSampleActivities()
    }

    val filteredActivities = activities.filter { activity ->
        val typeMatch = selectedFilter == "All" || activity.type.name.equals(selectedFilter, ignoreCase = true)
        val userMatch = selectedUser == "All Users" || activity.user == selectedUser
        val searchMatch = searchText.isEmpty() ||
                         activity.action.contains(searchText, ignoreCase = true) ||
                         activity.details.contains(searchText, ignoreCase = true) ||
                         activity.user.contains(searchText, ignoreCase = true)

        typeMatch && userMatch && searchMatch
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Activity Log") },
                actions = {
                    IconButton(onClick = { showingFilters = true }) {
                        Icon(Icons.Default.FilterList, contentDescription = "Filter")
                    }
                    IconButton(onClick = { showingSearch = true }) {
                        Icon(Icons.Default.Search, contentDescription = "Search")
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
                                text = { Text("Export Log") },
                                onClick = { expanded = false }
                            )
                            DropdownMenuItem(
                                text = { Text("Clear History") },
                                onClick = { expanded = false }
                            )
                            DropdownMenuItem(
                                text = { Text("Log Settings") },
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
                SummaryCardsSection(activities)
            }

            item {
                ActiveFiltersSection(
                    selectedFilter = selectedFilter,
                    selectedUser = selectedUser,
                    searchText = searchText,
                    onFilterRemoved = { selectedFilter = "All" },
                    onUserRemoved = { selectedUser = "All Users" },
                    onSearchRemoved = { searchText = "" },
                    onClearAll = {
                        selectedFilter = "All"
                        selectedUser = "All Users"
                        searchText = ""
                    }
                )
            }

            if (filteredActivities.isEmpty()) {
                item {
                    EmptyStateSection()
                }
            } else {
                items(filteredActivities) { activity ->
                    ActivityCard(
                        activity = activity,
                        onClick = { /* Show details */ }
                    )
                }
            }
        }
    }

    if (showingFilters) {
        FiltersDialog(
            selectedFilter = selectedFilter,
            selectedUser = selectedUser,
            filters = filters,
            users = users,
            onFilterChanged = { selectedFilter = it },
            onUserChanged = { selectedUser = it },
            onDismiss = { showingFilters = false },
            onReset = {
                selectedFilter = "All"
                selectedUser = "All Users"
                showingFilters = false
            }
        )
    }

    if (showingSearch) {
        SearchDialog(
            searchText = searchText,
            onSearchChanged = { searchText = it },
            onDismiss = { showingSearch = false }
        )
    }
}

@Composable
private fun SummaryCardsSection(activities: List<ActivityLogEntry>) {
    LazyRow(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 4.dp)
    ) {
        items(
            listOf(
                SummaryCardData(
                    title = "Total Activities",
                    value = activities.size.toString(),
                    icon = Icons.Default.List,
                    color = Color(0xFF2196F3)
                ),
                SummaryCardData(
                    title = "Critical",
                    value = activities.count { it.severity == ActivitySeverity.Error }.toString(),
                    icon = Icons.Default.Error,
                    color = Color(0xFFF44336)
                ),
                SummaryCardData(
                    title = "Recent (1h)",
                    value = activities.count {
                        ChronoUnit.HOURS.between(it.timestamp, LocalDateTime.now()) < 1
                    }.toString(),
                    icon = Icons.Default.AccessTime,
                    color = Color(0xFF4CAF50)
                )
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
            Box(
                modifier = Modifier
                    .size(32.dp)
                    .background(
                        color = card.color.copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = card.icon,
                    contentDescription = null,
                    tint = card.color,
                    modifier = Modifier.size(20.dp)
                )
            }

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
private fun ActiveFiltersSection(
    selectedFilter: String,
    selectedUser: String,
    searchText: String,
    onFilterRemoved: () -> Unit,
    onUserRemoved: () -> Unit,
    onSearchRemoved: () -> Unit,
    onClearAll: () -> Unit
) {
    val hasActiveFilters = selectedFilter != "All" || selectedUser != "All Users" || searchText.isNotEmpty()

    if (hasActiveFilters) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Active Filters:",
                    style = MaterialTheme.typography.labelSmall,
                    fontWeight = FontWeight.Bold
                )

                TextButton(onClick = onClearAll) {
                    Text("Clear All")
                }
            }

            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                contentPadding = PaddingValues(horizontal = 4.dp)
            ) {
                if (selectedFilter != "All") {
                    item {
                        FilterChip(
                            selected = true,
                            onClick = onFilterRemoved,
                            label = { Text("Type: $selectedFilter") },
                            trailingIcon = {
                                Icon(
                                    Icons.Default.Close,
                                    contentDescription = "Remove",
                                    modifier = Modifier.size(16.dp)
                                )
                            }
                        )
                    }
                }

                if (selectedUser != "All Users") {
                    item {
                        FilterChip(
                            selected = true,
                            onClick = onUserRemoved,
                            label = { Text("User: $selectedUser") },
                            trailingIcon = {
                                Icon(
                                    Icons.Default.Close,
                                    contentDescription = "Remove",
                                    modifier = Modifier.size(16.dp)
                                )
                            }
                        )
                    }
                }

                if (searchText.isNotEmpty()) {
                    item {
                        FilterChip(
                            selected = true,
                            onClick = onSearchRemoved,
                            label = { Text("Search: $searchText") },
                            trailingIcon = {
                                Icon(
                                    Icons.Default.Close,
                                    contentDescription = "Remove",
                                    modifier = Modifier.size(16.dp)
                                )
                            }
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun ActivityCard(
    activity: ActivityLogEntry,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 6.dp),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
        onClick = onClick
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.Top
        ) {
            // Activity icon
            Box(
                modifier = Modifier
                    .size(32.dp)
                    .background(
                        color = getActivityColor(activity.type).copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = getActivityIcon(activity.type),
                    contentDescription = null,
                    tint = getActivityColor(activity.type),
                    modifier = Modifier.size(16.dp)
                )
            }

            Spacer(modifier = Modifier.width(12.dp))

            Column(
                modifier = Modifier.weight(1f)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.Top
                ) {
                    Text(
                        text = activity.action,
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.SemiBold,
                        modifier = Modifier.weight(1f)
                    )

                    SeverityBadge(activity.severity)
                }

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = activity.details,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )

                Spacer(modifier = Modifier.height(8.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.Person,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.size(14.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = activity.user,
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }

                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.AccessTime,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.size(14.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = formatTimestamp(activity.timestamp),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }

                if (activity.metadata.isNotEmpty()) {
                    Spacer(modifier = Modifier.height(8.dp))
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        items(activity.metadata.entries.take(3).toList()) { (key, value) ->
                            MetadataChip(key = key, value = value)
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun SeverityBadge(severity: ActivitySeverity) {
    val (color, icon) = when (severity) {
        ActivitySeverity.Info -> Color(0xFF2196F3) to Icons.Default.Info
        ActivitySeverity.Success -> Color(0xFF4CAF50) to Icons.Default.CheckCircle
        ActivitySeverity.Warning -> Color(0xFFFF9800) to Icons.Default.Warning
        ActivitySeverity.Error -> Color(0xFFF44336) to Icons.Default.Error
    }

    Surface(
        color = color.copy(alpha = 0.1f),
        shape = RoundedCornerShape(6.dp)
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = color,
                modifier = Modifier.size(10.dp)
            )
            Spacer(modifier = Modifier.width(4.dp))
            Text(
                text = severity.name,
                style = MaterialTheme.typography.labelSmall,
                fontWeight = FontWeight.Medium,
                color = color
            )
        }
    }
}

@Composable
private fun MetadataChip(key: String, value: String) {
    Surface(
        color = MaterialTheme.colorScheme.surfaceVariant,
        shape = RoundedCornerShape(4.dp)
    ) {
        Text(
            text = "$key: $value",
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
        )
    }
}

@Composable
private fun EmptyStateSection() {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(300.dp),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.History,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(64.dp)
            )
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "No activities found",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Try adjusting your filters or check back later",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun FiltersDialog(
    selectedFilter: String,
    selectedUser: String,
    filters: List<String>,
    users: List<String>,
    onFilterChanged: (String) -> Unit,
    onUserChanged: (String) -> Unit,
    onDismiss: () -> Unit,
    onReset: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Filter Activities") },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                var filterExpanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = filterExpanded,
                    onExpandedChange = { filterExpanded = it }
                ) {
                    OutlinedTextField(
                        value = selectedFilter,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Activity Type") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = filterExpanded) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor()
                    )

                    ExposedDropdownMenu(
                        expanded = filterExpanded,
                        onDismissRequest = { filterExpanded = false }
                    ) {
                        filters.forEach { filter ->
                            DropdownMenuItem(
                                text = { Text(filter) },
                                onClick = {
                                    onFilterChanged(filter)
                                    filterExpanded = false
                                }
                            )
                        }
                    }
                }

                var userExpanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = userExpanded,
                    onExpandedChange = { userExpanded = it }
                ) {
                    OutlinedTextField(
                        value = selectedUser,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("User") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = userExpanded) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor()
                    )

                    ExposedDropdownMenu(
                        expanded = userExpanded,
                        onDismissRequest = { userExpanded = false }
                    ) {
                        users.forEach { user ->
                            DropdownMenuItem(
                                text = { Text(user) },
                                onClick = {
                                    onUserChanged(user)
                                    userExpanded = false
                                }
                            )
                        }
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("Apply")
            }
        },
        dismissButton = {
            TextButton(onClick = onReset) {
                Text("Reset")
            }
        }
    )
}

@Composable
private fun SearchDialog(
    searchText: String,
    onSearchChanged: (String) -> Unit,
    onDismiss: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Search Activities") },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                OutlinedTextField(
                    value = searchText,
                    onValueChange = onSearchChanged,
                    label = { Text("Search by action, details, or user...") },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                    modifier = Modifier.fillMaxWidth()
                )

                Text("Quick Searches:")

                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(listOf("Failed payments", "New registrations", "Security alerts", "System errors")) { query ->
                        AssistChip(
                            onClick = {
                                onSearchChanged(query)
                                onDismiss()
                            },
                            label = { Text(query) }
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("Search")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}

// Helper functions
private fun getActivityIcon(type: ActivityType): ImageVector {
    return when (type) {
        ActivityType.Purchase -> Icons.Default.ShoppingCart
        ActivityType.Account -> Icons.Default.AccountCircle
        ActivityType.Payment -> Icons.Default.Payment
        ActivityType.Profile -> Icons.Default.Edit
        ActivityType.Security -> Icons.Default.Security
        ActivityType.Review -> Icons.Default.Star
        ActivityType.System -> Icons.Default.Settings
        ActivityType.Support -> Icons.Default.Support
    }
}

private fun getActivityColor(type: ActivityType): Color {
    return when (type) {
        ActivityType.Purchase -> Color(0xFF4CAF50)
        ActivityType.Account -> Color(0xFF2196F3)
        ActivityType.Payment -> Color(0xFFFF9800)
        ActivityType.Profile -> Color(0xFF9C27B0)
        ActivityType.Security -> Color(0xFFF44336)
        ActivityType.Review -> Color(0xFFFFC107)
        ActivityType.System -> Color.Gray
        ActivityType.Support -> Color(0xFF00BCD4)
    }
}

private fun formatTimestamp(timestamp: LocalDateTime): String {
    val now = LocalDateTime.now()
    val minutes = ChronoUnit.MINUTES.between(timestamp, now)
    val hours = ChronoUnit.HOURS.between(timestamp, now)
    val days = ChronoUnit.DAYS.between(timestamp, now)

    return when {
        minutes < 1 -> "Just now"
        minutes < 60 -> "${minutes}m ago"
        hours < 24 -> "${hours}h ago"
        days < 7 -> "${days}d ago"
        else -> timestamp.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
    }
}

private fun getSampleActivities(): List<ActivityLogEntry> {
    return listOf(
        ActivityLogEntry(
            id = "1",
            user = "John Smith",
            action = "Completed purchase",
            details = "Order #12345 - iPhone 14 Pro",
            timestamp = LocalDateTime.now().minusMinutes(5),
            type = ActivityType.Purchase,
            severity = ActivitySeverity.Info,
            metadata = mapOf("amount" to "$999.99", "orderId" to "12345")
        ),
        ActivityLogEntry(
            id = "2",
            user = "Sarah Wilson",
            action = "User registration",
            details = "New account created with email verification",
            timestamp = LocalDateTime.now().minusMinutes(15),
            type = ActivityType.Account,
            severity = ActivitySeverity.Success,
            metadata = mapOf("email" to "sarah.wilson@email.com")
        ),
        ActivityLogEntry(
            id = "3",
            user = "System",
            action = "Failed payment attempt",
            details = "Credit card declined for order #12344",
            timestamp = LocalDateTime.now().minusMinutes(30),
            type = ActivityType.Payment,
            severity = ActivitySeverity.Error,
            metadata = mapOf("orderId" to "12344", "reason" to "Insufficient funds")
        ),
        ActivityLogEntry(
            id = "4",
            user = "Mike Johnson",
            action = "Profile updated",
            details = "Changed shipping address and phone number",
            timestamp = LocalDateTime.now().minusHours(1),
            type = ActivityType.Profile,
            severity = ActivitySeverity.Info,
            metadata = mapOf("fields" to "address, phone")
        ),
        ActivityLogEntry(
            id = "5",
            user = "Admin",
            action = "Security alert",
            details = "Multiple failed login attempts detected",
            timestamp = LocalDateTime.now().minusHours(2),
            type = ActivityType.Security,
            severity = ActivitySeverity.Warning,
            metadata = mapOf("attempts" to "5", "ip" to "192.168.1.100")
        ),
        ActivityLogEntry(
            id = "6",
            user = "Emma Davis",
            action = "Product review",
            details = "Left 5-star review for Wireless Headphones",
            timestamp = LocalDateTime.now().minusHours(3),
            type = ActivityType.Review,
            severity = ActivitySeverity.Success,
            metadata = mapOf("rating" to "5", "productId" to "WH001")
        ),
        ActivityLogEntry(
            id = "7",
            user = "System",
            action = "Data backup completed",
            details = "Automated daily backup finished successfully",
            timestamp = LocalDateTime.now().minusHours(4),
            type = ActivityType.System,
            severity = ActivitySeverity.Success,
            metadata = mapOf("size" to "2.3GB", "duration" to "45min")
        ),
        ActivityLogEntry(
            id = "8",
            user = "Alex Rodriguez",
            action = "Support ticket created",
            details = "Issue with order delivery tracking",
            timestamp = LocalDateTime.now().minusHours(5),
            type = ActivityType.Support,
            severity = ActivitySeverity.Warning,
            metadata = mapOf("ticketId" to "SUP-456", "priority" to "Medium")
        )
    )
}

// Data classes
private data class ActivityLogEntry(
    val id: String,
    val user: String,
    val action: String,
    val details: String,
    val timestamp: LocalDateTime,
    val type: ActivityType,
    val severity: ActivitySeverity,
    val metadata: Map<String, String>
)

private enum class ActivityType {
    Purchase, Account, Payment, Profile, Security, Review, System, Support
}

private enum class ActivitySeverity {
    Info, Success, Warning, Error
}

private data class SummaryCardData(
    val title: String,
    val value: String,
    val icon: ImageVector,
    val color: Color
)