package com.aiq.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
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
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay

data class PermissionItem(
    val icon: ImageVector,
    val title: String,
    val description: String,
    val isRequired: Boolean,
    var isGranted: Boolean
)

@Composable
fun PermissionsScreen(
    onContinue: () -> Unit = {},
    onSkip: () -> Unit = {}
) {
    var permissions by remember {
        mutableStateOf(
            listOf(
                PermissionItem(
                    icon = Icons.Default.Notifications,
                    title = "Notifications",
                    description = "Get notified about new challenges and your progress",
                    isRequired = false,
                    isGranted = false
                ),
                PermissionItem(
                    icon = Icons.Default.CameraAlt,
                    title = "Camera",
                    description = "Take photos for your profile and share achievements",
                    isRequired = false,
                    isGranted = false
                ),
                PermissionItem(
                    icon = Icons.Default.Mic,
                    title = "Microphone",
                    description = "Use voice commands for hands-free navigation",
                    isRequired = false,
                    isGranted = false
                ),
                PermissionItem(
                    icon = Icons.Default.LocationOn,
                    title = "Location",
                    description = "Find nearby users and location-based challenges",
                    isRequired = false,
                    isGranted = false
                )
            )
        )
    }

    var contentOpacity by remember { mutableStateOf(0f) }
    var contentOffset by remember { mutableStateOf(50.dp) }

    val contentOpacityAnim by animateFloatAsState(
        targetValue = contentOpacity,
        animationSpec = tween(800)
    )

    val contentOffsetAnim by animateDpAsState(
        targetValue = contentOffset,
        animationSpec = tween(800, easing = FastOutSlowInEasing)
    )

    LaunchedEffect(Unit) {
        contentOpacity = 1f
        contentOffset = 0.dp
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .graphicsLayer {
                alpha = contentOpacityAnim
                translationY = contentOffsetAnim.toPx()
            }
            .padding(24.dp)
    ) {
        Spacer(modifier = Modifier.height(20.dp))

        // Header
        Row(
            verticalAlignment = Alignment.CenterVertically
        ) {
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
                        imageVector = Icons.Default.Security,
                        contentDescription = "Security",
                        tint = Color(0xFF6366F1),
                        modifier = Modifier.size(24.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column {
                Text(
                    text = "Permissions",
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

        Spacer(modifier = Modifier.height(32.dp))

        Text(
            text = "We'd like your permission to access the following features to enhance your AIQ experience:",
            fontSize = 16.sp,
            color = Color(0xFF6B7280),
            lineHeight = 24.sp
        )

        Spacer(modifier = Modifier.height(32.dp))

        // Permissions list
        LazyColumn(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            itemsIndexed(permissions) { index, permission ->
                PermissionCard(
                    permission = permission,
                    onToggle = {
                        val newPermissions = permissions.toMutableList()
                        newPermissions[index] = permission.copy(isGranted = !permission.isGranted)
                        permissions = newPermissions
                    }
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        // Action buttons
        Column(
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Button(
                onClick = onContinue,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF6366F1)
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Text(
                    text = "Continue",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }

            TextButton(
                onClick = onSkip,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    text = "Skip for now",
                    fontSize = 16.sp,
                    color = Color(0xFF6B7280),
                    fontWeight = FontWeight.Medium
                )
            }
        }
    }
}

@Composable
fun PermissionCard(
    permission: PermissionItem,
    onToggle: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Icon
            Card(
                modifier = Modifier.size(48.dp),
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(
                    containerColor = if (permission.isGranted)
                        Color(0xFF10B981).copy(alpha = 0.1f)
                    else
                        Color(0xFF6B7280).copy(alpha = 0.1f)
                )
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = permission.icon,
                        contentDescription = permission.title,
                        tint = if (permission.isGranted)
                            Color(0xFF10B981)
                        else
                            Color(0xFF6B7280),
                        modifier = Modifier.size(24.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.width(16.dp))

            // Content
            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = permission.title,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFF1F2937)
                    )

                    if (permission.isRequired) {
                        Spacer(modifier = Modifier.width(8.dp))
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            color = Color(0xFFEF4444)
                        ) {
                            Text(
                                text = "Required",
                                color = Color.White,
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Medium,
                                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                            )
                        }
                    }
                }

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = permission.description,
                    fontSize = 14.sp,
                    color = Color(0xFF6B7280),
                    lineHeight = 18.sp
                )
            }

            Spacer(modifier = Modifier.width(16.dp))

            // Toggle button
            Button(
                onClick = onToggle,
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (permission.isGranted)
                        Color(0xFF10B981)
                    else
                        Color(0xFF6366F1)
                ),
                shape = RoundedCornerShape(8.dp),
                contentPadding = PaddingValues(horizontal = 12.dp, vertical = 8.dp)
            ) {
                Text(
                    text = if (permission.isGranted) "Granted" else "Allow",
                    fontSize = 12.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun PermissionsScreenPreview() {
    PermissionsScreen()
}