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
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun SuccessScreen(
    title: String? = null,
    message: String? = null,
    buttonText: String? = null,
    onContinue: () -> Unit = {}
) {
    var iconScale by remember { mutableStateOf(0f) }
    var contentOpacity by remember { mutableStateOf(0f) }

    val iconScaleAnim by animateFloatAsState(
        targetValue = iconScale,
        animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy)
    )

    val contentOpacityAnim by animateFloatAsState(
        targetValue = contentOpacity,
        animationSpec = tween(600)
    )

    LaunchedEffect(Unit) {
        iconScale = 1f
        kotlinx.coroutines.delay(200)
        contentOpacity = 1f
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF10B981),
                        Color(0xFF059669)
                    )
                )
            )
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Spacer(modifier = Modifier.weight(1f))

            // Success icon
            Card(
                modifier = Modifier
                    .size(120.dp)
                    .scale(iconScaleAnim),
                shape = CircleShape,
                colors = CardDefaults.cardColors(containerColor = Color.White),
                elevation = CardDefaults.cardElevation(defaultElevation = 30.dp)
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Check,
                        contentDescription = "Success",
                        tint = Color(0xFF10B981),
                        modifier = Modifier.size(60.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(40.dp))

            // Content
            Column(
                modifier = Modifier.graphicsLayer { alpha = contentOpacityAnim },
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = title ?: "Success!",
                    fontSize = 32.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(16.dp))

                Text(
                    text = message ?: "Your profile has been created successfully. You're ready to start your AIQ journey!",
                    fontSize = 16.sp,
                    color = Color.White.copy(alpha = 0.7f),
                    textAlign = TextAlign.Center,
                    lineHeight = 24.sp
                )
            }

            Spacer(modifier = Modifier.weight(1f))

            // Continue button
            Button(
                onClick = onContinue,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
                    .graphicsLayer { alpha = contentOpacityAnim },
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.White,
                    contentColor = Color(0xFF10B981)
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Text(
                    text = buttonText ?: "Get Started",
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
}