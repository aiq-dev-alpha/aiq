package com.example.compose.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.selection.selectable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import java.text.SimpleDateFormat
import java.util.*

data class SearchHistoryItem(
    val id: String,
    val query: String,
    val timestamp: Date,
    val resultCount: Int,
    val category: String?,
    val filters: List<String>
)

enum class TimeFilter(val key: String, val label: String) {
    ALL("all", "All time"),
    TODAY("today", "Today"),
    WEEK("week", "This week"),
    MONTH("month", "This month")
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchHistoryScreen(
    onNavigateBack: () -> Unit = {},
    onPerformSearch: (String) -> Unit = {}
) {
    var searchHistory by remember { mutableStateOf<List<SearchHistoryItem>>(emptyList()) }
    var filteredHistory by remember { mutableStateOf<List<SearchHistoryItem>>(emptyList()) }
    var searchText by remember { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(true) }
    var selectedTimeFilter by remember { mutableStateOf(TimeFilter.ALL) }
    var isSelectionMode by remember { mutableStateOf(false) }
    var selectedItems by remember { mutableStateOf<Set<String>>(emptySet()) }

    val clipboardManager = LocalClipboardManager.current

    // Load search history on first composition
    LaunchedEffect(Unit) {
        delay(500) // Simulate loading
        searchHistory = generateMockHistory()
        filteredHistory = searchHistory
        isLoading = false
    }

    // Filter history when search text or time filter changes
    LaunchedEffect(searchText, selectedTimeFilter) {
        filteredHistory = searchHistory.filter { item ->
            val matchesSearch = searchText.isEmpty() ||
                item.query.contains(searchText, ignoreCase = true)
            val matchesTimeFilter = matchesTimeFilter(item, selectedTimeFilter)
            matchesSearch && matchesTimeFilter
        }
    }

    fun deleteHistoryItem(id: String) {
        searchHistory = searchHistory.filter { it.id != id }
        filteredHistory = filteredHistory.filter { it.id != id }
    }

    fun deleteSelectedItems() {
        searchHistory = searchHistory.filter { !selectedItems.contains(it.id) }
        filteredHistory = filteredHistory.filter { !selectedItems.contains(it.id) }
        selectedItems = emptySet()
        isSelectionMode = false
    }

    fun clearAllHistory() {
        searchHistory = emptyList()
        filteredHistory = emptyList()
    }

    fun toggleItemSelection(id: String) {
        selectedItems = if (selectedItems.contains(id)) {
            selectedItems - id
        } else {
            selectedItems + id
        }
    }

    var showClearDialog by remember { mutableStateOf(false) }

    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Top App Bar
        TopAppBar(
            title = {
                Text(
                    if (isSelectionMode)
                        "${selectedItems.size} selected"
                    else
                        "Search History"
                )
            },
            navigationIcon = {
                IconButton(onClick = {
                    if (isSelectionMode) {
                        isSelectionMode = false
                        selectedItems = emptySet()
                    } else {
                        onNavigateBack()
                    }
                }) {
                    Icon(
                        if (isSelectionMode) Icons.Default.Close else Icons.Default.ArrowBack,
                        contentDescription = if (isSelectionMode) "Cancel selection" else "Back"
                    )
                }
            },
            actions = {
                if (isSelectionMode) {
                    if (selectedItems.isNotEmpty()) {
                        IconButton(onClick = ::deleteSelectedItems) {
                            Icon(Icons.Default.Delete, contentDescription = "Delete selected")
                        }
                    }
                } else {
                    IconButton(onClick = { isSelectionMode = true }) {
                        Icon(Icons.Default.CheckCircle, contentDescription = "Select items")
                    }

                    IconButton(onClick = { showClearDialog = true }) {
                        Icon(Icons.Default.MoreVert, contentDescription = "More options")
                    }
                }
            }
        )

        // Search Bar
        OutlinedTextField(
            value = searchText,
            onValueChange = { searchText = it },
            label = { Text("Search in history...") },
            leadingIcon = {
                Icon(Icons.Default.Search, contentDescription = null)
            },
            trailingIcon = {
                if (searchText.isNotEmpty()) {
                    IconButton(onClick = { searchText = "" }) {
                        Icon(Icons.Default.Clear, contentDescription = "Clear search")
                    }
                }
            },
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        )

        // Time Filter Chips
        LazyRow(
            contentPadding = PaddingValues(horizontal = 16.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(TimeFilter.values()) { filter ->
                FilterChip(
                    onClick = { selectedTimeFilter = filter },
                    label = { Text(filter.label) },
                    selected = selectedTimeFilter == filter
                )
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Content
        Box(modifier = Modifier.weight(1f)) {
            when {
                isLoading -> {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }

                filteredHistory.isEmpty() -> {
                    EmptyHistoryState(
                        hasSearchText = searchText.isNotEmpty(),
                        onClearSearch = { searchText = "" }
                    )
                }

                else -> {
                    HistoryList(
                        history = filteredHistory,
                        isSelectionMode = isSelectionMode,
                        selectedItems = selectedItems,
                        onItemClick = { item ->
                            if (isSelectionMode) {
                                toggleItemSelection(item.id)
                            } else {
                                onPerformSearch(item.query)
                            }
                        },
                        onItemLongClick = {
                            if (!isSelectionMode) {
                                isSelectionMode = true
                                selectedItems = setOf(it.id)
                            }
                        },
                        onToggleSelection = ::toggleItemSelection,
                        onCopyQuery = { query ->
                            clipboardManager.setText(AnnotatedString(query))
                        },
                        onDeleteItem = ::deleteHistoryItem
                    )
                }
            }
        }
    }

    // Clear All Dialog
    if (showClearDialog) {
        AlertDialog(
            onDismissRequest = { showClearDialog = false },
            title = { Text("Clear Search History") },
            text = { Text("Are you sure you want to clear all search history? This action cannot be undone.") },
            confirmButton = {
                TextButton(
                    onClick = {
                        clearAllHistory()
                        showClearDialog = false
                    }
                ) {
                    Text("Clear All")
                }
            },
            dismissButton = {
                TextButton(onClick = { showClearDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }
}

@Composable
private fun EmptyHistoryState(
    hasSearchText: Boolean,
    onClearSearch: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(
            imageVector = Icons.Default.History,
            contentDescription = null,
            modifier = Modifier.size(64.dp),
            tint = MaterialTheme.colorScheme.outline
        )

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = if (hasSearchText) "No matching searches found" else "No search history",
            style = MaterialTheme.typography.titleLarge
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = if (hasSearchText) "Try different keywords" else "Your recent searches will appear here",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.outline
        )

        if (hasSearchText) {
            Spacer(modifier = Modifier.height(24.dp))
            Button(onClick = onClearSearch) {
                Text("Clear Search")
            }
        }
    }
}

@Composable
private fun HistoryList(
    history: List<SearchHistoryItem>,
    isSelectionMode: Boolean,
    selectedItems: Set<String>,
    onItemClick: (SearchHistoryItem) -> Unit,
    onItemLongClick: (SearchHistoryItem) -> Unit,
    onToggleSelection: (String) -> Unit,
    onCopyQuery: (String) -> Unit,
    onDeleteItem: (String) -> Unit
) {
    // Group history by time periods
    val groupedHistory = remember(history) {
        groupHistoryByTime(history)
    }

    LazyColumn(
        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        groupedHistory.forEach { (group, items) ->
            item {
                Text(
                    text = group,
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(vertical = 8.dp)
                )
            }

            items(items) { item ->
                HistoryListItem(
                    item = item,
                    isSelectionMode = isSelectionMode,
                    isSelected = selectedItems.contains(item.id),
                    onClick = { onItemClick(item) },
                    onLongClick = { onItemLongClick(item) },
                    onToggleSelection = { onToggleSelection(item.id) },
                    onCopyQuery = { onCopyQuery(item.query) },
                    onDeleteItem = { onDeleteItem(item.id) }
                )
            }
        }
    }
}

@Composable
private fun HistoryListItem(
    item: SearchHistoryItem,
    isSelectionMode: Boolean,
    isSelected: Boolean,
    onClick: () -> Unit,
    onLongClick: () -> Unit,
    onToggleSelection: () -> Unit,
    onCopyQuery: () -> Unit,
    onDeleteItem: () -> Unit
) {
    var showMenu by remember { mutableStateOf(false) }

    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            if (isSelectionMode) {
                Checkbox(
                    checked = isSelected,
                    onCheckedChange = { onToggleSelection() }
                )
            } else {
                Icon(
                    imageVector = Icons.Default.History,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.size(24.dp)
                )
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = item.query,
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Medium
                )

                Spacer(modifier = Modifier.height(4.dp))

                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = getRelativeTime(item.timestamp),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.outline
                    )

                    if (item.category != null) {
                        AssistChip(
                            onClick = { },
                            label = { Text(item.category) }
                        )
                    }

                    item.filters.forEach { filter ->
                        AssistChip(
                            onClick = { },
                            label = { Text(filter) }
                        )
                    }
                }
            }

            if (!isSelectionMode) {
                Box {
                    IconButton(onClick = { showMenu = true }) {
                        Icon(Icons.Default.MoreVert, contentDescription = "More options")
                    }

                    DropdownMenu(
                        expanded = showMenu,
                        onDismissRequest = { showMenu = false }
                    ) {
                        DropdownMenuItem(
                            text = { Text("Copy") },
                            onClick = {
                                onCopyQuery()
                                showMenu = false
                            },
                            leadingIcon = { Icon(Icons.Default.ContentCopy, contentDescription = null) }
                        )
                        DropdownMenuItem(
                            text = { Text("Delete") },
                            onClick = {
                                onDeleteItem()
                                showMenu = false
                            },
                            leadingIcon = { Icon(Icons.Default.Delete, contentDescription = null) }
                        )
                    }
                }
            }
        }
    }
}

private fun matchesTimeFilter(item: SearchHistoryItem, filter: TimeFilter): Boolean {
    val now = Date()
    val calendar = Calendar.getInstance()

    return when (filter) {
        TimeFilter.ALL -> true
        TimeFilter.TODAY -> {
            calendar.time = now
            calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)
            calendar.set(Calendar.MILLISECOND, 0)
            item.timestamp >= calendar.time
        }
        TimeFilter.WEEK -> {
            calendar.time = now
            calendar.add(Calendar.DAY_OF_YEAR, -7)
            item.timestamp >= calendar.time
        }
        TimeFilter.MONTH -> {
            calendar.time = now
            calendar.add(Calendar.MONTH, -1)
            item.timestamp >= calendar.time
        }
    }
}

private fun groupHistoryByTime(history: List<SearchHistoryItem>): Map<String, List<SearchHistoryItem>> {
    val now = Date()
    val calendar = Calendar.getInstance()

    return history.groupBy { item ->
        calendar.time = now
        when {
            isToday(item.timestamp, calendar) -> "Today"
            isYesterday(item.timestamp, calendar) -> "Yesterday"
            isThisWeek(item.timestamp, calendar) -> "This week"
            isThisMonth(item.timestamp, calendar) -> "This month"
            else -> "Older"
        }
    }
}

private fun isToday(date: Date, calendar: Calendar): Boolean {
    val today = calendar.clone() as Calendar
    today.time = Date()
    calendar.time = date
    return (calendar.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
            calendar.get(Calendar.DAY_OF_YEAR) == today.get(Calendar.DAY_OF_YEAR))
}

private fun isYesterday(date: Date, calendar: Calendar): Boolean {
    val yesterday = calendar.clone() as Calendar
    yesterday.time = Date()
    yesterday.add(Calendar.DAY_OF_YEAR, -1)
    calendar.time = date
    return (calendar.get(Calendar.YEAR) == yesterday.get(Calendar.YEAR) &&
            calendar.get(Calendar.DAY_OF_YEAR) == yesterday.get(Calendar.DAY_OF_YEAR))
}

private fun isThisWeek(date: Date, calendar: Calendar): Boolean {
    val weekAgo = calendar.clone() as Calendar
    weekAgo.time = Date()
    weekAgo.add(Calendar.WEEK_OF_YEAR, -1)
    return date >= weekAgo.time
}

private fun isThisMonth(date: Date, calendar: Calendar): Boolean {
    val monthAgo = calendar.clone() as Calendar
    monthAgo.time = Date()
    monthAgo.add(Calendar.MONTH, -1)
    return date >= monthAgo.time
}

private fun getRelativeTime(date: Date): String {
    val now = Date()
    val diff = now.time - date.time

    return when {
        diff < 60 * 1000 -> "Just now"
        diff < 60 * 60 * 1000 -> "${diff / (60 * 1000)} minutes ago"
        diff < 24 * 60 * 60 * 1000 -> "${diff / (60 * 60 * 1000)} hours ago"
        diff < 7 * 24 * 60 * 60 * 1000 -> "${diff / (24 * 60 * 60 * 1000)} days ago"
        else -> SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(date)
    }
}

private fun generateMockHistory(): List<SearchHistoryItem> {
    val queries = listOf(
        "Kotlin programming",
        "Android development",
        "Jetpack Compose",
        "Material Design",
        "MVVM architecture",
        "Coroutines",
        "Room database",
        "Retrofit",
        "Dagger Hilt",
        "Navigation component",
        "WorkManager",
        "Testing",
        "Performance optimization",
        "Security best practices",
        "Play Store optimization"
    )

    val categories = listOf("Development", "Design", "Architecture", "Testing")

    return queries.mapIndexed { index, query ->
        val daysAgo = index * 2 + (index % 3)
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.DAY_OF_YEAR, -daysAgo)

        SearchHistoryItem(
            id = "search_$index",
            query = query,
            timestamp = calendar.time,
            resultCount = 50 + (index * 15),
            category = categories[index % categories.size],
            filters = when {
                index % 3 == 0 -> listOf("Android", "Popular")
                index % 4 == 0 -> listOf("Recent", "Trending")
                else -> emptyList()
            }
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun SearchHistoryScreenPreview() {
    MaterialTheme {
        SearchHistoryScreen()
    }
}