package com.example.compose.search

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
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay

data class LocationResult(
    val id: String,
    val name: String,
    val address: String,
    val latitude: Double,
    val longitude: Double,
    val category: String?,
    val rating: Double?,
    val reviewCount: Int?,
    val phoneNumber: String?,
    val website: String?,
    val hours: List<String>,
    val distance: Double,
    val priceLevel: String?
)

data class MapFilter(
    val category: String = "all",
    val radius: Float = 5f,
    val sortBy: String = "distance"
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MapSearchScreen(
    onNavigateBack: () -> Unit = {}
) {
    var searchText by remember { mutableStateOf("") }
    var searchResults by remember { mutableStateOf<List<LocationResult>>(emptyList()) }
    var selectedLocation by remember { mutableStateOf<LocationResult?>(null) }
    var isLoading by remember { mutableStateOf(false) }
    var showList by remember { mutableStateOf(false) }
    var showFilterSheet by remember { mutableStateOf(false) }
    var mapFilter by remember { mutableStateOf(MapFilter()) }

    val categories = listOf(
        "all", "restaurants", "shopping", "gas_stations", "hospitals",
        "banks", "hotels", "parks", "schools", "entertainment"
    )

    fun performSearch() {
        if (searchText.trim().isEmpty()) return

        isLoading = true
        // Simulate API call
        LaunchedEffect(searchText) {
            delay(800)
            searchResults = generateMockResults(searchText)
            selectedLocation = searchResults.firstOrNull()
            isLoading = false
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        // Map Placeholder
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color(0xFFE3F2FD))
        ) {
            // Mock map grid
            Column(
                modifier = Modifier.fillMaxSize(),
                verticalArrangement = Arrangement.SpaceEvenly
            ) {
                repeat(10) {
                    Divider(color = Color(0xFFBBDEFB).copy(alpha = 0.5f))
                }
            }
            Row(
                modifier = Modifier.fillMaxSize(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                repeat(10) {
                    Divider(
                        color = Color(0xFFBBDEFB).copy(alpha = 0.5f),
                        modifier = Modifier.fillMaxHeight().width(1.dp)
                    )
                }
            }

            // Mock location markers
            searchResults.forEachIndexed { index, result ->
                val isSelected = selectedLocation?.id == result.id
                Box(
                    modifier = Modifier
                        .offset(
                            x = (150 + index * 60).dp,
                            y = (100 + index * 80).dp
                        )
                        .size(32.dp)
                        .background(
                            if (isSelected) Color.Red else Color.Blue,
                            shape = androidx.compose.foundation.shape.CircleShape
                        )
                        .clip(androidx.compose.foundation.shape.CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = getCategoryIcon(result.category ?: ""),
                        contentDescription = null,
                        tint = Color.White,
                        modifier = Modifier.size(16.dp)
                    )
                }
            }

            // Current location marker
            Box(
                modifier = Modifier
                    .offset(x = 180.dp, y = 200.dp)
                    .size(24.dp)
                    .background(Color.Blue, shape = androidx.compose.foundation.shape.CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.MyLocation,
                    contentDescription = "Current location",
                    tint = Color.White,
                    modifier = Modifier.size(16.dp)
                )
            }
        }

        // Search Header
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Card(
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }

                    OutlinedTextField(
                        value = searchText,
                        onValueChange = { searchText = it },
                        placeholder = { Text("Search for places...") },
                        modifier = Modifier.weight(1f),
                        singleLine = true,
                        trailingIcon = {
                            Row {
                                IconButton(onClick = ::performSearch) {
                                    Icon(Icons.Default.Search, contentDescription = "Search")
                                }
                                IconButton(onClick = { showFilterSheet = true }) {
                                    Icon(Icons.Default.Tune, contentDescription = "Filters")
                                }
                            }
                        }
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Quick Filter Chips
            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(
                    listOf(
                        "All" to "all",
                        "Restaurants" to "restaurants",
                        "Shopping" to "shopping",
                        "Gas" to "gas_stations",
                        "Hotels" to "hotels",
                        "Parks" to "parks"
                    )
                ) { (label, category) ->
                    QuickFilterChip(
                        label = label,
                        isSelected = mapFilter.category == category,
                        onClick = {
                            mapFilter = mapFilter.copy(category = category)
                            if (searchText.isNotEmpty()) performSearch()
                        }
                    )
                }
            }
        }

        // Results Toggle Button
        if (searchResults.isNotEmpty()) {
            FloatingActionButton(
                onClick = { showList = !showList },
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(top = 140.dp, end = 16.dp)
            ) {
                Icon(
                    if (showList) Icons.Default.Map else Icons.Default.List,
                    contentDescription = "Toggle view"
                )
            }
        }

        // Bottom Content
        if (searchResults.isNotEmpty()) {
            Column(
                modifier = Modifier.align(Alignment.BottomCenter)
            ) {
                if (showList) {
                    ResultsList(
                        results = searchResults,
                        onLocationClick = { location ->
                            selectedLocation = location
                            showList = false
                        }
                    )
                } else {
                    ResultsCarousel(
                        results = searchResults,
                        selectedLocation = selectedLocation,
                        onLocationSelected = { selectedLocation = it }
                    )
                }
            }
        }

        // My Location FAB
        FloatingActionButton(
            onClick = {
                // Center on user location
                selectedLocation = null
            },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(16.dp)
        ) {
            Icon(Icons.Default.MyLocation, contentDescription = "My location")
        }

        // Loading Overlay
        if (isLoading) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.3f)),
                contentAlignment = Alignment.Center
            ) {
                CircularProgressIndicator()
            }
        }
    }

    // Filter Bottom Sheet
    if (showFilterSheet) {
        ModalBottomSheet(
            onDismissRequest = { showFilterSheet = false }
        ) {
            FilterBottomSheet(
                filter = mapFilter,
                onFilterChange = { newFilter ->
                    mapFilter = newFilter
                    showFilterSheet = false
                    performSearch()
                }
            )
        }
    }
}

@Composable
private fun QuickFilterChip(
    label: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    FilterChip(
        onClick = onClick,
        label = { Text(label) },
        selected = isSelected,
        colors = FilterChipDefaults.filterChipColors(
            containerColor = MaterialTheme.colorScheme.surface,
            selectedContainerColor = MaterialTheme.colorScheme.primaryContainer
        )
    )
}

@Composable
private fun ResultsCarousel(
    results: List<LocationResult>,
    selectedLocation: LocationResult?,
    onLocationSelected: (LocationResult) -> Unit
) {
    LazyRow(
        contentPadding = PaddingValues(16.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        items(results) { result ->
            LocationCard(
                location = result,
                isSelected = selectedLocation?.id == result.id,
                onClick = { onLocationSelected(result) }
            )
        }
    }
}

@Composable
private fun ResultsList(
    results: List<LocationResult>,
    onLocationClick: (LocationResult) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .height(400.dp),
        shape = RoundedCornerShape(topStart = 20.dp, topEnd = 20.dp)
    ) {
        Column {
            // Handle
            Box(
                modifier = Modifier.fillMaxWidth(),
                contentAlignment = Alignment.Center
            ) {
                Surface(
                    modifier = Modifier
                        .size(width = 40.dp, height = 4.dp)
                        .padding(vertical = 8.dp),
                    shape = RoundedCornerShape(2.dp),
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
                Text(
                    text = "${results.size} results",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )

                TextButton(onClick = { /* Show sort options */ }) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        Icon(Icons.Default.Sort, contentDescription = null, modifier = Modifier.size(16.dp))
                        Text("DISTANCE")
                    }
                }
            }

            // Results List
            LazyColumn(
                contentPadding = PaddingValues(horizontal = 16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(results) { result ->
                    LocationListItem(
                        location = result,
                        onClick = { onLocationClick(result) }
                    )
                }
            }
        }
    }
}

@Composable
private fun LocationCard(
    location: LocationResult,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        modifier = Modifier.width(300.dp),
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected)
                MaterialTheme.colorScheme.primaryContainer
            else
                MaterialTheme.colorScheme.surface
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Icon(
                    imageVector = getCategoryIcon(location.category ?: ""),
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary
                )
                Text(
                    text = location.name,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.weight(1f)
                )
            }

            Text(
                text = location.address,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.outline
            )

            Row(
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                if (location.rating != null) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(2.dp)
                    ) {
                        Icon(
                            Icons.Default.Star,
                            contentDescription = null,
                            tint = Color(0xFFFFB000),
                            modifier = Modifier.size(16.dp)
                        )
                        Text(
                            text = String.format("%.1f", location.rating),
                            style = MaterialTheme.typography.bodySmall
                        )
                        if (location.reviewCount != null) {
                            Text(
                                text = "(${location.reviewCount})",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.outline
                            )
                        }
                    }
                }

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(2.dp)
                ) {
                    Icon(
                        Icons.Default.DirectionsWalk,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp)
                    )
                    Text(
                        text = String.format("%.1f km", location.distance),
                        style = MaterialTheme.typography.bodySmall
                    )
                }

                if (location.priceLevel != null) {
                    Text(
                        text = location.priceLevel,
                        style = MaterialTheme.typography.bodySmall,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF4CAF50)
                    )
                }
            }

            Row(
                horizontalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                ActionButton("Call", Icons.Default.Phone) {
                    // Call location
                }
                ActionButton("Directions", Icons.Default.Directions) {
                    // Get directions
                }
                ActionButton("Share", Icons.Default.Share) {
                    // Share location
                }
            }
        }
    }
}

@Composable
private fun LocationListItem(
    location: LocationResult,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = getCategoryIcon(location.category ?: ""),
                contentDescription = null,
                tint = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(24.dp)
            )

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = location.name,
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = location.address,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.outline
                )

                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    if (location.rating != null) {
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
                                text = String.format("%.1f", location.rating),
                                style = MaterialTheme.typography.bodySmall
                            )
                            Text(
                                text = "(${location.reviewCount ?: 0})",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.outline
                            )
                        }
                    }

                    Text(
                        text = String.format("%.1f km", location.distance),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.outline
                    )
                }
            }

            IconButton(onClick = { /* Show more options */ }) {
                Icon(Icons.Default.MoreVert, contentDescription = "More options")
            }
        }
    }
}

@Composable
private fun ActionButton(
    text: String,
    icon: ImageVector,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        IconButton(onClick = onClick) {
            Icon(
                imageVector = icon,
                contentDescription = text,
                tint = MaterialTheme.colorScheme.primary
            )
        }
        Text(
            text = text,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.primary
        )
    }
}

@Composable
private fun FilterBottomSheet(
    filter: MapFilter,
    onFilterChange: (MapFilter) -> Unit
) {
    Column(
        modifier = Modifier.padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        Text(
            text = "Filter & Sort",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold
        )

        // Search Radius
        Column {
            Text("Search Radius: ${filter.radius.toInt()} km")
            Slider(
                value = filter.radius,
                onValueChange = { onFilterChange(filter.copy(radius = it)) },
                valueRange = 1f..50f,
                steps = 49
            )
        }

        // Category Filter
        var categoryExpanded by remember { mutableStateOf(false) }
        ExposedDropdownMenuBox(
            expanded = categoryExpanded,
            onExpandedChange = { categoryExpanded = it }
        ) {
            OutlinedTextField(
                value = getCategoryDisplayName(filter.category),
                onValueChange = { },
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
                listOf(
                    "all", "restaurants", "shopping", "gas_stations",
                    "hospitals", "banks", "hotels", "parks", "schools", "entertainment"
                ).forEach { category ->
                    DropdownMenuItem(
                        text = { Text(getCategoryDisplayName(category)) },
                        onClick = {
                            onFilterChange(filter.copy(category = category))
                            categoryExpanded = false
                        }
                    )
                }
            }
        }

        // Sort Options
        var sortExpanded by remember { mutableStateOf(false) }
        ExposedDropdownMenuBox(
            expanded = sortExpanded,
            onExpandedChange = { sortExpanded = it }
        ) {
            OutlinedTextField(
                value = when (filter.sortBy) {
                    "distance" -> "Distance"
                    "rating" -> "Rating"
                    "name" -> "Name"
                    "reviews" -> "Most Reviewed"
                    else -> "Distance"
                },
                onValueChange = { },
                readOnly = true,
                label = { Text("Sort by") },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = sortExpanded) },
                modifier = Modifier
                    .fillMaxWidth()
                    .menuAnchor()
            )
            ExposedDropdownMenu(
                expanded = sortExpanded,
                onDismissRequest = { sortExpanded = false }
            ) {
                listOf(
                    "distance" to "Distance",
                    "rating" to "Rating",
                    "name" to "Name",
                    "reviews" to "Most Reviewed"
                ).forEach { (value, label) ->
                    DropdownMenuItem(
                        text = { Text(label) },
                        onClick = {
                            onFilterChange(filter.copy(sortBy = value))
                            sortExpanded = false
                        }
                    )
                }
            }
        }

        Button(
            onClick = { onFilterChange(filter) },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Apply Filters")
        }
    }
}

private fun getCategoryIcon(category: String): ImageVector {
    return when (category) {
        "restaurant", "restaurants" -> Icons.Default.Restaurant
        "shopping" -> Icons.Default.ShoppingBag
        "gas_station", "gas_stations" -> Icons.Default.LocalGasStation
        "hospital", "hospitals" -> Icons.Default.LocalHospital
        "bank", "banks" -> Icons.Default.AccountBalance
        "hotel", "hotels" -> Icons.Default.Hotel
        "park", "parks" -> Icons.Default.Park
        "school", "schools" -> Icons.Default.School
        "entertainment" -> Icons.Default.Movie
        else -> Icons.Default.Place
    }
}

private fun getCategoryDisplayName(category: String): String {
    return when (category) {
        "all" -> "All Categories"
        "gas_stations" -> "Gas Stations"
        else -> category.replaceFirstChar { it.uppercase() }
    }
}

private fun generateMockResults(query: String): List<LocationResult> {
    val mockPlaces = listOf(
        Triple("$query at Union Square", "123 Union Square, San Francisco, CA", "restaurant"),
        Triple("$query Downtown", "456 Market Street, San Francisco, CA", "shopping"),
        Triple("$query Mission District", "789 Mission Street, San Francisco, CA", "restaurant"),
        Triple("$query Financial District", "321 Montgomery Street, San Francisco, CA", "bank"),
        Triple("$query Chinatown", "654 Grant Avenue, San Francisco, CA", "restaurant")
    )

    return mockPlaces.mapIndexed { index, (name, address, category) ->
        LocationResult(
            id = "location_$index",
            name = name,
            address = address,
            latitude = 37.7749 + (index * 0.01),
            longitude = -122.4194 + (index * 0.01),
            category = category,
            rating = 3.0 + (index % 3),
            reviewCount = 50 + (index * 12),
            phoneNumber = "+1 (415) ${(100..999).random()}-${(1000..9999).random()}",
            website = null,
            hours = listOf("Mon-Fri: 9:00 AM - 9:00 PM", "Sat-Sun: 10:00 AM - 8:00 PM"),
            distance = 0.5 + (index * 0.3),
            priceLevel = if (index % 2 == 0) "$$" else "$$$"
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun MapSearchScreenPreview() {
    MaterialTheme {
        MapSearchScreen()
    }
}