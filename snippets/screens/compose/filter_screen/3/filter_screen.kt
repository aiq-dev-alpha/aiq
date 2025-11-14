package com.example.compose.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import java.text.SimpleDateFormat
import java.util.*

data class FilterState(
    val selectedCategories: Set<String> = emptySet(),
    val selectedTags: Set<String> = emptySet(),
    val selectedFileTypes: Set<String> = emptySet(),
    val priceRange: ClosedFloatingPointRange<Float> = 0f..1000f,
    val ratingRange: ClosedFloatingPointRange<Float> = 0f..5f,
    val selectedSortBy: String = "relevance",
    val inStock: Boolean = false,
    val freeShipping: Boolean = false,
    val onSale: Boolean = false,
    val fromDate: Long? = null,
    val toDate: Long? = null
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FilterScreen(
    initialFilters: FilterState = FilterState(),
    onApplyFilters: (FilterState) -> Unit = {},
    onDismiss: () -> Unit = {}
) {
    var filterState by remember { mutableStateOf(initialFilters) }

    val availableCategories = listOf(
        "Electronics", "Clothing", "Books", "Home & Garden",
        "Sports", "Beauty", "Automotive", "Toys"
    )

    val availableTags = listOf(
        "Popular", "Trending", "New", "Featured",
        "Best Seller", "Limited Edition", "Premium", "Eco-Friendly"
    )

    val availableFileTypes = listOf(
        "PDF", "DOC", "XLS", "PPT", "IMG", "VID", "AUD", "ZIP"
    )

    val sortOptions = listOf(
        "relevance" to "Relevance",
        "price_low" to "Price: Low to High",
        "price_high" to "Price: High to Low",
        "rating" to "Highest Rated",
        "newest" to "Newest",
        "popularity" to "Most Popular"
    )

    fun resetFilters() {
        filterState = FilterState()
    }

    val activeFiltersCount = with(filterState) {
        var count = 0
        count += selectedCategories.size
        count += selectedTags.size
        count += selectedFileTypes.size
        if (priceRange.start > 0f || priceRange.endInclusive < 1000f) count++
        if (ratingRange.start > 0f || ratingRange.endInclusive < 5f) count++
        if (selectedSortBy != "relevance") count++
        if (inStock) count++
        if (freeShipping) count++
        if (onSale) count++
        if (fromDate != null || toDate != null) count++
        count
    }

    // Bottom Sheet Layout
    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Handle
        Box(
            modifier = Modifier.fillMaxWidth(),
            contentAlignment = Alignment.Center
        ) {
            Surface(
                modifier = Modifier
                    .size(width = 40.dp, height = 4.dp)
                    .padding(vertical = 8.dp),
                shape = MaterialTheme.shapes.small,
                color = MaterialTheme.colorScheme.outline
            ) {}
        }

        // Header
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = "Filters",
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold
                )
                if (activeFiltersCount > 0) {
                    Spacer(modifier = Modifier.width(8.dp))
                    Badge {
                        Text(activeFiltersCount.toString())
                    }
                }
            }

            TextButton(onClick = ::resetFilters) {
                Text("Reset")
            }
        }

        // Filter Content
        LazyColumn(
            modifier = Modifier.weight(1f),
            contentPadding = PaddingValues(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            // Categories
            item {
                FilterSection(title = "Categories") {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        items(availableCategories) { category ->
                            FilterChip(
                                onClick = {
                                    filterState = if (filterState.selectedCategories.contains(category)) {
                                        filterState.copy(selectedCategories = filterState.selectedCategories - category)
                                    } else {
                                        filterState.copy(selectedCategories = filterState.selectedCategories + category)
                                    }
                                },
                                label = { Text(category) },
                                selected = filterState.selectedCategories.contains(category)
                            )
                        }
                    }
                }
            }

            // Tags
            item {
                FilterSection(title = "Tags") {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        items(availableTags) { tag ->
                            FilterChip(
                                onClick = {
                                    filterState = if (filterState.selectedTags.contains(tag)) {
                                        filterState.copy(selectedTags = filterState.selectedTags - tag)
                                    } else {
                                        filterState.copy(selectedTags = filterState.selectedTags + tag)
                                    }
                                },
                                label = { Text(tag) },
                                selected = filterState.selectedTags.contains(tag)
                            )
                        }
                    }
                }
            }

            // File Types
            item {
                FilterSection(title = "File Types") {
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        items(availableFileTypes) { type ->
                            FilterChip(
                                onClick = {
                                    filterState = if (filterState.selectedFileTypes.contains(type)) {
                                        filterState.copy(selectedFileTypes = filterState.selectedFileTypes - type)
                                    } else {
                                        filterState.copy(selectedFileTypes = filterState.selectedFileTypes + type)
                                    }
                                },
                                label = { Text(type) },
                                selected = filterState.selectedFileTypes.contains(type)
                            )
                        }
                    }
                }
            }

            // Price Range
            item {
                FilterSection(
                    title = "Price Range ($${filterState.priceRange.start.toInt()} - $${filterState.priceRange.endInclusive.toInt()})"
                ) {
                    RangeSlider(
                        value = filterState.priceRange,
                        onValueChange = { filterState = filterState.copy(priceRange = it) },
                        valueRange = 0f..1000f,
                        steps = 19
                    )
                }
            }

            // Rating Range
            item {
                FilterSection(
                    title = "Minimum Rating (${String.format("%.1f", filterState.ratingRange.start)} stars)"
                ) {
                    Slider(
                        value = filterState.ratingRange.start,
                        onValueChange = {
                            filterState = filterState.copy(ratingRange = it..filterState.ratingRange.endInclusive)
                        },
                        valueRange = 0f..5f,
                        steps = 9
                    )
                }
            }

            // Sort By
            item {
                FilterSection(title = "Sort By") {
                    var expanded by remember { mutableStateOf(false) }
                    ExposedDropdownMenuBox(
                        expanded = expanded,
                        onExpandedChange = { expanded = it }
                    ) {
                        OutlinedTextField(
                            value = sortOptions.find { it.first == filterState.selectedSortBy }?.second ?: "Relevance",
                            onValueChange = { },
                            readOnly = true,
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor()
                        )
                        ExposedDropdownMenu(
                            expanded = expanded,
                            onDismissRequest = { expanded = false }
                        ) {
                            sortOptions.forEach { (value, label) ->
                                DropdownMenuItem(
                                    text = { Text(label) },
                                    onClick = {
                                        filterState = filterState.copy(selectedSortBy = value)
                                        expanded = false
                                    }
                                )
                            }
                        }
                    }
                }
            }

            // Boolean Options
            item {
                FilterSection(title = "Options") {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Switch(
                                checked = filterState.inStock,
                                onCheckedChange = { filterState = filterState.copy(inStock = it) }
                            )
                            Spacer(modifier = Modifier.width(16.dp))
                            Text("In Stock Only")
                        }

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Switch(
                                checked = filterState.freeShipping,
                                onCheckedChange = { filterState = filterState.copy(freeShipping = it) }
                            )
                            Spacer(modifier = Modifier.width(16.dp))
                            Text("Free Shipping")
                        }

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Switch(
                                checked = filterState.onSale,
                                onCheckedChange = { filterState = filterState.copy(onSale = it) }
                            )
                            Spacer(modifier = Modifier.width(16.dp))
                            Text("On Sale")
                        }
                    }
                }
            }

            // Date Range
            item {
                FilterSection(title = "Date Range") {
                    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                        OutlinedTextField(
                            value = filterState.fromDate?.let {
                                SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(Date(it))
                            } ?: "",
                            onValueChange = { },
                            label = { Text("From Date") },
                            readOnly = true,
                            trailingIcon = {
                                IconButton(onClick = { /* Open date picker */ }) {
                                    Icon(Icons.Default.DateRange, contentDescription = "Select date")
                                }
                            },
                            modifier = Modifier.fillMaxWidth()
                        )

                        OutlinedTextField(
                            value = filterState.toDate?.let {
                                SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(Date(it))
                            } ?: "",
                            onValueChange = { },
                            label = { Text("To Date") },
                            readOnly = true,
                            trailingIcon = {
                                IconButton(onClick = { /* Open date picker */ }) {
                                    Icon(Icons.Default.DateRange, contentDescription = "Select date")
                                }
                            },
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            // Bottom spacing for button
            item {
                Spacer(modifier = Modifier.height(80.dp))
            }
        }

        // Apply Button
        Surface(
            shadowElevation = 8.dp
        ) {
            Button(
                onClick = { onApplyFilters(filterState) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                Text(
                    if (activeFiltersCount > 0)
                        "Apply $activeFiltersCount Filters"
                    else
                        "Apply Filters"
                )
            }
        }
    }
}

@Composable
private fun FilterSection(
    title: String,
    content: @Composable ColumnScope.() -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Text(
            text = title,
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold
        )
        content()
    }
}

@Preview(showBackground = true)
@Composable
private fun FilterScreenPreview() {
    MaterialTheme {
        FilterScreen()
    }
}