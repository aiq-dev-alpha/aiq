package com.aiq.screens.compose

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LeaderboardScreen() {
    var selectedPeriod by remember { mutableStateOf("This Month") }
    var selectedTab by remember { mutableStateOf(0) }
    var showingFilters by remember { mutableStateOf(false) }

    val periods = listOf("Today", "This Week", "This Month", "This Quarter", "This Year")
    val tabTitles = listOf("Users", "Teams", "Departments")

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Leaderboard") },
                actions = {
                    IconButton(onClick = { showingFilters = true }) {
                        Icon(Icons.Default.FilterList, contentDescription = "Filters")
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
                FiltersSection(
                    selectedPeriod = selectedPeriod,
                    periods = periods,
                    onPeriodChanged = { selectedPeriod = it },
                    onShowFilters = { showingFilters = true }
                )
            }

            item {
                TopPerformersSection(selectedPeriod)
            }

            item {
                TabSelector(
                    selectedTab = selectedTab,
                    tabTitles = tabTitles,
                    onTabSelected = { selectedTab = it }
                )
            }

            item {
                when (selectedTab) {
                    0 -> UsersLeaderboard()
                    1 -> TeamsLeaderboard()
                    2 -> DepartmentsLeaderboard()
                }
            }
        }
    }

    if (showingFilters) {
        AdvancedFiltersDialog(
            onDismiss = { showingFilters = false }
        )
    }
}

@Composable
private fun FiltersSection(
    selectedPeriod: String,
    periods: List<String>,
    onPeriodChanged: (String) -> Unit,
    onShowFilters: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        var expanded by remember { mutableStateOf(false) }
        ExposedDropdownMenuBox(
            expanded = expanded,
            onExpandedChange = { expanded = it }
        ) {
            OutlinedButton(
                onClick = { expanded = true },
                modifier = Modifier.menuAnchor()
            ) {
                Text(selectedPeriod)
                Spacer(modifier = Modifier.width(4.dp))
                Icon(Icons.Default.ArrowDropDown, contentDescription = null)
            }

            ExposedDropdownMenu(
                expanded = expanded,
                onDismissRequest = { expanded = false }
            ) {
                periods.forEach { period ->
                    DropdownMenuItem(
                        text = { Text(period) },
                        onClick = {
                            onPeriodChanged(period)
                            expanded = false
                        }
                    )
                }
            }
        }

        Button(
            onClick = onShowFilters,
            colors = ButtonDefaults.buttonColors(
                containerColor = MaterialTheme.colorScheme.surfaceVariant
            )
        ) {
            Icon(Icons.Default.Tune, contentDescription = null)
            Spacer(modifier = Modifier.width(4.dp))
            Text("More Filters")
        }
    }
}

@Composable
private fun TopPerformersSection(selectedPeriod: String) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Text(
            text = "Top Performers - $selectedPeriod",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.height(16.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // Second place
            PodiumCard(
                rank = 2,
                name = "Sarah Wilson",
                score = "8,456",
                change = "+12.3%",
                color = Color.Gray,
                isWinner = false,
                modifier = Modifier.weight(1f)
            )

            // First place (winner)
            PodiumCard(
                rank = 1,
                name = "John Smith",
                score = "9,876",
                change = "+18.5%",
                color = Color(0xFFFFD700),
                isWinner = true,
                modifier = Modifier.weight(1f)
            )

            // Third place
            PodiumCard(
                rank = 3,
                name = "Mike Johnson",
                score = "7,234",
                change = "+8.7%",
                color = Color(0xFFCD7F32),
                isWinner = false,
                modifier = Modifier.weight(1f)
            )
        }
    }
}

@Composable
private fun PodiumCard(
    rank: Int,
    name: String,
    score: String,
    change: String,
    color: Color,
    isWinner: Boolean,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .heightIn(min = if (isWinner) 160.dp else 140.dp),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(
            defaultElevation = if (isWinner) 8.dp else 4.dp
        ),
        border = if (isWinner) CardDefaults.outlinedCardBorder() else null
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Box {
                // Avatar
                Box(
                    modifier = Modifier
                        .size(if (isWinner) 60.dp else 50.dp)
                        .clip(CircleShape)
                        .background(Color(0xFF2196F3).copy(alpha = 0.1f)),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = getInitials(name),
                        style = if (isWinner) MaterialTheme.typography.titleMedium else MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF2196F3)
                    )
                }

                // Rank badge
                Box(
                    modifier = Modifier
                        .align(Alignment.TopEnd)
                        .offset(x = 8.dp, y = (-8).dp)
                        .size(24.dp)
                        .clip(CircleShape)
                        .background(color),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = rank.toString(),
                        style = MaterialTheme.typography.labelSmall,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                }

                // Winner crown
                if (isWinner) {
                    Icon(
                        imageVector = Icons.Default.EmojiEvents,
                        contentDescription = null,
                        tint = Color(0xFFFFD700),
                        modifier = Modifier
                            .align(Alignment.TopCenter)
                            .offset(y = (-8).dp)
                            .size(20.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = name,
                style = if (isWinner) MaterialTheme.typography.bodyLarge else MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = score,
                style = if (isWinner) MaterialTheme.typography.titleMedium else MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF2196F3)
            )

            Text(
                text = change,
                style = MaterialTheme.typography.labelSmall,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF4CAF50)
            )
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
private fun UsersLeaderboard() {
    val users = listOf(
        LeaderboardEntry(
            id = "1",
            name = "Emma Davis",
            score = "6,789",
            change = "+15.2%",
            progress = 0.85f,
            color = Color(0xFF9C27B0),
            subtitle = "Senior Sales Manager",
            icon = Icons.Default.Person
        ),
        LeaderboardEntry(
            id = "2",
            name = "Alex Rodriguez",
            score = "6,234",
            change = "+12.8%",
            progress = 0.78f,
            color = Color(0xFFFF9800),
            subtitle = "Account Executive",
            icon = Icons.Default.Person
        ),
        LeaderboardEntry(
            id = "3",
            name = "Lisa Chen",
            score = "5,876",
            change = "+9.4%",
            progress = 0.72f,
            color = Color(0xFF4CAF50),
            subtitle = "Marketing Specialist",
            icon = Icons.Default.Person
        ),
        LeaderboardEntry(
            id = "4",
            name = "David Wilson",
            score = "5,432",
            change = "+7.1%",
            progress = 0.68f,
            color = Color(0xFF2196F3),
            subtitle = "Customer Success Manager",
            icon = Icons.Default.Person
        ),
        LeaderboardEntry(
            id = "5",
            name = "Sophie Brown",
            score = "5,123",
            change = "+5.3%",
            progress = 0.64f,
            color = Color(0xFFF44336),
            subtitle = "Business Development",
            icon = Icons.Default.Person
        )
    )

    LeaderboardList(entries = users, startRank = 4)
}

@Composable
private fun TeamsLeaderboard() {
    val teams = listOf(
        LeaderboardEntry(
            id = "1",
            name = "Alpha Team",
            score = "45,678",
            change = "+22.3%",
            progress = 0.92f,
            color = Color(0xFF2196F3),
            subtitle = "12 members",
            icon = Icons.Default.Group
        ),
        LeaderboardEntry(
            id = "2",
            name = "Beta Squad",
            score = "42,134",
            change = "+18.7%",
            progress = 0.87f,
            color = Color(0xFF4CAF50),
            subtitle = "10 members",
            icon = Icons.Default.Group
        ),
        LeaderboardEntry(
            id = "3",
            name = "Gamma Force",
            score = "39,876",
            change = "+15.2%",
            progress = 0.82f,
            color = Color(0xFFFF9800),
            subtitle = "8 members",
            icon = Icons.Default.Group
        ),
        LeaderboardEntry(
            id = "4",
            name = "Delta Unit",
            score = "37,543",
            change = "+12.1%",
            progress = 0.78f,
            color = Color(0xFF9C27B0),
            subtitle = "15 members",
            icon = Icons.Default.Group
        )
    )

    LeaderboardList(entries = teams, startRank = 4)
}

@Composable
private fun DepartmentsLeaderboard() {
    val departments = listOf(
        LeaderboardEntry(
            id = "1",
            name = "Sales Department",
            score = "156,789",
            change = "+25.4%",
            progress = 0.95f,
            color = Color(0xFF4CAF50),
            subtitle = "45 employees",
            icon = Icons.Default.Business
        ),
        LeaderboardEntry(
            id = "2",
            name = "Marketing Department",
            score = "134,567",
            change = "+19.8%",
            progress = 0.89f,
            color = Color(0xFF2196F3),
            subtitle = "32 employees",
            icon = Icons.Default.Business
        ),
        LeaderboardEntry(
            id = "3",
            name = "Product Development",
            score = "128,432",
            change = "+17.2%",
            progress = 0.86f,
            color = Color(0xFF9C27B0),
            subtitle = "28 employees",
            icon = Icons.Default.Business
        ),
        LeaderboardEntry(
            id = "4",
            name = "Customer Success",
            score = "115,876",
            change = "+14.6%",
            progress = 0.81f,
            color = Color(0xFFFF9800),
            subtitle = "23 employees",
            icon = Icons.Default.Business
        )
    )

    LeaderboardList(entries = departments, startRank = 4)
}

@Composable
private fun LeaderboardList(entries: List<LeaderboardEntry>, startRank: Int) {
    LazyColumn(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        items(entries.size) { index ->
            LeaderboardRow(
                entry = entries[index],
                rank = startRank + index
            )
        }
    }
}

@Composable
private fun LeaderboardRow(entry: LeaderboardEntry, rank: Int) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Rank badge
            Box(
                modifier = Modifier
                    .size(32.dp)
                    .background(
                        color = getRankColor(rank),
                        shape = RoundedCornerShape(8.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = rank.toString(),
                    style = MaterialTheme.typography.bodyMedium,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )
            }

            Spacer(modifier = Modifier.width(16.dp))

            // Avatar/Icon
            if (entry.icon == Icons.Default.Person) {
                Box(
                    modifier = Modifier
                        .size(50.dp)
                        .clip(CircleShape)
                        .background(entry.color.copy(alpha = 0.2f)),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = getInitials(entry.name),
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Bold,
                        color = entry.color
                    )
                }
            } else {
                Box(
                    modifier = Modifier
                        .size(50.dp)
                        .clip(CircleShape)
                        .background(entry.color.copy(alpha = 0.2f)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = entry.icon,
                        contentDescription = null,
                        tint = entry.color
                    )
                }
            }

            Spacer(modifier = Modifier.width(16.dp))

            // Content
            Column(
                modifier = Modifier.weight(1f)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.Top
                ) {
                    Column {
                        Text(
                            text = entry.name,
                            style = MaterialTheme.typography.bodyLarge,
                            fontWeight = FontWeight.Bold
                        )
                        entry.subtitle?.let { subtitle ->
                            Spacer(modifier = Modifier.height(2.dp))
                            Text(
                                text = subtitle,
                                style = MaterialTheme.typography.labelSmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }

                    Column(
                        horizontalAlignment = Alignment.End
                    ) {
                        Text(
                            text = entry.score,
                            style = MaterialTheme.typography.bodyLarge,
                            fontWeight = FontWeight.Bold,
                            color = entry.color
                        )

                        Surface(
                            color = if (entry.change.startsWith("+")) Color(0xFF4CAF50).copy(alpha = 0.1f) else Color(0xFFF44336).copy(alpha = 0.1f),
                            shape = RoundedCornerShape(4.dp)
                        ) {
                            Text(
                                text = entry.change,
                                style = MaterialTheme.typography.labelSmall,
                                fontWeight = FontWeight.Medium,
                                color = if (entry.change.startsWith("+")) Color(0xFF4CAF50) else Color(0xFFF44336),
                                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                            )
                        }
                    }
                }

                Spacer(modifier = Modifier.height(8.dp))

                // Progress bar
                Column {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(
                            text = "Progress",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                        Text(
                            text = "${(entry.progress * 100).toInt()}%",
                            style = MaterialTheme.typography.labelSmall,
                            fontWeight = FontWeight.Medium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    LinearProgressIndicator(
                        progress = entry.progress,
                        modifier = Modifier.fillMaxWidth(),
                        color = Color(0xFF2196F3),
                        trackColor = MaterialTheme.colorScheme.surfaceVariant
                    )
                }
            }
        }
    }
}

@Composable
private fun AdvancedFiltersDialog(onDismiss: () -> Unit) {
    var selectedRegion by remember { mutableStateOf("All Regions") }
    var selectedDepartment by remember { mutableStateOf("All Departments") }
    var showTopPerformersOnly by remember { mutableStateOf(false) }

    val regions = listOf("All Regions", "North America", "Europe", "Asia Pacific")
    val departments = listOf("All Departments", "Sales", "Marketing", "Product", "Support")

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Advanced Filters") },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                var regionExpanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = regionExpanded,
                    onExpandedChange = { regionExpanded = it }
                ) {
                    OutlinedTextField(
                        value = selectedRegion,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Region") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = regionExpanded) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor()
                    )

                    ExposedDropdownMenu(
                        expanded = regionExpanded,
                        onDismissRequest = { regionExpanded = false }
                    ) {
                        regions.forEach { region ->
                            DropdownMenuItem(
                                text = { Text(region) },
                                onClick = {
                                    selectedRegion = region
                                    regionExpanded = false
                                }
                            )
                        }
                    }
                }

                var departmentExpanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = departmentExpanded,
                    onExpandedChange = { departmentExpanded = it }
                ) {
                    OutlinedTextField(
                        value = selectedDepartment,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Department") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = departmentExpanded) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor()
                    )

                    ExposedDropdownMenu(
                        expanded = departmentExpanded,
                        onDismissRequest = { departmentExpanded = false }
                    ) {
                        departments.forEach { department ->
                            DropdownMenuItem(
                                text = { Text(department) },
                                onClick = {
                                    selectedDepartment = department
                                    departmentExpanded = false
                                }
                            )
                        }
                    }
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Show only top performers")
                    Switch(
                        checked = showTopPerformersOnly,
                        onCheckedChange = { showTopPerformersOnly = it }
                    )
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("Apply")
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
private fun getInitials(name: String): String {
    return name.split(" ").take(2).joinToString("") { it.first().toString() }
}

private fun getRankColor(rank: Int): Color {
    return when {
        rank <= 5 -> Color(0xFF2196F3)
        rank <= 10 -> Color(0xFF4CAF50)
        else -> Color.Gray
    }
}

// Data classes
private data class LeaderboardEntry(
    val id: String,
    val name: String,
    val score: String,
    val change: String,
    val progress: Float,
    val color: Color,
    val subtitle: String?,
    val icon: ImageVector
)