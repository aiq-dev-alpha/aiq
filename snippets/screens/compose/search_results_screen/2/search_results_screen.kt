package com.example.compose.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.*
import androidx.compose.foundation.lazy.grid.*
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import kotlinx.coroutines.delay
import java.text.NumberFormat
import java.util.*

data class SearchResult(
    val id: String,
    val title: String,
    val description: String,
    val imageUrl: String?,
    val price: Double?,
    val rating: Double?,
    val reviewCount: Int?,
    val category: String?,
    val tags: List<String>,
    val dateAdded: Date?,
    val author: String?,
    val source: String?
)

data class ActiveFilter(
    val key: String,
    val value: String
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchResultsScreen(
    initialQuery: String = "",
    initialFilters: Map<String, Any> = emptyMap(),
    onNavigateBack: () -> Unit = {}
) {
    var searchText by remember { mutableStateOf(initialQuery) }
    var results by remember { mutableStateOf<List<SearchResult>>(emptyList()) }
    var isLoading by remember { mutableStateOf(false) }
    var isLoadingMore by remember { mutableStateOf(false) }
    var hasMoreResults by remember { mutableStateOf(true) }
    var currentFilters by remember { mutableStateOf(initialFilters) }
    var sortBy by remember { mutableStateOf("relevance") }
    var isGridView by remember { mutableStateOf(false) }
    var showFilterSheet by remember { mutableStateOf(false) }
    var showSortSheet by remember { mutableStateOf(false) }

    var totalResults by remember { mutableStateOf(0) }
    var currentPage by remember { mutableStateOf(1) }
    val pageSize = 20

    val context = LocalContext.current

    fun performSearch(isNewSearch: Boolean = true) {
        if (isNewSearch) {
            results = emptyList()
            currentPage = 1
            isLoading = true
            hasMoreResults = true
        } else {
            isLoadingMore = true
            currentPage++
        }

        // Simulate API call
        LaunchedEffect(searchText + sortBy + currentFilters.toString() + currentPage) {
            delay(800)
            val newResults = generateMockResults(searchText, currentPage, pageSize)
            if (isNewSearch) {
                results = newResults
                totalResults = 157 // Mock total
            } else {
                results = results + newResults
            }
            isLoading = false
            isLoadingMore = false
            hasMoreResults = results.size < totalResults
        }
    }

    // Perform initial search
    LaunchedEffect(Unit) {
        if (searchText.isNotEmpty()) {
            performSearch()
        }
    }

    val activeFilters = remember(currentFilters) {
        currentFilters.entries.mapNotNull { (key, value) ->
            when (value) {
                is String -> if (value.isNotEmpty()) listOf(ActiveFilter(key, value)) else emptyList()
                is List<*> -> value.filterIsInstance<String>().map { ActiveFilter(key, it) }
                else -> emptyList()
            }
        }.flatten()
    }

    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Search Bar
        TopAppBar(
            title = {
                OutlinedTextField(
                    value = searchText,
                    onValueChange = { searchText = it },
                    placeholder = { Text("Search...") },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(imeAction = ImeAction.Search),
                    keyboardActions = KeyboardActions(onSearch = { performSearch() }),
                    modifier = Modifier.fillMaxWidth()
                )
            },
            navigationIcon = {
                IconButton(onClick = onNavigateBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                }
            },
            actions = {
                IconButton(onClick = { isGridView = !isGridView }) {
                    Icon(
                        if (isGridView) Icons.Default.ViewList else Icons.Default.GridView,
                        contentDescription = "Toggle view"
                    )
                }
                IconButton(onClick = { showFilterSheet = true }) {
                    Icon(Icons.Default.Tune, contentDescription = "Filters")
                }
            }
        )

        // Search Summary and Controls
        Surface(
            color = MaterialTheme.colorScheme.surfaceVariant,
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(
                modifier = Modifier.padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = if (isLoading && results.isEmpty())
                            "Searching..."
                        else
                            "About ${NumberFormat.getNumberInstance().format(totalResults)} results for \"$searchText\"",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )

                    TextButton(onClick = { showSortSheet = true }) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(4.dp)
                        ) {
                            Icon(
                                Icons.Default.Sort,
                                contentDescription = null,
                                modifier = Modifier.size(16.dp)
                            )
                            Text(sortBy.uppercase())
                        }
                    }
                }

                // Active Filters
                if (activeFilters.isNotEmpty()) {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        items(activeFilters) { filter ->
                            FilterChip(
                                onClick = { /* Remove filter */ },
                                label = {
                                    Row(
                                        verticalAlignment = Alignment.CenterVertically,
                                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                                    ) {
                                        Text("${filter.key}: ${filter.value}")
                                        Icon(
                                            Icons.Default.Close,
                                            contentDescription = "Remove filter",
                                            modifier = Modifier.size(16.dp)
                                        )
                                    }
                                },
                                selected = true
                            )
                        }
                    }
                }
            }
        }

        // Results
        Box(modifier = Modifier.weight(1f)) {
            when {
                isLoading && results.isEmpty() -> {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }

                results.isEmpty() -> {
                    EmptyResultsState(
                        onClearFilters = {
                            currentFilters = emptyMap()
                            performSearch()
                        }
                    )
                }

                isGridView -> {
                    ResultsGridView(
                        results = results,
                        searchQuery = searchText,
                        hasMoreResults = hasMoreResults,
                        isLoadingMore = isLoadingMore,
                        onLoadMore = { performSearch(false) }
                    )
                }

                else -> {
                    ResultsListView(
                        results = results,
                        searchQuery = searchText,
                        hasMoreResults = hasMoreResults,
                        isLoadingMore = isLoadingMore,
                        onLoadMore = { performSearch(false) }
                    )
                }
            }
        }
    }

    // Filter Sheet
    if (showFilterSheet) {
        ModalBottomSheet(
            onDismissRequest = { showFilterSheet = false }
        ) {
            FilterScreen(
                initialFilters = FilterState(), // Convert currentFilters to FilterState
                onApplyFilters = { filterState ->
                    // Convert FilterState to Map and update currentFilters
                    showFilterSheet = false
                    performSearch()
                },
                onDismiss = { showFilterSheet = false }
            )
        }
    }

    // Sort Sheet
    if (showSortSheet) {
        ModalBottomSheet(
            onDismissRequest = { showSortSheet = false }
        ) {
            SortScreen(
                currentSort = SortConfiguration(SortOption.RELEVANCE, true), // Convert sortBy
                onApplySort = { config ->
                    sortBy = config.option.key
                    showSortSheet = false
                    performSearch()
                },
                onNavigateBack = { showSortSheet = false }
            )
        }
    }
}

@Composable
private fun EmptyResultsState(
    onClearFilters: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(
            imageVector = Icons.Default.SearchOff,
            contentDescription = null,
            modifier = Modifier.size(64.dp),
            tint = MaterialTheme.colorScheme.outline
        )

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = "No results found",
            style = MaterialTheme.typography.titleLarge
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "Try adjusting your search or filters",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.outline
        )

        Spacer(modifier = Modifier.height(24.dp))

        Button(onClick = onClearFilters) {
            Text("Clear Filters")
        }
    }
}

@Composable
private fun ResultsListView(
    results: List<SearchResult>,
    searchQuery: String,
    hasMoreResults: Boolean,
    isLoadingMore: Boolean,
    onLoadMore: () -> Unit
) {
    LazyColumn(
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        items(results) { result ->
            ResultListItem(result, searchQuery)
        }

        if (hasMoreResults) {
            item {
                Box(
                    modifier = Modifier.fillMaxWidth(),
                    contentAlignment = Alignment.Center
                ) {
                    if (isLoadingMore) {
                        CircularProgressIndicator()
                    } else {
                        LaunchedEffect(Unit) { onLoadMore() }
                    }
                }
            }
        }
    }
}

@Composable
private fun ResultsGridView(
    results: List<SearchResult>,
    searchQuery: String,
    hasMoreResults: Boolean,
    isLoadingMore: Boolean,
    onLoadMore: () -> Unit
) {
    LazyVerticalGrid(
        columns = GridCells.Fixed(2),
        contentPadding = PaddingValues(16.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        items(results) { result ->
            ResultGridItem(result, searchQuery)
        }

        if (hasMoreResults) {
            item(span = { GridItemSpan(2) }) {
                Box(
                    modifier = Modifier.fillMaxWidth(),
                    contentAlignment = Alignment.Center
                ) {
                    if (isLoadingMore) {
                        CircularProgressIndicator()
                    } else {
                        LaunchedEffect(Unit) { onLoadMore() }
                    }
                }
            }
        }
    }
}

@Composable
private fun ResultListItem(
    result: SearchResult,
    searchQuery: String
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        onClick = { /* Navigate to detail */ }
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Image
            AsyncImage(
                model = result.imageUrl,
                contentDescription = null,
                modifier = Modifier
                    .size(80.dp)
                    .clip(MaterialTheme.shapes.medium),
                contentScale = ContentScale.Crop,
                placeholder = {
                    Box(
                        modifier = Modifier
                            .size(80.dp)
                            .clip(MaterialTheme.shapes.medium),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            Icons.Default.Image,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.outline
                        )
                    }
                }
            )

            Column(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                // Title
                Text(
                    text = highlightText(result.title, searchQuery),
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )

                // Description
                Text(
                    text = result.description,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 3,
                    overflow = TextOverflow.Ellipsis
                )

                // Metadata Row
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    if (result.rating != null) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(4.dp)
                        ) {
                            Icon(
                                Icons.Default.Star,
                                contentDescription = null,
                                tint = Color(0xFFFFB000),
                                modifier = Modifier.size(16.dp)
                            )
                            Text(
                                text = String.format("%.1f", result.rating),
                                style = MaterialTheme.typography.bodySmall
                            )
                        }
                    }

                    if (result.category != null) {
                        AssistChip(
                            onClick = { },
                            label = { Text(result.category) }
                        )
                    }

                    Spacer(modifier = Modifier.weight(1f))

                    if (result.price != null) {
                        Text(
                            text = "$${String.format("%.2f", result.price)}",
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.primary
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun ResultGridItem(
    result: SearchResult,
    searchQuery: String
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        onClick = { /* Navigate to detail */ }
    ) {
        Column {
            // Image
            AsyncImage(
                model = result.imageUrl,
                contentDescription = null,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(120.dp),
                contentScale = ContentScale.Crop,
                placeholder = {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(120.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            Icons.Default.Image,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.outline
                        )
                    }
                }
            )

            Column(
                modifier = Modifier.padding(12.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                Text(
                    text = highlightText(result.title, searchQuery),
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.Bold,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    if (result.rating != null) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(2.dp)
                        ) {
                            Icon(
                                Icons.Default.Star,
                                contentDescription = null,
                                tint = Color(0xFFFFB000),
                                modifier = Modifier.size(14.dp)
                            )
                            Text(
                                text = String.format("%.1f", result.rating),
                                style = MaterialTheme.typography.bodySmall
                            )
                        }
                    }

                    if (result.price != null) {
                        Text(
                            text = "$${result.price.toInt()}",
                            style = MaterialTheme.typography.titleSmall,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.primary
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun highlightText(text: String, query: String) = buildAnnotatedString {
    if (query.isEmpty()) {
        append(text)
        return@buildAnnotatedString
    }

    val lowercaseText = text.lowercase()
    val lowercaseQuery = query.lowercase()
    var startIndex = 0

    while (true) {
        val index = lowercaseText.indexOf(lowercaseQuery, startIndex)
        if (index == -1) {
            append(text.substring(startIndex))
            break
        }

        append(text.substring(startIndex, index))
        withStyle(
            style = SpanStyle(
                color = MaterialTheme.colorScheme.primary,
                fontWeight = FontWeight.Bold
            )
        ) {
            append(text.substring(index, index + query.length))
        }
        startIndex = index + query.length
    }
}

private fun generateMockResults(query: String, page: Int, pageSize: Int): List<SearchResult> {
    return (1..pageSize).map { index ->
        val baseIndex = (page - 1) * pageSize + index
        SearchResult(
            id = "result_$baseIndex",
            title = "Search Result $baseIndex - $query",
            description = "This is a detailed description for search result $baseIndex. It contains relevant information about $query and provides useful context for the user.",
            imageUrl = "https://picsum.photos/300/200?random=$baseIndex",
            price = if (baseIndex % 5 == 0) 29.99 + (baseIndex * 2.5) else null,
            rating = 3.0 + (baseIndex % 3),
            reviewCount = 50 + (baseIndex * 12),
            category = listOf("Electronics", "Books", "Clothing", "Home")[baseIndex % 4],
            tags = listOf("Popular", "New", "Featured"),
            dateAdded = Date(System.currentTimeMillis() - (baseIndex * 86400000L)),
            author = "Author ${baseIndex % 10}",
            source = "Source ${baseIndex % 5}"
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun SearchResultsScreenPreview() {
    MaterialTheme {
        SearchResultsScreen(initialQuery = "Kotlin programming")
    }
}