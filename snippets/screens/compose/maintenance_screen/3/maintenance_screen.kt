package com.aiq.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import java.util.*

@Composable
fun MaintenanceScreen(
    title: String? = null,
    message: String? = null,
    estimatedEnd: Date? = null,
    onRefresh: () -> Unit = {},
    supportEmail: String? = null
) {
    var toolsRotation by remember { mutableStateOf(0f) }

    val toolsRotationAnim by animateFloatAsState(
        targetValue = toolsRotation,
        animationSpec = infiniteRepeatable(
            animation = tween(2000, easing = EaseInOut),
            repeatMode = RepeatMode.Reverse
        )
    )

    LaunchedEffect(Unit) {
        toolsRotation = 15f
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.height(60.dp))

        // Maintenance illustration
        Box(
            modifier = Modifier.size(160.dp),
            contentAlignment = Alignment.Center
        ) {
            Card(
                modifier = Modifier.size(160.dp),
                shape = RoundedCornerShape(80.dp),
                colors = CardDefaults.cardColors(
                    containerColor = Color(0xFFF59E0B).copy(alpha = 0.1f)
                )
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Build,
                        contentDescription = "Maintenance",
                        tint = Color(0xFFF59E0B),
                        modifier = Modifier.size(60.dp)
                    )

                    // Animated tools
                    Icon(
                        imageVector = Icons.Default.Settings,
                        contentDescription = null,
                        tint = Color(0xFFF59E0B).copy(alpha = 0.6f),
                        modifier = Modifier
                            .size(20.dp)
                            .offset(x = 60.dp, y = (-40).dp)
                            .rotate(toolsRotationAnim)
                    )

                    Icon(
                        imageVector = Icons.Default.Handyman,
                        contentDescription = null,
                        tint = Color(0xFFF59E0B).copy(alpha = 0.5f),
                        modifier = Modifier
                            .size(18.dp)
                            .offset(x = (-50).dp, y = 50.dp)
                            .rotate(-toolsRotationAnim * 0.6f)
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(40.dp))

        // Content
        Text(
            text = title ?: "Under Maintenance",
            fontSize = 28.sp,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF1F2937),
            textAlign = TextAlign.Center
        )

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = message ?: "We're currently performing scheduled maintenance to improve your AIQ experience. Thank you for your patience!",
            fontSize = 16.sp,
            color = Color(0xFF6B7280),
            textAlign = TextAlign.Center,
            lineHeight = 24.sp
        )

        estimatedEnd?.let { end ->
            Spacer(modifier = Modifier.height(24.dp))

            Card(
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(
                    containerColor = Color(0xFFFEF3C7)
                ),
                border = CardDefaults.outlinedCardBorder().copy(
                    brush = androidx.compose.ui.graphics.SolidColor(
                        Color(0xFFF59E0B).copy(alpha = 0.3f)
                    )
                )
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Schedule,
                        contentDescription = "Time",
                        tint = Color(0xFFF59E0B),
                        modifier = Modifier.size(20.dp)
                    )

                    Spacer(modifier = Modifier.width(12.dp))

                    Text(
                        text = formatEstimatedTime(end),
                        fontSize = 14.sp,
                        color = Color(0xFF92400E),
                        fontWeight = FontWeight.Medium
                    )
                }
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        // Status updates
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(
                containerColor = Color(0xFFF9FAFB)
            ),
            border = CardDefaults.outlinedCardBorder().copy(
                brush = androidx.compose.ui.graphics.SolidColor(Color(0xFFE5E7EB))
            )
        ) {
            Column(
                modifier = Modifier.padding(20.dp)
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Info,
                        contentDescription = "Info",
                        tint = Color(0xFF6366F1),
                        modifier = Modifier.size(20.dp)
                    )

                    Spacer(modifier = Modifier.width(8.dp))

                    Text(
                        text = "What we're working on:",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFF374151)
                    )
                }

                Spacer(modifier = Modifier.height(12.dp))

                val updates = listOf(
                    "Improving quiz loading performance",
                    "Adding new AI challenges",
                    "Enhancing user experience",
                    "Server optimization"
                )

                updates.forEach { update ->
                    Row(
                        modifier = Modifier.padding(vertical = 2.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "•",
                            color = Color(0xFF6B7280),
                            fontSize = 14.sp
                        )

                        Spacer(modifier = Modifier.width(8.dp))

                        Text(
                            text = update,
                            fontSize = 14.sp,
                            color = Color(0xFF6B7280),
                            lineHeight = 20.sp
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        // Action buttons
        Button(
            onClick = onRefresh,
            modifier = Modifier
                .fillMaxWidth()
                .height(48.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = Color(0xFF6366F1)
            ),
            shape = RoundedCornerShape(12.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                modifier = Modifier.size(18.dp)
            )

            Spacer(modifier = Modifier.width(8.dp))

            Text(
                text = "Check Status",
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold
            )
        }

        supportEmail?.let {
            Spacer(modifier = Modifier.height(12.dp))

            OutlinedButton(
                onClick = { /* Copy email */ },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
                border = BorderStroke(1.dp, Color(0xFFE5E7EB)),
                shape = RoundedCornerShape(12.dp)
            ) {
                Icon(
                    imageVector = Icons.Default.Email,
                    contentDescription = null,
                    modifier = Modifier.size(18.dp),
                    tint = Color(0xFF6B7280)
                )

                Spacer(modifier = Modifier.width(8.dp))

                Text(
                    text = "Contact Support",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF6B7280)
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = "Follow us on social media for live updates",
            fontSize = 12.sp,
            color = Color(0xFF9CA3AF),
            textAlign = TextAlign.Center
        )
    }
}

private fun formatEstimatedTime(date: Date): String {
    val now = Date()
    val difference = date.time - now.time

    if (difference <= 0) {
        return "Expected to be resolved soon"
    }

    val hours = (difference / (1000 * 60 * 60)).toInt()
    val minutes = ((difference % (1000 * 60 * 60)) / (1000 * 60)).toInt()

    return if (hours > 0) {
        "Expected back in ${hours}h ${minutes}m"
    } else {
        "Expected back in ${minutes}m"
    }
}