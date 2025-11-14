package com.aiq.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.RocketLaunch
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay

@Composable
fun SplashScreen(
    onNavigateToOnboarding: () -> Unit = {}
) {
    var logoScale by remember { mutableStateOf(0.8f) }
    var logoOpacity by remember { mutableStateOf(0f) }
    var textOpacity by remember { mutableStateOf(0f) }
    var showProgress by remember { mutableStateOf(false) }

    // Animation values
    val logoScaleAnim by animateFloatAsState(
        targetValue = logoScale,
        animationSpec = spring(
            dampingRatio = Spring.DampingRatioMediumBouncy,
            stiffness = Spring.StiffnessLow
        )
    )

    val logoOpacityAnim by animateFloatAsState(
        targetValue = logoOpacity,
        animationSpec = tween(500)
    )

    val textOpacityAnim by animateFloatAsState(
        targetValue = textOpacity,
        animationSpec = tween(600)
    )

    LaunchedEffect(Unit) {
        // Start animations
        logoOpacity = 1f
        delay(200)
        logoScale = 1f
        delay(200)
        textOpacity = 1f
        delay(300)
        showProgress = true
        delay(3000)
        onNavigateToOnboarding()
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF6366F1), // Indigo 500
                        Color(0xFF6366F1).copy(alpha = 0.8f)
                    )
                )
            ),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Logo
            Card(
                modifier = Modifier
                    .size(120.dp)
                    .scale(logoScaleAnim)
                    .shadow(
                        elevation = 20.dp,
                        shape = RoundedCornerShape(24.dp),
                        ambientColor = Color.Black.copy(alpha = 0.1f)
                    ),
                shape = RoundedCornerShape(24.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.RocketLaunch,
                        contentDescription = "AIQ Logo",
                        tint = Color(0xFF6366F1),
                        modifier = Modifier
                            .size(60.dp)
                            .graphicsLayer { alpha = logoOpacityAnim }
                    )
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Title
            Text(
                text = "AIQ",
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White,
                letterSpacing = 2.sp,
                modifier = Modifier.graphicsLayer { alpha = textOpacityAnim }
            )

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "Artificial Intelligence Quotient",
                fontSize = 16.sp,
                color = Color.White.copy(alpha = 0.7f),
                letterSpacing = 0.5.sp,
                textAlign = TextAlign.Center,
                modifier = Modifier.graphicsLayer { alpha = textOpacityAnim }
            )

            Spacer(modifier = Modifier.height(80.dp))

            // Progress indicator
            if (showProgress) {
                CircularProgressIndicator(
                    modifier = Modifier.size(32.dp),
                    color = Color.White.copy(alpha = 0.7f),
                    strokeWidth = 2.dp
                )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun SplashScreenPreview() {
    SplashScreen()
}