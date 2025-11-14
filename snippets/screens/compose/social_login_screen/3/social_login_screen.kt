package com.example.auth.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.launch

enum class SocialProvider(
    val displayName: String,
    val icon: ImageVector,
    val color: Color,
    val backgroundColor: Color = Color.White
) {
    GOOGLE("Google", Icons.Default.Language, Color(0xFFDB4437)),
    APPLE("Apple", Icons.Default.Apple, Color.Black),
    FACEBOOK("Facebook", Icons.Default.Facebook, Color(0xFF4267B2)),
    MICROSOFT("Microsoft", Icons.Default.Window, Color(0xFF0078D4)),
    TWITTER("Twitter", Icons.Default.AlternateEmail, Color(0xFF1DA1F2)),
    GITHUB("GitHub", Icons.Default.Code, Color.Black)
}

@Composable
fun SocialLoginScreen(
    viewModel: SocialLoginViewModel = viewModel(),
    onNavigateToEmailLogin: () -> Unit = {},
    onNavigateToSignup: () -> Unit = {},
    onLoginSuccess: () -> Unit = {}
) {
    val scrollState = rememberScrollState()
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    LaunchedEffect(viewModel.loginSuccess) {
        if (viewModel.loginSuccess) {
            coroutineScope.launch {
                snackbarHostState.showSnackbar("Successfully signed in!")
            }
            onLoginSuccess()
        }
    }

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(24.dp)
                .verticalScroll(scrollState),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(60.dp))

            // App logo
            AppLogoCard()

            Spacer(modifier = Modifier.height(32.dp))

            // Header
            Text(
                text = "Welcome Back",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "Choose your preferred sign-in method",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(40.dp))

            viewModel.error?.let { error ->
                ErrorCard(message = error)
                Spacer(modifier = Modifier.height(24.dp))
            }

            // Social login buttons
            SocialProvider.values().forEach { provider ->
                SocialLoginButton(
                    provider = provider,
                    isLoading = viewModel.isLoading && viewModel.loadingProvider == provider,
                    onClick = { viewModel.signInWith(provider) }
                )
                Spacer(modifier = Modifier.height(12.dp))
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Divider
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                HorizontalDivider(modifier = Modifier.weight(1f))
                Text(
                    text = "OR",
                    style = MaterialTheme.typography.bodyMedium,
                    fontWeight = FontWeight.Medium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(horizontal = 16.dp)
                )
                HorizontalDivider(modifier = Modifier.weight(1f))
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Email login button
            Button(
                onClick = onNavigateToEmailLogin,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary
                )
            ) {
                Text(
                    text = "Sign in with Email",
                    fontWeight = FontWeight.SemiBold
                )
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Privacy notice
            PrivacyNoticeCard()

            Spacer(modifier = Modifier.height(32.dp))

            // Sign up link
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Don't have an account? ",
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                TextButton(onClick = onNavigateToSignup) {
                    Text("Sign Up")
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Terms and privacy
            TermsAndPrivacyText()

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}

@Composable
fun SocialLoginButton(
    provider: SocialProvider,
    isLoading: Boolean,
    onClick: () -> Unit
) {
    OutlinedButton(
        onClick = onClick,
        enabled = !isLoading,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline),
        colors = ButtonDefaults.outlinedButtonColors(
            containerColor = provider.backgroundColor
        )
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Start
        ) {
            if (isLoading) {
                CircularProgressIndicator(
                    modifier = Modifier.size(20.dp),
                    color = provider.color,
                    strokeWidth = 2.dp
                )
            } else {
                Icon(
                    imageVector = provider.icon,
                    contentDescription = null,
                    modifier = Modifier.size(20.dp),
                    tint = provider.color
                )
            }

            Spacer(modifier = Modifier.width(12.dp))

            Text(
                text = "Continue with ${provider.displayName}",
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.Medium,
                color = MaterialTheme.colorScheme.onSurface,
                modifier = Modifier.weight(1f),
                textAlign = TextAlign.Start
            )
        }
    }
}

@Composable
fun AppLogoCard() {
    Card(
        modifier = Modifier.size(80.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primary
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
    ) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Default.AccountCircle,
                contentDescription = "App Logo",
                modifier = Modifier.size(50.dp),
                tint = MaterialTheme.colorScheme.onPrimary
            )
        }
    }
}

@Composable
fun PrivacyNoticeCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.Security,
                contentDescription = null,
                modifier = Modifier.size(24.dp),
                tint = MaterialTheme.colorScheme.onPrimaryContainer
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Your Privacy Matters",
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onPrimaryContainer
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = "We use secure authentication and never store your social media passwords.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onPrimaryContainer,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
fun TermsAndPrivacyText() {
    Text(
        text = "By continuing, you agree to our Terms of Service and Privacy Policy",
        style = MaterialTheme.typography.bodySmall,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center,
        modifier = Modifier.padding(horizontal = 16.dp)
    )
}

// Compact social login component for use in other screens
@Composable
fun CompactSocialLogin(
    onProviderSelected: (SocialProvider) -> Unit,
    isLoading: Boolean = false,
    modifier: Modifier = Modifier
) {
    val mainProviders = listOf(SocialProvider.GOOGLE, SocialProvider.APPLE, SocialProvider.FACEBOOK)

    Column(
        modifier = modifier
    ) {
        // Divider
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            HorizontalDivider(modifier = Modifier.weight(1f))
            Text(
                text = "OR",
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Medium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.padding(horizontal = 16.dp)
            )
            HorizontalDivider(modifier = Modifier.weight(1f))
        }

        Spacer(modifier = Modifier.height(24.dp))

        // Social buttons row
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            mainProviders.forEach { provider ->
                CompactSocialButton(
                    provider = provider,
                    isLoading = isLoading,
                    onClick = { onProviderSelected(provider) },
                    modifier = Modifier.weight(1f)
                )
            }
        }
    }
}

@Composable
fun CompactSocialButton(
    provider: SocialProvider,
    isLoading: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedButton(
        onClick = onClick,
        enabled = !isLoading,
        modifier = modifier.height(50.dp),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline),
        colors = ButtonDefaults.outlinedButtonColors(
            containerColor = provider.backgroundColor
        )
    ) {
        if (isLoading) {
            CircularProgressIndicator(
                modifier = Modifier.size(20.dp),
                color = provider.color,
                strokeWidth = 2.dp
            )
        } else {
            Icon(
                imageVector = provider.icon,
                contentDescription = provider.displayName,
                modifier = Modifier.size(24.dp),
                tint = provider.color
            )
        }
    }
}

// Full-width colored social buttons alternative
@Composable
fun FullWidthSocialLogin(
    providers: List<SocialProvider>,
    onProviderSelected: (SocialProvider) -> Unit,
    isLoading: Boolean = false,
    loadingProvider: SocialProvider? = null,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        providers.forEach { provider ->
            val isCurrentlyLoading = isLoading && loadingProvider == provider

            Button(
                onClick = { onProviderSelected(provider) },
                enabled = !isLoading,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = provider.color,
                    contentColor = Color.White
                )
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Start
                ) {
                    if (isCurrentlyLoading) {
                        CircularProgressIndicator(
                            modifier = Modifier.size(20.dp),
                            color = Color.White,
                            strokeWidth = 2.dp
                        )
                    } else {
                        Icon(
                            imageVector = provider.icon,
                            contentDescription = null,
                            modifier = Modifier.size(20.dp),
                            tint = Color.White
                        )
                    }

                    Spacer(modifier = Modifier.width(12.dp))

                    Text(
                        text = "Continue with ${provider.displayName}",
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.SemiBold,
                        modifier = Modifier.weight(1f),
                        textAlign = TextAlign.Start
                    )
                }
            }
        }
    }
}

class SocialLoginViewModel : androidx.lifecycle.ViewModel() {
    var isLoading by mutableStateOf(false)
        private set
    var loadingProvider by mutableStateOf<SocialProvider?>(null)
        private set
    var loginSuccess by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set

    fun signInWith(provider: SocialProvider) {
        isLoading = true
        loadingProvider = provider
        error = null

        // Simulate API call
        androidx.lifecycle.viewModelScope.launch {
            try {
                kotlinx.coroutines.delay(2000)
                loginSuccess = true
            } catch (e: Exception) {
                error = "Failed to sign in with ${provider.displayName}. Please try again."
            } finally {
                isLoading = false
                loadingProvider = null
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun SocialLoginScreenPreview() {
    MaterialTheme {
        SocialLoginScreen()
    }
}

@Preview(showBackground = true)
@Composable
fun CompactSocialLoginPreview() {
    MaterialTheme {
        Column(modifier = Modifier.padding(24.dp)) {
            CompactSocialLogin(
                onProviderSelected = {}
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun FullWidthSocialLoginPreview() {
    MaterialTheme {
        Column(modifier = Modifier.padding(24.dp)) {
            FullWidthSocialLogin(
                providers = listOf(SocialProvider.GOOGLE, SocialProvider.FACEBOOK, SocialProvider.APPLE),
                onProviderSelected = {}
            )
        }
    }
}