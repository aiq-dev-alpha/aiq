package com.aiq.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay

@Composable
fun LoadingScreen(
    title: String? = null,
    message: String? = null,
    showProgress: Boolean = false,
    progress: Float? = null,
    primaryColor: Color? = null
) {
    var rotationAngle by remember { mutableStateOf(0f) }
    var pulseScale by remember { mutableStateOf(1f) }
    var currentMessageIndex by remember { mutableStateOf(0) }

    val color = primaryColor ?: Color(0xFF6366F1)

    val loadingMessages = listOf(
        "Preparing your experience...",
        "Loading AI challenges...",
        "Setting up your profile...",
        "Almost ready..."
    )

    val rotationAnim by animateFloatAsState(
        targetValue = rotationAngle,
        animationSpec = infiniteRepeatable(
            animation = tween(2000, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        )
    )

    val pulseScaleAnim by animateFloatAsState(
        targetValue = pulseScale,
        animationSpec = infiniteRepeatable(
            animation = tween(1500, easing = EaseInOut),
            repeatMode = RepeatMode.Reverse
        )
    )

    LaunchedEffect(Unit) {
        rotationAngle = 360f
        pulseScale = 1.2f

        // Cycle messages
        if (message == null) {
            while (true) {
                delay(2000)
                currentMessageIndex = (currentMessageIndex + 1) % loadingMessages.size
            }
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(color, color.copy(alpha = 0.8f))
                )
            ),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center,
            modifier = Modifier.padding(32.dp)
        ) {
            // Loading indicator
            Box(
                modifier = Modifier.scale(pulseScaleAnim),
                contentAlignment = Alignment.Center
            ) {
                Card(
                    modifier = Modifier.size(80.dp),
                    shape = CircleShape,
                    colors = CardDefaults.cardColors(
                        containerColor = Color.White.copy(alpha = 0.2f)
                    )
                ) {}

                Card(
                    modifier = Modifier
                        .size(64.dp)
                        .rotate(rotationAnim),
                    shape = CircleShape,
                    colors = CardDefaults.cardColors(containerColor = Color.Transparent),
                    border = CardDefaults.outlinedCardBorder().copy(
                        brush = androidx.compose.ui.graphics.SolidColor(Color.White),
                        width = 3.dp
                    )
                ) {}

                Card(
                    modifier = Modifier.size(48.dp),
                    shape = CircleShape,
                    colors = CardDefaults.cardColors(containerColor = Color.White)
                ) {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Psychology,
                            contentDescription = "Loading",
                            tint = color,
                            modifier = Modifier.size(24.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(40.dp))

            // Title
            Text(
                text = title ?: "Loading",
                fontSize = 28.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Message
            Text(
                text = message ?: loadingMessages[currentMessageIndex],
                fontSize = 16.sp,
                color = Color.White.copy(alpha = 0.7f),
                textAlign = TextAlign.Center,
                lineHeight = 22.sp
            )

            Spacer(modifier = Modifier.height(40.dp))

            // Progress indicator
            if (showProgress) {
                Column(
                    modifier = Modifier.fillMaxWidth()
                ) {
                    if (progress != null) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.End
                        ) {
                            Text(
                                text = "${(progress * 100).toInt()}%",
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Medium,
                                color = Color.White.copy(alpha = 0.7f)
                            )
                        }

                        Spacer(modifier = Modifier.height(8.dp))

                        LinearProgressIndicator(
                            progress = progress,
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(4.dp),
                            color = Color.White,
                            trackColor = Color.White.copy(alpha = 0.3f)
                        )
                    } else {
                        LinearProgressIndicator(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(4.dp),
                            color = Color.White,
                            trackColor = Color.White.copy(alpha = 0.3f)
                        )
                    }
                }
            } else {
                // Dots loading
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    repeat(3) { index ->
                        Box(
                            modifier = Modifier
                                .size(8.dp)
                                .background(
                                    color = Color.White.copy(
                                        alpha = 0.4f + 0.6f * kotlin.math.sin(
                                            (rotationAngle / 360f + index * 0.33f) * 2 * kotlin.math.PI
                                        ).toFloat()
                                    ),
                                    shape = CircleShape
                                )
                        )
                    }
                }
            }
        }
    }
}