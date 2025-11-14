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
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import kotlinx.coroutines.delay

data class TutorialStep(
    val title: String,
    val description: String,
    val targetX: Float,
    val targetY: Float
)

@Composable
fun TutorialScreen(
    onCompleteTutorial: () -> Unit = {}
) {
    var currentStep by remember { mutableStateOf(0) }
    var showOverlay by remember { mutableStateOf(true) }
    var pulseScale by remember { mutableStateOf(1f) }

    val tutorialSteps = listOf(
        TutorialStep(
            title = "Navigation Menu",
            description = "Tap the menu icon to access different sections of the app.",
            targetX = 44f,
            targetY = 100f
        ),
        TutorialStep(
            title = "Start a Quiz",
            description = "Tap here to begin your AI intelligence assessment.",
            targetX = 200f,
            targetY = 400f
        ),
        TutorialStep(
            title = "View Your Progress",
            description = "Check your scores and track improvement over time.",
            targetX = 150f,
            targetY = 600f
        ),
        TutorialStep(
            title = "Settings & Profile",
            description = "Customize your experience and manage your profile.",
            targetX = 350f,
            targetY = 100f
        )
    )

    // Pulse animation
    val pulseScaleAnim by animateFloatAsState(
        targetValue = pulseScale,
        animationSpec = infiniteRepeatable(
            animation = tween(1500, easing = EaseInOut),
            repeatMode = RepeatMode.Reverse
        )
    )

    LaunchedEffect(Unit) {
        // Start pulse animation
        while (true) {
            pulseScale = 1.2f
            delay(750)
            pulseScale = 1f
            delay(750)
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        // Mock app interface
        MockAppInterface()

        // Tutorial overlay
        if (showOverlay) {
            TutorialOverlay(
                currentStep = currentStep,
                totalSteps = tutorialSteps.size,
                step = tutorialSteps[currentStep],
                pulseScale = pulseScaleAnim,
                onNext = {
                    if (currentStep < tutorialSteps.size - 1) {
                        currentStep++
                    } else {
                        showOverlay = false
                        onCompleteTutorial()
                    }
                },
                onPrevious = {
                    if (currentStep > 0) {
                        currentStep--
                    }
                },
                onSkip = {
                    showOverlay = false
                    onCompleteTutorial()
                }
            )
        }
    }
}

@Composable
fun MockAppInterface() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6)
                    )
                )
            )
    ) {
        // App bar
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
                .padding(top = 20.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.Menu,
                contentDescription = "Menu",
                tint = Color.White,
                modifier = Modifier.size(28.dp)
            )

            Text(
                text = "AIQ",
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )

            Icon(
                imageVector = Icons.Default.Person,
                contentDescription = "Profile",
                tint = Color.White,
                modifier = Modifier.size(28.dp)
            )
        }

        // Main content
        Card(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White)
        ) {
            Column(
                modifier = Modifier.fillMaxSize(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                // Play button
                Card(
                    modifier = Modifier.size(120.dp),
                    shape = CircleShape,
                    colors = CardDefaults.cardColors(
                        containerColor = Color(0xFF6366F1)
                    )
                ) {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.PlayArrow,
                            contentDescription = "Play",
                            tint = Color.White,
                            modifier = Modifier.size(60.dp)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))

                Text(
                    text = "Start Your AIQ Test",
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF1F2937),
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(40.dp))

                // Progress card
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 24.dp),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = Color(0xFFF3F4F6)
                    )
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.TrendingUp,
                            contentDescription = "Progress",
                            tint = Color(0xFF6366F1),
                            modifier = Modifier.size(24.dp)
                        )

                        Spacer(modifier = Modifier.width(12.dp))

                        Text(
                            text = "View Progress",
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Medium,
                            color = Color(0xFF1F2937)
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun TutorialOverlay(
    currentStep: Int,
    totalSteps: Int,
    step: TutorialStep,
    pulseScale: Float,
    onNext: () -> Unit,
    onPrevious: () -> Unit,
    onSkip: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black.copy(alpha = 0.8f))
            .zIndex(1f)
    ) {
        // Spotlight effect (simplified)
        Box(
            modifier = Modifier
                .size(80.dp)
                .offset(
                    x = step.targetX.dp - 40.dp,
                    y = step.targetY.dp - 40.dp
                )
                .scale(pulseScale)
                .clip(CircleShape)
                .background(Color.White.copy(alpha = 0.2f))
        )

        // Tutorial content card
        Column(
            modifier = Modifier.align(Alignment.BottomCenter)
        ) {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(24.dp),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(
                    modifier = Modifier.padding(24.dp)
                ) {
                    // Header
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Surface(
                            shape = RoundedCornerShape(12.dp),
                            color = Color(0xFF6366F1)
                        ) {
                            Text(
                                text = "${currentStep + 1}/$totalSteps",
                                color = Color.White,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.SemiBold,
                                modifier = Modifier.padding(
                                    horizontal = 8.dp,
                                    vertical = 4.dp
                                )
                            )
                        }

                        TextButton(onClick = onSkip) {
                            Text(
                                text = "Skip",
                                color = Color(0xFF6B7280),
                                fontWeight = FontWeight.Medium
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // Content
                    Text(
                        text = step.title,
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF1F2937)
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                    Text(
                        text = step.description,
                        fontSize = 16.sp,
                        color = Color(0xFF6B7280),
                        lineHeight = 22.sp
                    )

                    Spacer(modifier = Modifier.height(24.dp))

                    // Navigation buttons
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        if (currentStep > 0) {
                            OutlinedButton(
                                onClick = onPrevious,
                                modifier = Modifier
                                    .weight(1f)
                                    .height(44.dp),
                                border = BorderStroke(1.dp, Color(0xFFE5E7EB)),
                                shape = RoundedCornerShape(12.dp)
                            ) {
                                Text(
                                    text = "Previous",
                                    color = Color(0xFF6B7280),
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }

                        Button(
                            onClick = onNext,
                            modifier = Modifier
                                .weight(1f)
                                .height(44.dp),
                            colors = ButtonDefaults.buttonColors(
                                containerColor = Color(0xFF6366F1)
                            ),
                            shape = RoundedCornerShape(12.dp)
                        ) {
                            Text(
                                text = if (currentStep == totalSteps - 1) "Finish" else "Next",
                                fontWeight = FontWeight.SemiBold
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
fun TutorialScreenPreview() {
    TutorialScreen()
}