package com.example.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FeedbackFormScreen(
    onDismiss: () -> Unit = {}
) {
    var name by remember { mutableStateOf(TextFieldValue()) }
    var email by remember { mutableStateOf(TextFieldValue()) }
    var feedbackType by remember { mutableStateOf(FeedbackType.GENERAL) }
    var satisfactionRating by remember { mutableStateOf(5f) }
    var feedback by remember { mutableStateOf(TextFieldValue()) }
    var improvements by remember { mutableStateOf(TextFieldValue()) }
    var wouldRecommend by remember { mutableStateOf(true) }
    var allowContact by remember { mutableStateOf(false) }
    var isSubmitting by remember { mutableStateOf(false) }
    var showDialog by remember { mutableStateOf(false) }

    val scrollState = rememberScrollState()

    enum class FeedbackType(val displayName: String) {
        GENERAL("General"),
        BUG_REPORT("Bug Report"),
        FEATURE_REQUEST("Feature Request"),
        UI_UX("UI/UX"),
        PERFORMANCE("Performance"),
        SUPPORT("Support")
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Share Feedback") },
                navigationIcon = {
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp)
                .verticalScroll(scrollState),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Contact Information
            Card(
                modifier = Modifier.fillMaxWidth(),
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Text(
                        text = "Contact Information",
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold
                    )

                    OutlinedTextField(
                        value = name,
                        onValueChange = { name = it },
                        label = { Text("Your Name") },
                        leadingIcon = { Icon(Icons.Default.Person, contentDescription = null) },
                        modifier = Modifier.fillMaxWidth()
                    )

                    OutlinedTextField(
                        value = email,
                        onValueChange = { email = it },
                        label = { Text("Email Address") },
                        leadingIcon = { Icon(Icons.Default.Email, contentDescription = null) },
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }

            // Feedback Details
            Card(
                modifier = Modifier.fillMaxWidth(),
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Text(
                        text = "Feedback Details",
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold
                    )

                    // Feedback Type Dropdown
                    var expanded by remember { mutableStateOf(false) }
                    ExposedDropdownMenuBox(
                        expanded = expanded,
                        onExpandedChange = { expanded = !expanded }
                    ) {
                        OutlinedTextField(
                            value = feedbackType.displayName,
                            onValueChange = {},
                            readOnly = true,
                            label = { Text("Feedback Type") },
                            trailingIcon = {
                                ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded)
                            },
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor()
                        )

                        ExposedDropdownMenu(
                            expanded = expanded,
                            onDismissRequest = { expanded = false }
                        ) {
                            FeedbackType.values().forEach { type ->
                                DropdownMenuItem(
                                    text = { Text(type.displayName) },
                                    onClick = {
                                        feedbackType = type
                                        expanded = false
                                    }
                                )
                            }
                        }
                    }

                    // Satisfaction Rating
                    Text(
                        text = "Overall Satisfaction: ${satisfactionRating.toInt()}/10",
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Medium
                    )

                    Slider(
                        value = satisfactionRating,
                        onValueChange = { satisfactionRating = it },
                        valueRange = 1f..10f,
                        steps = 8,
                        modifier = Modifier.fillMaxWidth()
                    )

                    OutlinedTextField(
                        value = feedback,
                        onValueChange = { feedback = it },
                        label = { Text("Your Feedback") },
                        placeholder = { Text("Please share your thoughts and experiences...") },
                        leadingIcon = { Icon(Icons.Default.Feedback, contentDescription = null) },
                        modifier = Modifier.fillMaxWidth(),
                        minLines = 4,
                        maxLines = 6
                    )

                    OutlinedTextField(
                        value = improvements,
                        onValueChange = { improvements = it },
                        label = { Text("Suggestions for Improvement (Optional)") },
                        placeholder = { Text("What could we do better?") },
                        leadingIcon = { Icon(Icons.Default.Lightbulb, contentDescription = null) },
                        modifier = Modifier.fillMaxWidth(),
                        minLines = 3,
                        maxLines = 5
                    )
                }
            }

            // Additional Questions
            Card(
                modifier = Modifier.fillMaxWidth(),
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Text(
                        text = "Additional Questions",
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold
                    )

                    Text(
                        text = "Would you recommend us to others?",
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Medium
                    )

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(16.dp)
                    ) {
                        Row(
                            modifier = Modifier.weight(1f),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            RadioButton(
                                selected = wouldRecommend,
                                onClick = { wouldRecommend = true }
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("Yes")
                        }

                        Row(
                            modifier = Modifier.weight(1f),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            RadioButton(
                                selected = !wouldRecommend,
                                onClick = { wouldRecommend = false }
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("No")
                        }
                    }

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Checkbox(
                            checked = allowContact,
                            onCheckedChange = { allowContact = it }
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text("Allow us to contact you for follow-up")
                            Text(
                                "We may reach out for clarification or updates",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.outline
                            )
                        }
                    }
                }
            }

            // Action Buttons
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                OutlinedButton(
                    onClick = { /* Clear form */ },
                    modifier = Modifier.weight(1f),
                    enabled = !isSubmitting
                ) {
                    Text("Clear Form")
                }

                Button(
                    onClick = {
                        isSubmitting = true
                        // Simulate submission
                    },
                    modifier = Modifier.weight(1f),
                    enabled = !isSubmitting
                ) {
                    if (isSubmitting) {
                        CircularProgressIndicator(modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(8.dp))
                    }
                    Text("Submit Feedback")
                }
            }
        }
    }
}