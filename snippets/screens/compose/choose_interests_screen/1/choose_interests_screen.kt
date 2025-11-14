package com.aiq.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
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
import androidx.compose.ui.unit.sp
import com.google.accompanist.flowlayout.FlowRow

data class InterestCategory(
    val name: String,
    val interests: List<String>,
    val color: Color,
    val icon: ImageVector
)

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun ChooseInterestsScreen(
    onContinue: () -> Unit = {}
) {
    var selectedInterests by remember { mutableStateOf(setOf<String>()) }
    val minSelections = 3

    val categories = listOf(
        InterestCategory(
            name = "AI & Technology",
            interests = listOf("Machine Learning", "Deep Learning", "Computer Vision", "Natural Language Processing", "Robotics", "Data Science"),
            color = Color(0xFF6366F1),
            icon = Icons.Default.Memory
        ),
        InterestCategory(
            name = "Science & Research",
            interests = listOf("Physics", "Mathematics", "Chemistry", "Biology", "Neuroscience", "Psychology"),
            color = Color(0xFF8B5CF6),
            icon = Icons.Default.Science
        ),
        InterestCategory(
            name = "Programming",
            interests = listOf("Python", "JavaScript", "Flutter/Dart", "Swift", "Java", "React"),
            color = Color(0xFF06B6D4),
            icon = Icons.Default.Code
        ),
        InterestCategory(
            name = "Business & Innovation",
            interests = listOf("Entrepreneurship", "Product Management", "Digital Marketing", "Strategy", "Finance", "Leadership"),
            color = Color(0xFF10B981),
            icon = Icons.Default.Business
        )
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp)
    ) {
        // Header
        Row(verticalAlignment = Alignment.CenterVertically) {
            Card(
                modifier = Modifier.size(48.dp),
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(
                    containerColor = Color(0xFF6366F1).copy(alpha = 0.1f)
                )
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Favorite,
                        contentDescription = "Interests",
                        tint = Color(0xFF6366F1),
                        modifier = Modifier.size(24.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column {
                Text(
                    text = "Choose Your Interests",
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF1F2937)
                )
                Text(
                    text = "Help us personalize your experience",
                    fontSize = 14.sp,
                    color = Color(0xFF6B7280)
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Info banner
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(
                containerColor = Color(0xFFF3F4F6)
            )
        ) {
            Row(
                modifier = Modifier.padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Info,
                    contentDescription = "Info",
                    tint = Color(0xFF6B7280),
                    modifier = Modifier.size(16.dp)
                )

                Spacer(modifier = Modifier.width(8.dp))

                Text(
                    text = "Select at least $minSelections interests (${selectedInterests.size} selected)",
                    fontSize = 12.sp,
                    color = Color(0xFF6B7280)
                )
            }
        }

        // Categories
        LazyColumn(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(24.dp),
            contentPadding = PaddingValues(vertical = 24.dp)
        ) {
            items(categories) { category ->
                CategorySection(
                    category = category,
                    selectedInterests = selectedInterests,
                    onInterestToggle = { interest ->
                        selectedInterests = if (selectedInterests.contains(interest)) {
                            selectedInterests - interest
                        } else {
                            selectedInterests + interest
                        }
                    }
                )
            }
        }

        // Continue button
        Button(
            onClick = onContinue,
            modifier = Modifier
                .fillMaxWidth()
                .height(56.dp),
            enabled = selectedInterests.size >= minSelections,
            colors = ButtonDefaults.buttonColors(
                containerColor = Color(0xFF6366F1),
                disabledContainerColor = Color(0xFFE5E7EB)
            ),
            shape = RoundedCornerShape(16.dp)
        ) {
            Text(
                text = "Continue with ${selectedInterests.size} interests",
                fontSize = 16.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.width(8.dp))
            Icon(
                imageVector = Icons.Default.ArrowForward,
                contentDescription = null,
                modifier = Modifier.size(20.dp)
            )
        }
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun CategorySection(
    category: InterestCategory,
    selectedInterests: Set<String>,
    onInterestToggle: (String) -> Unit
) {
    Column {
        // Category header
        Row(
            verticalAlignment = Alignment.CenterVertically
        ) {
            Card(
                modifier = Modifier.size(32.dp),
                shape = RoundedCornerShape(8.dp),
                colors = CardDefaults.cardColors(
                    containerColor = category.color.copy(alpha = 0.1f)
                )
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = category.icon,
                        contentDescription = category.name,
                        tint = category.color,
                        modifier = Modifier.size(18.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.width(12.dp))

            Text(
                text = category.name,
                fontSize = 18.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color(0xFF1F2937)
            )
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Interest chips
        FlowRow(
            mainAxisSpacing = 8.dp,
            crossAxisSpacing = 8.dp
        ) {
            category.interests.forEach { interest ->
                InterestChip(
                    text = interest,
                    isSelected = selectedInterests.contains(interest),
                    color = category.color,
                    onToggle = { onInterestToggle(interest) }
                )
            }
        }
    }
}