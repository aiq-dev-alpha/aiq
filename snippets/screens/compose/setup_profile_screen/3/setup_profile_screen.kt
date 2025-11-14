package com.aiq.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SetupProfileScreen(
    onCreateProfile: () -> Unit = {}
) {
    var fullName by remember { mutableStateOf("") }
    var bio by remember { mutableStateOf("") }
    var selectedAvatar by remember { mutableStateOf("👤") }
    var selectedAgeRange by remember { mutableStateOf(0) }
    var selectedOccupation by remember { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(false) }

    val avatars = listOf("👤", "👨", "👩", "🧑", "👴", "👵", "🤵", "👩‍💼")
    val ageRanges = listOf("18-24", "25-34", "35-44", "45-54", "55-64", "65+")
    val occupations = listOf("Student", "Software Developer", "Data Scientist", "Researcher", "Teacher/Professor", "Business Analyst", "Product Manager", "Designer", "Entrepreneur", "Other")

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(24.dp)
    ) {
        Spacer(modifier = Modifier.height(40.dp))

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
                        imageVector = Icons.Default.PersonAdd,
                        contentDescription = "Profile",
                        tint = Color(0xFF6366F1),
                        modifier = Modifier.size(24.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column {
                Text(
                    text = "Create Your Profile",
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF1F2937)
                )
                Text(
                    text = "Tell us about yourself",
                    fontSize = 14.sp,
                    color = Color(0xFF6B7280)
                )
            }
        }

        Spacer(modifier = Modifier.height(32.dp))

        // Avatar selection
        Text(
            text = "Choose Avatar",
            fontSize = 16.sp,
            fontWeight = FontWeight.SemiBold,
            color = Color(0xFF1F2937)
        )

        Spacer(modifier = Modifier.height(12.dp))

        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            items(avatars) { avatar ->
                AvatarButton(
                    avatar = avatar,
                    isSelected = selectedAvatar == avatar,
                    onSelect = { selectedAvatar = avatar }
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        // Name field
        OutlinedTextField(
            value = fullName,
            onValueChange = { fullName = it },
            label = { Text("Full Name") },
            placeholder = { Text("Enter your full name") },
            leadingIcon = {
                Icon(
                    imageVector = Icons.Default.Person,
                    contentDescription = null
                )
            },
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp)
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Age range
        var expandedAgeRange by remember { mutableStateOf(false) }
        ExposedDropdownMenuBox(
            expanded = expandedAgeRange,
            onExpandedChange = { expandedAgeRange = !expandedAgeRange }
        ) {
            OutlinedTextField(
                value = ageRanges[selectedAgeRange],
                onValueChange = {},
                readOnly = true,
                label = { Text("Age Range") },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expandedAgeRange) },
                modifier = Modifier
                    .menuAnchor()
                    .fillMaxWidth(),
                shape = RoundedCornerShape(12.dp)
            )

            ExposedDropdownMenu(
                expanded = expandedAgeRange,
                onDismissRequest = { expandedAgeRange = false }
            ) {
                ageRanges.forEachIndexed { index, range ->
                    DropdownMenuItem(
                        text = { Text(range) },
                        onClick = {
                            selectedAgeRange = index
                            expandedAgeRange = false
                        }
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Occupation
        var expandedOccupation by remember { mutableStateOf(false) }
        ExposedDropdownMenuBox(
            expanded = expandedOccupation,
            onExpandedChange = { expandedOccupation = !expandedOccupation }
        ) {
            OutlinedTextField(
                value = selectedOccupation.ifEmpty { "Select your occupation" },
                onValueChange = {},
                readOnly = true,
                label = { Text("Occupation") },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expandedOccupation) },
                modifier = Modifier
                    .menuAnchor()
                    .fillMaxWidth(),
                shape = RoundedCornerShape(12.dp)
            )

            ExposedDropdownMenu(
                expanded = expandedOccupation,
                onDismissRequest = { expandedOccupation = false }
            ) {
                occupations.forEach { occupation ->
                    DropdownMenuItem(
                        text = { Text(occupation) },
                        onClick = {
                            selectedOccupation = occupation
                            expandedOccupation = false
                        }
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Bio field
        OutlinedTextField(
            value = bio,
            onValueChange = { if (it.length <= 150) bio = it },
            label = { Text("Bio (Optional)") },
            placeholder = { Text("Tell us something about yourself...") },
            modifier = Modifier.fillMaxWidth(),
            minLines = 3,
            maxLines = 3,
            shape = RoundedCornerShape(12.dp),
            supportingText = { Text("${bio.length}/150") }
        )

        Spacer(modifier = Modifier.height(32.dp))

        // Create profile button
        Button(
            onClick = {
                isLoading = true
                // Simulate profile creation
                onCreateProfile()
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(56.dp),
            enabled = fullName.isNotBlank() && !isLoading,
            colors = ButtonDefaults.buttonColors(
                containerColor = Color(0xFF6366F1)
            ),
            shape = RoundedCornerShape(16.dp)
        ) {
            if (isLoading) {
                CircularProgressIndicator(
                    modifier = Modifier.size(24.dp),
                    color = Color.White,
                    strokeWidth = 2.dp
                )
            } else {
                Text(
                    text = "Create Profile",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(modifier = Modifier.width(8.dp))
                Icon(
                    imageVector = Icons.Default.Check,
                    contentDescription = null,
                    modifier = Modifier.size(20.dp)
                )
            }
        }
    }
}

@Composable
fun AvatarButton(
    avatar: String,
    isSelected: Boolean,
    onSelect: () -> Unit
) {
    Card(
        onClick = onSelect,
        modifier = Modifier.size(60.dp),
        shape = CircleShape,
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) Color(0xFF6366F1) else Color(0xFFF3F4F6)
        ),
        border = if (isSelected) CardDefaults.outlinedCardBorder() else null
    ) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = avatar,
                fontSize = 24.sp
            )
        }
    }
}