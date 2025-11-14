package com.example.compose.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.selection.selectable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

enum class SortOption(
    val key: String,
    val title: String,
    val subtitle: String,
    val icon: ImageVector,
    val hasDirection: Boolean = true
) {
    RELEVANCE("relevance", "Relevance", "Most relevant results first", Icons.Default.Star, false),
    PRICE_LOW("price_low", "Price: Low to High", "Cheapest items first", Icons.Default.KeyboardArrowUp, false),
    PRICE_HIGH("price_high", "Price: High to Low", "Most expensive items first", Icons.Default.KeyboardArrowDown, false),
    RATING("rating", "Rating", "Highest rated items first", Icons.Default.StarRate),
    NEWEST("newest", "Date Added", "Most recently added", Icons.Default.Schedule),
    POPULARITY("popularity", "Popularity", "Most popular items first", Icons.Default.TrendingUp),
    ALPHABETICAL("alphabetical", "Name", "Alphabetical order", Icons.Default.SortByAlpha),
    DISTANCE("distance", "Distance", "Nearest locations first", Icons.Default.LocationOn),
    MOST_VIEWED("most_viewed", "Most Viewed", "Highest view count first", Icons.Default.Visibility),
    MOST_DOWNLOADED("most_downloaded", "Most Downloaded", "Highest download count first", Icons.Default.Download)
}

data class SortConfiguration(
    val option: SortOption,
    val ascending: Boolean
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SortScreen(
    currentSort: SortConfiguration = SortConfiguration(SortOption.RELEVANCE, true),
    onApplySort: (SortConfiguration) -> Unit = {},
    onNavigateBack: () -> Unit = {}
) {
    var selectedSort by remember { mutableStateOf(currentSort) }

    val quickSortOptions = listOf(
        SortOption.RELEVANCE,
        SortOption.PRICE_LOW,
        SortOption.PRICE_HIGH,
        SortOption.RATING
    )

    val dateAndPopularityOptions = listOf(
        SortOption.NEWEST,
        SortOption.POPULARITY,
        SortOption.MOST_VIEWED,
        SortOption.MOST_DOWNLOADED
    )

    val otherOptions = listOf(
        SortOption.ALPHABETICAL,
        SortOption.DISTANCE
    )

    fun getSortTitle(option: SortOption, ascending: Boolean): String {
        if (!option.hasDirection) return option.title

        return when (option) {
            SortOption.RATING -> if (ascending) "Rating: Low to High" else "Rating: High to Low"
            SortOption.NEWEST -> if (ascending) "Date: Oldest First" else "Date: Newest First"
            SortOption.POPULARITY -> if (ascending) "Popularity: Low to High" else "Popularity: High to Low"
            SortOption.ALPHABETICAL -> if (ascending) "Name: A to Z" else "Name: Z to A"
            SortOption.DISTANCE -> if (ascending) "Distance: Near to Far" else "Distance: Far to Near"
            SortOption.MOST_VIEWED -> if (ascending) "Views: Low to High" else "Views: High to Low"
            SortOption.MOST_DOWNLOADED -> if (ascending) "Downloads: Low to High" else "Downloads: High to Low"
            else -> option.title
        }
    }

    fun getSortSubtitle(option: SortOption, ascending: Boolean): String {
        if (!option.hasDirection) return option.subtitle

        return when (option) {
            SortOption.RATING -> if (ascending) "Lowest rated first" else "Highest rated first"
            SortOption.NEWEST -> if (ascending) "Oldest items first" else "Newest items first"
            SortOption.POPULARITY -> if (ascending) "Least popular first" else "Most popular first"
            SortOption.ALPHABETICAL -> if (ascending) "A to Z order" else "Z to A order"
            SortOption.DISTANCE -> if (ascending) "Closest locations first" else "Farthest locations first"
            SortOption.MOST_VIEWED -> if (ascending) "Lowest views first" else "Highest views first"
            SortOption.MOST_DOWNLOADED -> if (ascending) "Lowest downloads first" else "Highest downloads first"
            else -> option.subtitle
        }
    }

    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Top App Bar
        TopAppBar(
            title = { Text("Sort Options") },
            navigationIcon = {
                IconButton(onClick = onNavigateBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                }
            },
            actions = {
                TextButton(onClick = { onApplySort(selectedSort) }) {
                    Text("Apply")
                }
            }
        )

        // Content
        LazyColumn(
            modifier = Modifier.weight(1f),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Current Selection Summary
            if (selectedSort.option != SortOption.RELEVANCE) {
                item {
                    Card(
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.primaryContainer
                        )
                    ) {
                        Column(
                            modifier = Modifier.padding(16.dp),
                            verticalArrangement = Arrangement.spacedBy(4.dp)
                        ) {
                            Text(
                                text = "Current Sort",
                                style = MaterialTheme.typography.labelMedium,
                                color = MaterialTheme.colorScheme.onPrimaryContainer
                            )
                            Text(
                                text = getSortTitle(selectedSort.option, selectedSort.ascending),
                                style = MaterialTheme.typography.titleMedium,
                                fontWeight = FontWeight.Bold,
                                color = MaterialTheme.colorScheme.onPrimaryContainer
                            )
                            Text(
                                text = getSortSubtitle(selectedSort.option, selectedSort.ascending),
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onPrimaryContainer
                            )
                        }
                    }
                }
            }

            // Quick Sort Options
            item {
                SortSection(title = "Quick Sort") {
                    quickSortOptions.forEach { option ->
                        SortOptionItem(
                            option = option,
                            isSelected = selectedSort.option == option,
                            title = getSortTitle(option, selectedSort.ascending),
                            subtitle = getSortSubtitle(option, selectedSort.ascending),
                            onClick = {
                                selectedSort = SortConfiguration(option, selectedSort.ascending)
                            }
                        )
                    }
                }
            }

            // Date & Popularity
            item {
                Divider()
            }

            item {
                SortSection(title = "Date & Popularity") {
                    dateAndPopularityOptions.forEach { option ->
                        SortOptionItem(
                            option = option,
                            isSelected = selectedSort.option == option,
                            title = getSortTitle(option, selectedSort.ascending),
                            subtitle = getSortSubtitle(option, selectedSort.ascending),
                            onClick = {
                                val defaultAscending = when (option) {
                                    SortOption.NEWEST, SortOption.POPULARITY,
                                    SortOption.MOST_VIEWED, SortOption.MOST_DOWNLOADED -> false
                                    else -> true
                                }
                                selectedSort = SortConfiguration(option, defaultAscending)
                            }
                        )
                    }
                }
            }

            // Other Options
            item {
                Divider()
            }

            item {
                SortSection(title = "Other Options") {
                    otherOptions.forEach { option ->
                        SortOptionItem(
                            option = option,
                            isSelected = selectedSort.option == option,
                            title = getSortTitle(option, selectedSort.ascending),
                            subtitle = getSortSubtitle(option, selectedSort.ascending),
                            onClick = {
                                val defaultAscending = when (option) {
                                    SortOption.ALPHABETICAL, SortOption.DISTANCE -> true
                                    else -> false
                                }
                                selectedSort = SortConfiguration(option, defaultAscending)
                            }
                        )
                    }
                }
            }

            // Sort Direction Control
            if (selectedSort.option.hasDirection) {
                item {
                    Divider()
                }

                item {
                    SortSection(title = "Sort Direction") {
                        Card {
                            Column {
                                SortDirectionItem(
                                    title = "Ascending",
                                    subtitle = getSortSubtitle(selectedSort.option, true),
                                    isSelected = selectedSort.ascending,
                                    onClick = {
                                        selectedSort = selectedSort.copy(ascending = true)
                                    }
                                )

                                Divider(modifier = Modifier.padding(start = 56.dp))

                                SortDirectionItem(
                                    title = "Descending",
                                    subtitle = getSortSubtitle(selectedSort.option, false),
                                    isSelected = !selectedSort.ascending,
                                    onClick = {
                                        selectedSort = selectedSort.copy(ascending = false)
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }

        // Bottom Actions
        Surface(
            shadowElevation = 8.dp
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                OutlinedButton(
                    onClick = {
                        selectedSort = SortConfiguration(SortOption.RELEVANCE, true)
                    },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("Reset")
                }

                Button(
                    onClick = { onApplySort(selectedSort) },
                    modifier = Modifier.weight(2f)
                ) {
                    Text("Apply Sort")
                }
            }
        }
    }
}

@Composable
private fun SortSection(
    title: String,
    content: @Composable ColumnScope.() -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            text = title,
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.primary,
            fontWeight = FontWeight.Bold
        )
        content()
    }
}

@Composable
private fun SortOptionItem(
    option: SortOption,
    isSelected: Boolean,
    title: String,
    subtitle: String,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected)
                MaterialTheme.colorScheme.primaryContainer
            else
                MaterialTheme.colorScheme.surface
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = option.icon,
                contentDescription = null,
                tint = if (isSelected)
                    MaterialTheme.colorScheme.onPrimaryContainer
                else
                    MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(24.dp)
            )

            Spacer(modifier = Modifier.width(16.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Normal,
                    color = if (isSelected)
                        MaterialTheme.colorScheme.onPrimaryContainer
                    else
                        MaterialTheme.colorScheme.onSurface
                )
                Text(
                    text = subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = if (isSelected)
                        MaterialTheme.colorScheme.onPrimaryContainer
                    else
                        MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            if (isSelected) {
                Icon(
                    imageVector = Icons.Default.CheckCircle,
                    contentDescription = "Selected",
                    tint = MaterialTheme.colorScheme.onPrimaryContainer,
                    modifier = Modifier.size(20.dp)
                )
            }
        }
    }
}

@Composable
private fun SortDirectionItem(
    title: String,
    subtitle: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .selectable(
                selected = isSelected,
                onClick = onClick
            )
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        RadioButton(
            selected = isSelected,
            onClick = onClick
        )

        Spacer(modifier = Modifier.width(16.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = title,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Normal
            )
            Text(
                text = subtitle,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun SortScreenPreview() {
    MaterialTheme {
        SortScreen()
    }
}