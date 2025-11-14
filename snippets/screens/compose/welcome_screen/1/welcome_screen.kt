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
import androidx.compose.ui.draw.scale
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay

@Composable
fun WelcomeScreen(
    onStartTutorial: () -> Unit = {},
    onSkipTutorial: () -> Unit = {}
) {
    var titleOpacity by remember { mutableStateOf(0f) }
    var contentOffset by remember { mutableStateOf(30.dp) }
    var illustrationScale by remember { mutableStateOf(0.8f) }
    var buttonsOpacity by remember { mutableStateOf(0f) }

    // Animate values
    val titleOpacityAnim by animateFloatAsState(
        targetValue = titleOpacity,
        animationSpec = tween(600)
    )

    val contentOffsetAnim by animateDpAsState(
        targetValue = contentOffset,
        animationSpec = tween(800, easing = FastOutSlowInEasing)
    )

    val illustrationScaleAnim by animateFloatAsState(
        targetValue = illustrationScale,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessLow
        )
    )

    val buttonsOpacityAnim by animateFloatAsState(
        targetValue = buttonsOpacity,
        animationSpec = tween(600)
    )

    LaunchedEffect(Unit) {
        titleOpacity = 1f
        contentOffset = 0.dp
        delay(200)
        illustrationScale = 1f
        delay(400)
        buttonsOpacity = 1f
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.White)
            .padding(24.dp)
    ) {
        Spacer(modifier = Modifier.height(40.dp))

        // Welcome header
        Column(
            modifier = Modifier
                .graphicsLayer {
                    alpha = titleOpacityAnim
                    translationY = contentOffsetAnim.toPx()
                }
        ) {
            // Welcome badge
            Surface(
                shape = RoundedCornerShape(20.dp),
                color = Color(0xFF6366F1).copy(alpha = 0.1f)
            ) {
                Text(
                    text = "Welcome!",
                    color = Color(0xFF6366F1),
                    fontSize = 14.sp,
                    fontWeight = FontWeight.SemiBold,
                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp)
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            Text(
                text = "Ready to test your\nAI intelligence?",
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF1F2937),
                lineHeight = 38.sp
            )

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "Join thousands of users discovering their AI potential. Let's get you started on your journey to understanding artificial intelligence.",
                fontSize = 16.sp,
                color = Color(0xFF6B7280),
                lineHeight = 24.sp
            )
        }

        Spacer(modifier = Modifier.weight(1f))

        // Illustration
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .scale(illustrationScaleAnim),
            contentAlignment = Alignment.Center
        ) {
            Card(
                modifier = Modifier
                    .size(200.dp)
                    .shadow(
                        elevation = 40.dp,
                        shape = CircleShape,
                        ambientColor = Color(0xFF6366F1).copy(alpha = 0.3f)
                    ),
                shape = CircleShape,
                colors = CardDefaults.cardColors(
                    containerColor = Color.Transparent
                )
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(
                            brush = Brush.radialGradient(
                                colors = listOf(
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6)
                                )
                            )
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Psychology,
                        contentDescription = "AI Brain",
                        tint = Color.White,
                        modifier = Modifier.size(80.dp)
                    )
                }
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        // Action buttons
        Column(
            modifier = Modifier.graphicsLayer { alpha = buttonsOpacityAnim },
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Button(
                onClick = onStartTutorial,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF6366F1)
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Text(
                    text = "Start Tutorial",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color.White
                )
                Spacer(modifier = Modifier.width(8.dp))
                Icon(
                    imageVector = Icons.Default.ArrowForward,
                    contentDescription = null,
                    modifier = Modifier.size(20.dp),
                    tint = Color.White
                )
            }

            OutlinedButton(
                onClick = onSkipTutorial,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                border = BorderStroke(1.dp, Color(0xFFE5E7EB)),
                shape = RoundedCornerShape(16.dp)
            ) {
                Text(
                    text = "Skip Tutorial",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF6B7280)
                )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun WelcomeScreenPreview() {
    WelcomeScreen()
}