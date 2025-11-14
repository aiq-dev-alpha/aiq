package com.example.compose.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay

data class QuickFilter(
    val label: String,
    val icon: ImageVector,
    val isSelected: Boolean = false
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchScreen(
    onNavigateToAdvancedSearch: () -> Unit = {},
    onNavigateToResults: (String) -> Unit = {},
    onNavigateBack: () -> Unit = {}
) {
    var searchText by remember { mutableStateOf("") }
    var recentSearches by remember { mutableStateOf(emptyList<String>()) }
    var suggestions by remember { mutableStateOf(emptyList<String>()) }
    var isLoading by remember { mutableStateOf(false) }
    var selectedFilters by remember { mutableStateOf(setOf<String>()) }

    val focusRequester = remember { FocusRequester() }
    val focusManager = LocalFocusManager.current

    // Load recent searches on first composition
    LaunchedEffect(Unit) {
        recentSearches = listOf(
            "Kotlin programming",
            "Android development",
            "Jetpack Compose",
            "Material Design"
        )
        focusRequester.requestFocus()
    }

    // Update suggestions when search text changes
    LaunchedEffect(searchText) {
        if (searchText.isBlank()) {
            suggestions = emptyList()
            isLoading = false
        } else {
            isLoading = true
            delay(300) // Simulate API delay
            suggestions = listOf(
                "$searchText tutorial",
                "$searchText examples",
                "$searchText best practices",
                "$searchText documentation"
            )
            isLoading = false
        }
    }

    val quickFilters = listOf(
        QuickFilter("All", Icons.Default.Search, selectedFilters.contains("all")),
        QuickFilter("Images", Icons.Default.Image, selectedFilters.contains("images")),
        QuickFilter("Videos", Icons.Default.VideoLibrary, selectedFilters.contains("videos")),
        QuickFilter("Documents", Icons.Default.Description, selectedFilters.contains("documents")),
        QuickFilter("Audio", Icons.Default.AudioFile, selectedFilters.contains("audio"))
    )

    fun performSearch(query: String) {
        if (query.trim().isEmpty()) return

        // Add to recent searches
        recentSearches = listOf(query) + recentSearches.filter { it != query }.take(9)

        focusManager.clearFocus()
        onNavigateToResults(query)
    }

    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Top App Bar
        TopAppBar(
            title = { Text("Search") },
            navigationIcon = {
                IconButton(onClick = onNavigateBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                }
            },
            actions = {
                IconButton(onClick = onNavigateToAdvancedSearch) {
                    Icon(Icons.Default.Tune, contentDescription = "Advanced Search")
                }
            }
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        ) {
            // Search Bar
            OutlinedTextField(
                value = searchText,
                onValueChange = { searchText = it },
                modifier = Modifier
                    .fillMaxWidth()
                    .focusRequester(focusRequester),
                label = { Text("Search for anything...") },
                leadingIcon = {
                    Icon(Icons.Default.Search, contentDescription = "Search")
                },
                trailingIcon = {
                    if (searchText.isNotEmpty()) {
                        IconButton(onClick = {
                            searchText = ""
                            suggestions = emptyList()
                        }) {
                            Icon(Icons.Default.Clear, contentDescription = "Clear")
                        }
                    }
                },
                singleLine = true,
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Search),
                keyboardActions = KeyboardActions(onSearch = { performSearch(searchText) })
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Quick Filters
            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(quickFilters) { filter ->
                    FilterChip(
                        onClick = {
                            selectedFilters = if (selectedFilters.contains(filter.label.lowercase())) {
                                selectedFilters - filter.label.lowercase()
                            } else {
                                selectedFilters + filter.label.lowercase()
                            }
                        },
                        label = {
                            Text(
                                text = filter.label,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                        },
                        selected = filter.isSelected,
                        leadingIcon = {
                            Icon(
                                imageVector = filter.icon,
                                contentDescription = null,
                                modifier = Modifier.size(16.dp)
                            )
                        }
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Content Area
            if (searchText.isEmpty()) {
                RecentSearchesContent(
                    recentSearches = recentSearches,
                    onSearchClick = ::performSearch,
                    onSearchTextUpdate = { searchText = it },
                    onClearAll = { recentSearches = emptyList() }
                )
            } else {
                SuggestionsContent(
                    suggestions = suggestions,
                    isLoading = isLoading,
                    onSuggestionClick = ::performSearch,
                    onSuggestionTextUpdate = { searchText = it }
                )
            }
        }
    }
}

@Composable
private fun RecentSearchesContent(
    recentSearches: List<String>,
    onSearchClick: (String) -> Unit,
    onSearchTextUpdate: (String) -> Unit,
    onClearAll: () -> Unit
) {
    if (recentSearches.isEmpty()) {
        // Empty State
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(64.dp))

            Icon(
                imageVector = Icons.Default.Search,
                contentDescription = null,
                modifier = Modifier.size(64.dp),
                tint = MaterialTheme.colorScheme.outline
            )

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "Start typing to search",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.outline
            )
        }
    } else {
        Column {
            // Header
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Recent Searches",
                    style = MaterialTheme.typography.titleMedium
                )
                TextButton(onClick = onClearAll) {
                    Text("Clear All")
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Recent Searches List
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                items(recentSearches) { search ->
                    Card(
                        onClick = { onSearchClick(search) },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(16.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.History,
                                contentDescription = null,
                                tint = MaterialTheme.colorScheme.outline
                            )

                            Spacer(modifier = Modifier.width(16.dp))

                            Text(
                                text = search,
                                modifier = Modifier.weight(1f)
                            )

                            IconButton(onClick = { onSearchTextUpdate(search) }) {
                                Icon(
                                    imageVector = Icons.Default.NorthWest,
                                    contentDescription = "Fill search",
                                    modifier = Modifier.size(20.dp)
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
private fun SuggestionsContent(
    suggestions: List<String>,
    isLoading: Boolean,
    onSuggestionClick: (String) -> Unit,
    onSuggestionTextUpdate: (String) -> Unit
) {
    if (isLoading) {
        Box(
            modifier = Modifier.fillMaxWidth(),
            contentAlignment = Alignment.Center
        ) {
            CircularProgressIndicator()
        }
    } else {
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            items(suggestions) { suggestion ->
                Card(
                    onClick = { onSuggestionClick(suggestion) },
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.Search,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.outline
                        )

                        Spacer(modifier = Modifier.width(16.dp))

                        Text(
                            text = suggestion,
                            modifier = Modifier.weight(1f)
                        )

                        IconButton(onClick = { onSuggestionTextUpdate(suggestion) }) {
                            Icon(
                                imageVector = Icons.Default.NorthWest,
                                contentDescription = "Fill search",
                                modifier = Modifier.size(20.dp)
                            )
                        }
                    }
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun SearchScreenPreview() {
    MaterialTheme {
        SearchScreen()
    }
}