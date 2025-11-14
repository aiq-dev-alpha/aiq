package com.example.compose.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import java.util.*

data class AdvancedSearchFilters(
    val keywords: String = "",
    val exactPhrase: String = "",
    val excludeWords: String = "",
    val author: String = "",
    val domain: String = "",
    val fileType: String = "any",
    val timeRange: String = "any",
    val sortBy: String = "relevance",
    val safeSearch: Boolean = true,
    val customDateRange: Pair<Long?, Long?> = Pair(null, null),
    val sizeRange: ClosedFloatingPointRange<Float> = 0f..100f,
    val selectedCategories: Set<String> = emptySet(),
    val selectedLanguages: Set<String> = emptySet()
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdvancedSearchScreen(
    onNavigateBack: () -> Unit = {},
    onPerformSearch: (AdvancedSearchFilters) -> Unit = {}
) {
    var filters by remember { mutableStateOf(AdvancedSearchFilters()) }

    val fileTypes = listOf(
        "any" to "Any",
        "pdf" to "PDF",
        "doc" to "Document",
        "image" to "Image",
        "video" to "Video",
        "audio" to "Audio"
    )

    val timeRanges = listOf(
        "any" to "Any time",
        "hour" to "Past hour",
        "day" to "Past 24 hours",
        "week" to "Past week",
        "month" to "Past month",
        "year" to "Past year",
        "custom" to "Custom range"
    )

    val sortOptions = listOf(
        "relevance" to "Relevance",
        "date" to "Date",
        "popularity" to "Popularity",
        "rating" to "Rating"
    )

    val categories = listOf(
        "Technology", "Science", "Business", "Health",
        "Entertainment", "Sports", "Politics", "Education"
    )

    val languages = listOf(
        "English", "Spanish", "French", "German",
        "Chinese", "Japanese", "Arabic", "Portuguese"
    )

    fun resetFilters() {
        filters = AdvancedSearchFilters()
    }

    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Top App Bar
        TopAppBar(
            title = { Text("Advanced Search") },
            navigationIcon = {
                IconButton(onClick = onNavigateBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                }
            },
            actions = {
                TextButton(onClick = ::resetFilters) {
                    Text("Reset")
                }
            }
        )

        // Scrollable Content
        LazyColumn(
            modifier = Modifier.weight(1f),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            // Keywords Section
            item {
                AdvancedSearchSection(title = "Keywords") {
                    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                        OutlinedTextField(
                            value = filters.keywords,
                            onValueChange = { filters = filters.copy(keywords = it) },
                            label = { Text("All of these words") },
                            placeholder = { Text("Enter keywords separated by spaces") },
                            modifier = Modifier.fillMaxWidth()
                        )

                        OutlinedTextField(
                            value = filters.exactPhrase,
                            onValueChange = { filters = filters.copy(exactPhrase = it) },
                            label = { Text("This exact phrase") },
                            placeholder = { Text("Enter exact phrase") },
                            modifier = Modifier.fillMaxWidth()
                        )

                        OutlinedTextField(
                            value = filters.excludeWords,
                            onValueChange = { filters = filters.copy(excludeWords = it) },
                            label = { Text("None of these words") },
                            placeholder = { Text("Words to exclude") },
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            // Content Filters Section
            item {
                AdvancedSearchSection(title = "Content Filters") {
                    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                        // File Type Dropdown
                        var fileTypeExpanded by remember { mutableStateOf(false) }
                        ExposedDropdownMenuBox(
                            expanded = fileTypeExpanded,
                            onExpandedChange = { fileTypeExpanded = it }
                        ) {
                            OutlinedTextField(
                                value = fileTypes.find { it.first == filters.fileType }?.second ?: "Any",
                                onValueChange = { },
                                readOnly = true,
                                label = { Text("File Type") },
                                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = fileTypeExpanded) },
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .menuAnchor()
                            )
                            ExposedDropdownMenu(
                                expanded = fileTypeExpanded,
                                onDismissRequest = { fileTypeExpanded = false }
                            ) {
                                fileTypes.forEach { (value, label) ->
                                    DropdownMenuItem(
                                        text = { Text(label) },
                                        onClick = {
                                            filters = filters.copy(fileType = value)
                                            fileTypeExpanded = false
                                        }
                                    )
                                }
                            }
                        }

                        OutlinedTextField(
                            value = filters.author,
                            onValueChange = { filters = filters.copy(author = it) },
                            label = { Text("Author") },
                            placeholder = { Text("Content author") },
                            modifier = Modifier.fillMaxWidth()
                        )

                        OutlinedTextField(
                            value = filters.domain,
                            onValueChange = { filters = filters.copy(domain = it) },
                            label = { Text("Site or Domain") },
                            placeholder = { Text("e.g., example.com") },
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            // Categories Section
            item {
                AdvancedSearchSection(title = "Categories") {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        items(categories) { category ->
                            FilterChip(
                                onClick = {
                                    filters = if (filters.selectedCategories.contains(category)) {
                                        filters.copy(selectedCategories = filters.selectedCategories - category)
                                    } else {
                                        filters.copy(selectedCategories = filters.selectedCategories + category)
                                    }
                                },
                                label = { Text(category) },
                                selected = filters.selectedCategories.contains(category)
                            )
                        }
                    }
                }
            }

            // Time Range Section
            item {
                AdvancedSearchSection(title = "Time Range") {
                    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                        var timeRangeExpanded by remember { mutableStateOf(false) }
                        ExposedDropdownMenuBox(
                            expanded = timeRangeExpanded,
                            onExpandedChange = { timeRangeExpanded = it }
                        ) {
                            OutlinedTextField(
                                value = timeRanges.find { it.first == filters.timeRange }?.second ?: "Any time",
                                onValueChange = { },
                                readOnly = true,
                                label = { Text("Time Range") },
                                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = timeRangeExpanded) },
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .menuAnchor()
                            )
                            ExposedDropdownMenu(
                                expanded = timeRangeExpanded,
                                onDismissRequest = { timeRangeExpanded = false }
                            ) {
                                timeRanges.forEach { (value, label) ->
                                    DropdownMenuItem(
                                        text = { Text(label) },
                                        onClick = {
                                            filters = filters.copy(timeRange = value)
                                            timeRangeExpanded = false
                                        }
                                    )
                                }
                            }
                        }

                        // Custom date range (simplified - would need date picker in real implementation)
                        if (filters.timeRange == "custom") {
                            Card {
                                Column(
                                    modifier = Modifier.padding(16.dp),
                                    verticalArrangement = Arrangement.spacedBy(8.dp)
                                ) {
                                    Text(
                                        text = "Select date range",
                                        style = MaterialTheme.typography.bodyMedium
                                    )
                                    // In real implementation, add DatePicker components here
                                    Text(
                                        text = "Custom date picker would go here",
                                        style = MaterialTheme.typography.bodySmall,
                                        color = MaterialTheme.colorScheme.outline
                                    )
                                }
                            }
                        }
                    }
                }
            }

            // File Size Section
            item {
                AdvancedSearchSection(title = "File Size (MB)") {
                    Column {
                        Text(
                            text = "${filters.sizeRange.start.toInt()} MB - ${filters.sizeRange.endInclusive.toInt()} MB",
                            style = MaterialTheme.typography.bodyMedium
                        )
                        RangeSlider(
                            value = filters.sizeRange,
                            onValueChange = { filters = filters.copy(sizeRange = it) },
                            valueRange = 0f..100f,
                            steps = 9
                        )
                    }
                }
            }

            // Languages Section
            item {
                AdvancedSearchSection(title = "Languages") {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        items(languages) { language ->
                            FilterChip(
                                onClick = {
                                    filters = if (filters.selectedLanguages.contains(language)) {
                                        filters.copy(selectedLanguages = filters.selectedLanguages - language)
                                    } else {
                                        filters.copy(selectedLanguages = filters.selectedLanguages + language)
                                    }
                                },
                                label = { Text(language) },
                                selected = filters.selectedLanguages.contains(language)
                            )
                        }
                    }
                }
            }

            // Options Section
            item {
                AdvancedSearchSection(title = "Options") {
                    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                        var sortByExpanded by remember { mutableStateOf(false) }
                        ExposedDropdownMenuBox(
                            expanded = sortByExpanded,
                            onExpandedChange = { sortByExpanded = it }
                        ) {
                            OutlinedTextField(
                                value = sortOptions.find { it.first == filters.sortBy }?.second ?: "Relevance",
                                onValueChange = { },
                                readOnly = true,
                                label = { Text("Sort by") },
                                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = sortByExpanded) },
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .menuAnchor()
                            )
                            ExposedDropdownMenu(
                                expanded = sortByExpanded,
                                onDismissRequest = { sortByExpanded = false }
                            ) {
                                sortOptions.forEach { (value, label) ->
                                    DropdownMenuItem(
                                        text = { Text(label) },
                                        onClick = {
                                            filters = filters.copy(sortBy = value)
                                            sortByExpanded = false
                                        }
                                    )
                                }
                            }
                        }

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Switch(
                                checked = filters.safeSearch,
                                onCheckedChange = { filters = filters.copy(safeSearch = it) }
                            )
                            Spacer(modifier = Modifier.width(16.dp))
                            Column {
                                Text(
                                    text = "Safe Search",
                                    style = MaterialTheme.typography.bodyLarge
                                )
                                Text(
                                    text = "Filter explicit content",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.outline
                                )
                            }
                        }
                    }
                }
            }
        }

        // Bottom Action Button
        Surface(
            shadowElevation = 8.dp
        ) {
            Button(
                onClick = { onPerformSearch(filters) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                Text("Search")
            }
        }
    }
}

@Composable
private fun AdvancedSearchSection(
    title: String,
    content: @Composable ColumnScope.() -> Unit
) {
    Card {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.primary
            )
            content()
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun AdvancedSearchScreenPreview() {
    MaterialTheme {
        AdvancedSearchScreen()
    }
}