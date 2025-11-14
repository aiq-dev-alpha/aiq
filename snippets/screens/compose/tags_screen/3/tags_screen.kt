package com.example.compose.search

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.*
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay

data class Tag(
    val id: String,
    val name: String,
    val color: Color,
    val count: Int,
    val category: String,
    val isPopular: Boolean
)

enum class TagTab(val title: String, val icon: androidx.compose.ui.graphics.vector.ImageVector) {
    BROWSE("Browse", Icons.Default.Explore),
    POPULAR("Popular", Icons.Default.TrendingUp),
    MY_TAGS("My Tags", Icons.Default.Bookmark)
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TagsScreen(
    selectedTags: List<String> = emptyList(),
    onApplyTags: (List<String>) -> Unit = {},
    onNavigateBack: () -> Unit = {}
) {
    var allTags by remember { mutableStateOf<List<Tag>>(emptyList()) }
    var filteredTags by remember { mutableStateOf<List<Tag>>(emptyList()) }
    var selectedTagIds by remember { mutableStateOf(selectedTags.toSet()) }
    var selectedCategory by remember { mutableStateOf("all") }
    var sortBy by remember { mutableStateOf("popularity") }
    var searchText by remember { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(true) }
    var currentTab by remember { mutableStateOf(TagTab.BROWSE) }

    val categories = listOf(
        "all", "technology", "design", "business", "development",
        "marketing", "science", "education", "health", "lifestyle"
    )

    // Load tags on first composition
    LaunchedEffect(Unit) {
        delay(800) // Simulate loading
        allTags = generateMockTags()
        filteredTags = allTags
        isLoading = false
    }

    // Filter and sort tags
    LaunchedEffect(searchText, selectedCategory, sortBy) {
        var filtered = allTags.filter { tag ->
            val matchesSearch = searchText.isEmpty() ||
                tag.name.contains(searchText, ignoreCase = true)
            val matchesCategory = selectedCategory == "all" ||
                tag.category == selectedCategory
            matchesSearch && matchesCategory
        }

        filtered = when (sortBy) {
            "alphabetical" -> filtered.sortedBy { it.name }
            "popularity" -> filtered.sortedByDescending { it.count }
            "recent" -> filtered.sortedByDescending { it.count } // Mock recent sort
            else -> filtered
        }

        filteredTags = filtered
    }

    val myTags = remember(allTags, selectedTagIds) {
        allTags.filter { selectedTagIds.contains(it.id) }
    }

    fun toggleTag(tagId: String) {
        selectedTagIds = if (selectedTagIds.contains(tagId)) {
            selectedTagIds - tagId
        } else {
            selectedTagIds + tagId
        }
    }

    fun applyTags() {
        val selectedTagNames = allTags
            .filter { selectedTagIds.contains(it.id) }
            .map { it.name }
        onApplyTags(selectedTagNames)
    }

    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Top App Bar
        TopAppBar(
            title = { Text("Tags (${selectedTagIds.size} selected)") },
            navigationIcon = {
                IconButton(onClick = onNavigateBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                }
            },
            actions = {
                if (selectedTagIds.isNotEmpty()) {
                    TextButton(onClick = ::applyTags) {
                        Text("Apply")
                    }
                }
            }
        )

        // Search Bar
        OutlinedTextField(
            value = searchText,
            onValueChange = { searchText = it },
            label = { Text("Search tags...") },
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

        // Filters and Sort
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Category Filter
            var categoryExpanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(
                expanded = categoryExpanded,
                onExpandedChange = { categoryExpanded = it },
                modifier = Modifier.weight(1f)
            ) {
                OutlinedTextField(
                    value = getCategoryDisplayName(selectedCategory),
                    onValueChange = { },
                    readOnly = true,
                    label = { Text("Category") },
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = categoryExpanded) },
                    modifier = Modifier.menuAnchor()
                )
                ExposedDropdownMenu(
                    expanded = categoryExpanded,
                    onDismissRequest = { categoryExpanded = false }
                ) {
                    categories.forEach { category ->
                        DropdownMenuItem(
                            text = { Text(getCategoryDisplayName(category)) },
                            onClick = {
                                selectedCategory = category
                                categoryExpanded = false
                            }
                        )
                    }
                }
            }

            // Sort Filter
            var sortExpanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(
                expanded = sortExpanded,
                onExpandedChange = { sortExpanded = it },
                modifier = Modifier.weight(1f)
            ) {
                OutlinedTextField(
                    value = when (sortBy) {
                        "popularity" -> "Most Popular"
                        "alphabetical" -> "A-Z"
                        "recent" -> "Recently Added"
                        else -> "Most Popular"
                    },
                    onValueChange = { },
                    readOnly = true,
                    label = { Text("Sort by") },
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = sortExpanded) },
                    modifier = Modifier.menuAnchor()
                )
                ExposedDropdownMenu(
                    expanded = sortExpanded,
                    onDismissRequest = { sortExpanded = false }
                ) {
                    listOf(
                        "popularity" to "Most Popular",
                        "alphabetical" to "A-Z",
                        "recent" to "Recently Added"
                    ).forEach { (value, label) ->
                        DropdownMenuItem(
                            text = { Text(label) },
                            onClick = {
                                sortBy = value
                                sortExpanded = false
                            }
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Tab Row
        TabRow(
            selectedTabIndex = TagTab.values().indexOf(currentTab)
        ) {
            TagTab.values().forEach { tab ->
                Tab(
                    selected = currentTab == tab,
                    onClick = { currentTab = tab },
                    text = { Text(tab.title) },
                    icon = { Icon(tab.icon, contentDescription = null) }
                )
            }
        }

        // Tab Content
        Box(modifier = Modifier.weight(1f)) {
            when (currentTab) {
                TagTab.BROWSE -> BrowseTabContent(
                    tags = filteredTags,
                    selectedTags = selectedTagIds,
                    isLoading = isLoading,
                    onToggleTag = ::toggleTag
                )
                TagTab.POPULAR -> PopularTabContent(
                    tags = allTags.filter { it.isPopular }.sortedByDescending { it.count },
                    selectedTags = selectedTagIds,
                    onToggleTag = ::toggleTag
                )
                TagTab.MY_TAGS -> MyTagsTabContent(
                    tags = myTags,
                    onToggleTag = ::toggleTag,
                    onBrowseTags = { currentTab = TagTab.BROWSE }
                )
            }
        }

        // Bottom Action Bar
        if (selectedTagIds.isNotEmpty()) {
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
                        onClick = { selectedTagIds = emptySet() },
                        modifier = Modifier.weight(1f)
                    ) {
                        Text("Clear All")
                    }

                    Button(
                        onClick = ::applyTags,
                        modifier = Modifier.weight(2f)
                    ) {
                        Text("Apply ${selectedTagIds.size} Tags")
                    }
                }
            }
        }
    }
}

@Composable
private fun BrowseTabContent(
    tags: List<Tag>,
    selectedTags: Set<String>,
    isLoading: Boolean,
    onToggleTag: (String) -> Unit
) {
    when {
        isLoading -> {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                CircularProgressIndicator()
            }
        }

        tags.isEmpty() -> {
            EmptyTagsState()
        }

        else -> {
            LazyVerticalGrid(
                columns = GridCells.Fixed(2),
                contentPadding = PaddingValues(16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(tags) { tag ->
                    TagCard(
                        tag = tag,
                        isSelected = selectedTags.contains(tag.id),
                        onClick = { onToggleTag(tag.id) }
                    )
                }
            }
        }
    }
}

@Composable
private fun PopularTabContent(
    tags: List<Tag>,
    selectedTags: Set<String>,
    onToggleTag: (String) -> Unit
) {
    LazyColumn(
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        itemsIndexed(tags) { index, tag ->
            TagListItem(
                tag = tag,
                rank = index + 1,
                isSelected = selectedTags.contains(tag.id),
                onClick = { onToggleTag(tag.id) }
            )
        }
    }
}

@Composable
private fun MyTagsTabContent(
    tags: List<Tag>,
    onToggleTag: (String) -> Unit,
    onBrowseTags: () -> Unit
) {
    if (tags.isEmpty()) {
        Column(
            modifier = Modifier.fillMaxSize(),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.Bookmark,
                contentDescription = null,
                modifier = Modifier.size(64.dp),
                tint = MaterialTheme.colorScheme.outline
            )

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "No tags selected",
                style = MaterialTheme.typography.titleLarge
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "Browse tags and add them to your collection",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.outline
            )

            Spacer(modifier = Modifier.height(24.dp))

            Button(onClick = onBrowseTags) {
                Text("Browse Tags")
            }
        }
    } else {
        LazyColumn(
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            items(tags) { tag ->
                SelectedTagChip(
                    tag = tag,
                    onRemove = { onToggleTag(tag.id) }
                )
            }
        }
    }
}

@Composable
private fun EmptyTagsState() {
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
            text = "No tags found",
            style = MaterialTheme.typography.titleLarge
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "Try adjusting your search or filters",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.outline
        )
    }
}

@Composable
private fun TagCard(
    tag: Tag,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected)
                tag.color.copy(alpha = 0.1f)
            else
                MaterialTheme.colorScheme.surface
        ),
        border = if (isSelected) {
            CardDefaults.outlinedCardBorder().copy(brush = null, width = 2.dp)
        } else null
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Box(
                    modifier = Modifier
                        .size(12.dp)
                        .background(tag.color, shape = androidx.compose.foundation.shape.CircleShape)
                )

                Text(
                    text = tag.name,
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Bold,
                    color = if (isSelected) tag.color else MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.weight(1f)
                )

                if (isSelected) {
                    Icon(
                        imageVector = Icons.Default.Check,
                        contentDescription = "Selected",
                        tint = tag.color,
                        modifier = Modifier.size(16.dp)
                    )
                }
            }

            Text(
                text = "${tag.count} items",
                style = MaterialTheme.typography.bodySmall,
                color = if (isSelected)
                    tag.color.copy(alpha = 0.7f)
                else
                    MaterialTheme.colorScheme.outline
            )
        }
    }
}

@Composable
private fun TagListItem(
    tag: Tag,
    rank: Int,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Surface(
                shape = androidx.compose.foundation.shape.CircleShape,
                color = tag.color.copy(alpha = 0.2f),
                modifier = Modifier.size(40.dp)
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Text(
                        text = rank.toString(),
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = tag.color
                    )
                }
            }

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = tag.name,
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Bold,
                    color = if (isSelected) tag.color else MaterialTheme.colorScheme.onSurface
                )
                Text(
                    text = "${tag.count} items • ${tag.category.uppercase()}",
                    style = MaterialTheme.typography.bodySmall,
                    color = if (isSelected)
                        tag.color.copy(alpha = 0.7f)
                    else
                        MaterialTheme.colorScheme.outline
                )
            }

            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                if (tag.isPopular) {
                    Icon(
                        imageVector = Icons.Default.TrendingUp,
                        contentDescription = "Popular",
                        tint = Color(0xFFFF9500),
                        modifier = Modifier.size(20.dp)
                    )
                }

                Checkbox(
                    checked = isSelected,
                    onCheckedChange = { onClick() }
                )
            }
        }
    }
}

@Composable
private fun SelectedTagChip(
    tag: Tag,
    onRemove: () -> Unit
) {
    Surface(
        color = tag.color,
        shape = MaterialTheme.shapes.medium,
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Surface(
                color = Color.White.copy(alpha = 0.3f),
                shape = androidx.compose.foundation.shape.CircleShape,
                modifier = Modifier.size(20.dp)
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Text(
                        text = if (tag.count > 1000) "${tag.count / 1000}k" else tag.count.toString(),
                        style = MaterialTheme.typography.labelSmall,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                }
            }

            Text(
                text = tag.name,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.Medium,
                color = Color.White,
                modifier = Modifier.weight(1f)
            )

            IconButton(onClick = onRemove) {
                Icon(
                    imageVector = Icons.Default.Close,
                    contentDescription = "Remove tag",
                    tint = Color.White,
                    modifier = Modifier.size(16.dp)
                )
            }
        }
    }
}

private fun getCategoryDisplayName(category: String): String {
    return if (category == "all") "All Categories" else category.replaceFirstChar { it.uppercase() }
}

private fun generateMockTags(): List<Tag> {
    val tagData = listOf(
        Triple("Kotlin", "technology", Color(0xFF7F39FB)),
        Triple("Android", "technology", Color(0xFF3DDC84)),
        Triple("Compose", "technology", Color(0xFF4285F4)),
        Triple("React", "technology", Color(0xFF61DAFB)),
        Triple("JavaScript", "technology", Color(0xFFF7DF1E)),
        Triple("Python", "technology", Color(0xFF3776AB)),
        Triple("UI Design", "design", Color(0xFFFF6B6B)),
        Triple("UX Research", "design", Color(0xFFFF6B6B)),
        Triple("Figma", "design", Color(0xFFF24E1E)),
        Triple("Adobe XD", "design", Color(0xFFFF61F6)),
        Triple("Prototyping", "design", Color(0xFFFF6B6B)),
        Triple("Startup", "business", Color(0xFF4ECDC4)),
        Triple("Entrepreneurship", "business", Color(0xFF4ECDC4)),
        Triple("Marketing", "business", Color(0xFF4ECDC4)),
        Triple("SEO", "marketing", Color(0xFF45B7D1)),
        Triple("Content Marketing", "marketing", Color(0xFF45B7D1)),
        Triple("Social Media", "marketing", Color(0xFF45B7D1)),
        Triple("Machine Learning", "science", Color(0xFF96CEB4)),
        Triple("Data Science", "science", Color(0xFF96CEB4)),
        Triple("AI", "science", Color(0xFF96CEB4)),
        Triple("Blockchain", "technology", Color(0xFFFECA57)),
        Triple("Cryptocurrency", "technology", Color(0xFFFECA57)),
        Triple("Web Development", "development", Color(0xFFFF9FF3)),
        Triple("Mobile Development", "development", Color(0xFFFF9FF3)),
        Triple("DevOps", "development", Color(0xFFFF9FF3)),
        Triple("Cloud Computing", "technology", Color(0xFF54A0FF)),
        Triple("AWS", "technology", Color(0xFFFF9500)),
        Triple("Docker", "development", Color(0xFF0db7ed)),
        Triple("Kubernetes", "development", Color(0xFF326ce5)),
        Triple("Photography", "lifestyle", Color(0xFFFD79A8)),
        Triple("Travel", "lifestyle", Color(0xFFFDCB6E))
    )

    return tagData.mapIndexed { index, (name, category, color) ->
        val count = (1000..5000).random()
        Tag(
            id = "tag_$index",
            name = name,
            color = color,
            count = count,
            category = category,
            isPopular = count > 2000
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun TagsScreenPreview() {
    MaterialTheme {
        TagsScreen()
    }
}