package com.example.auth.screens

import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Error
import androidx.compose.material.icons.filled.Fingerprint
import androidx.compose.material.icons.filled.Security
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.launch

enum class BiometricType(
    val displayName: String,
    val icon: ImageVector,
    val description: String
) {
    FINGERPRINT("Fingerprint", Icons.Default.Fingerprint, "Use your fingerprint to authenticate"),
    FACE("Face Recognition", Icons.Default.Security, "Use your face to authenticate"),
    IRIS("Iris Recognition", Icons.Default.Security, "Use your eyes to authenticate"),
    NONE("Biometric", Icons.Default.Security, "Use biometric authentication")
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BiometricAuthScreen(
    isSetup: Boolean = false,
    viewModel: BiometricAuthViewModel = viewModel(),
    onNavigateBack: () -> Unit = {},
    onSetupComplete: () -> Unit = {},
    onAuthenticationSuccess: () -> Unit = {}
) {
    val context = LocalContext.current
    val scrollState = rememberScrollState()
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.checkBiometricAvailability(context)
        viewModel.isSetup = isSetup
    }

    LaunchedEffect(viewModel.authenticationSuccess) {
        if (viewModel.authenticationSuccess) {
            if (isSetup) {
                onSetupComplete()
            } else {
                coroutineScope.launch {
                    snackbarHostState.showSnackbar("Biometric authentication successful!")
                }
                onAuthenticationSuccess()
            }
        }
    }

    Scaffold(
        topBar = {
            if (isSetup) {
                TopAppBar(
                    title = { Text("Setup Biometric Auth") },
                    navigationIcon = {
                        IconButton(onClick = onNavigateBack) {
                            Icon(Icons.Default.Security, contentDescription = "Back")
                        }
                    }
                )
            }
        },
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
            Spacer(modifier = Modifier.height(if (isSetup) 20.dp else 60.dp))

            when {
                viewModel.setupComplete -> SetupCompleteContent(onContinue = onSetupComplete)
                !viewModel.isAvailable -> UnavailableContent(
                    error = viewModel.error,
                    isSetup = isSetup,
                    onCheckAgain = { viewModel.checkBiometricAvailability(context) },
                    onSkip = if (isSetup) onSetupComplete else onNavigateBack
                )
                else -> AuthenticationContent(
                    isSetup = isSetup,
                    biometricType = viewModel.biometricType,
                    availableBiometrics = viewModel.availableBiometrics,
                    selectedBiometric = viewModel.selectedBiometric,
                    onBiometricSelected = viewModel::selectBiometric,
                    isLoading = viewModel.isLoading,
                    error = viewModel.error,
                    onAuthenticate = {
                        if (context is FragmentActivity) {
                            viewModel.authenticateWithBiometric(context)
                        }
                    },
                    onSkip = if (isSetup) onSetupComplete else onNavigateBack
                )
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}

@Composable
fun AuthenticationContent(
    isSetup: Boolean,
    biometricType: BiometricType,
    availableBiometrics: List<BiometricType>,
    selectedBiometric: BiometricType,
    onBiometricSelected: (BiometricType) -> Unit,
    isLoading: Boolean,
    error: String?,
    onAuthenticate: () -> Unit,
    onSkip: () -> Unit
) {
    // Animated biometric icon
    val infiniteTransition = rememberInfiniteTransition(label = "biometric_animation")
    val scale by infiniteTransition.animateFloat(
        initialValue = 1f,
        targetValue = 1.1f,
        animationSpec = infiniteRepeatable(
            animation = tween(1500, easing = EaseInOut),
            repeatMode = RepeatMode.Reverse
        ),
        label = "scale_animation"
    )

    Icon(
        imageVector = biometricType.icon,
        contentDescription = null,
        modifier = Modifier
            .size(120.dp)
            .scale(scale),
        tint = MaterialTheme.colorScheme.primary
    )

    Spacer(modifier = Modifier.height(40.dp))

    // Header
    Text(
        text = if (isSetup) "Setup ${biometricType.displayName}" else "Biometric Authentication",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(12.dp))

    Text(
        text = if (isSetup) {
            "Enable ${biometricType.displayName.lowercase()} authentication for quick and secure access to your account."
        } else {
            biometricType.description
        },
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(40.dp))

    // Available biometric methods (if multiple)
    if (availableBiometrics.size > 1) {
        BiometricSelectionCard(
            availableBiometrics = availableBiometrics,
            selectedBiometric = selectedBiometric,
            onBiometricSelected = onBiometricSelected
        )
        Spacer(modifier = Modifier.height(32.dp))
    }

    error?.let {
        ErrorCard(message = it)
        Spacer(modifier = Modifier.height(24.dp))
    }

    // Security info card
    SecurityInfoCard()

    Spacer(modifier = Modifier.height(32.dp))

    // Authenticate button
    Button(
        onClick = onAuthenticate,
        enabled = !isLoading,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        if (isLoading) {
            CircularProgressIndicator(
                modifier = Modifier.size(20.dp),
                color = MaterialTheme.colorScheme.onPrimary
            )
        } else {
            Text(if (isSetup) "Enable ${biometricType.displayName}" else "Authenticate")
        }
    }

    Spacer(modifier = Modifier.height(16.dp))

    if (isSetup) {
        TextButton(onClick = onSkip) {
            Text("Skip for Now")
        }
    } else {
        OutlinedButton(
            onClick = onSkip,
            modifier = Modifier
                .fillMaxWidth()
                .height(56.dp)
        ) {
            Text("Use Password Instead")
        }
    }
}

@Composable
fun UnavailableContent(
    error: String?,
    isSetup: Boolean,
    onCheckAgain: () -> Unit,
    onSkip: () -> Unit
) {
    // Error icon
    Icon(
        imageVector = Icons.Default.Error,
        contentDescription = null,
        modifier = Modifier.size(80.dp),
        tint = MaterialTheme.colorScheme.error
    )

    Spacer(modifier = Modifier.height(32.dp))

    // Header
    Text(
        text = "Biometric Authentication Unavailable",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(12.dp))

    Text(
        text = error ?: "Biometric authentication is not available on this device or no biometrics are enrolled.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(40.dp))

    // Instructions card
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.warningContainer
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Error,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onWarningContainer
                )
                Spacer(modifier = Modifier.width(12.dp))
                Text(
                    text = "To use biometric authentication:",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.onWarningContainer
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "• Enable fingerprint or face unlock in device settings",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onWarningContainer
                )
                Text(
                    text = "• Make sure at least one biometric is enrolled",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onWarningContainer
                )
                Text(
                    text = "• Restart the app after enabling biometrics",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onWarningContainer
                )
            }
        }
    }

    Spacer(modifier = Modifier.height(32.dp))

    // Check again button
    Button(
        onClick = onCheckAgain,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Text("Check Again")
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Skip/alternative button
    OutlinedButton(
        onClick = onSkip,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Text(if (isSetup) "Skip Setup" else "Use Password Instead")
    }
}

@Composable
fun SetupCompleteContent(onContinue: () -> Unit) {
    // Success icon
    Box(
        modifier = Modifier
            .size(120.dp)
            .padding(24.dp),
        contentAlignment = Alignment.Center
    ) {
        Card(
            modifier = Modifier.fillMaxSize(),
            colors = CardDefaults.cardColors(
                containerColor = Color.Green.copy(alpha = 0.1f)
            ),
            shape = androidx.compose.foundation.shape.CircleShape
        ) {}
        Icon(
            imageVector = Icons.Default.CheckCircle,
            contentDescription = null,
            modifier = Modifier.size(80.dp),
            tint = Color.Green
        )
    }

    Spacer(modifier = Modifier.height(24.dp))

    // Header
    Text(
        text = "Biometric Authentication Enabled!",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(16.dp))

    Text(
        text = "You can now use biometric authentication to quickly and securely access your account.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(40.dp))

    // Features card
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.CheckCircle,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Spacer(modifier = Modifier.width(12.dp))
                Text(
                    text = "Biometric Authentication Features:",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "• Quick and secure login",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Text(
                    text = "• No need to remember passwords",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Text(
                    text = "• Your biometric data stays on your device",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Text(
                    text = "• Can be disabled anytime in settings",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }
        }
    }

    Spacer(modifier = Modifier.height(32.dp))

    // Continue button
    Button(
        onClick = onContinue,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Text("Continue to App")
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Test button
    OutlinedButton(
        onClick = { /* Test biometric */ },
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Text("Test Biometric Login")
    }
}

@Composable
fun BiometricSelectionCard(
    availableBiometrics: List<BiometricType>,
    selectedBiometric: BiometricType,
    onBiometricSelected: (BiometricType) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Available Authentication Methods:",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold
            )

            Spacer(modifier = Modifier.height(12.dp))

            availableBiometrics.forEach { biometric ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .selectable(
                            selected = selectedBiometric == biometric,
                            onClick = { onBiometricSelected(biometric) }
                        )
                        .padding(vertical = 4.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    RadioButton(
                        selected = selectedBiometric == biometric,
                        onClick = { onBiometricSelected(biometric) }
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Icon(
                        imageVector = biometric.icon,
                        contentDescription = null,
                        modifier = Modifier.size(24.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        text = biometric.displayName,
                        style = MaterialTheme.typography.bodyLarge
                    )
                }
            }
        }
    }
}

@Composable
fun SecurityInfoCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.Security,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Spacer(modifier = Modifier.width(12.dp))
            Text(
                text = "Your biometric data is stored securely on your device and is never shared.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

class BiometricAuthViewModel : androidx.lifecycle.ViewModel() {
    var isAvailable by mutableStateOf(false)
        private set
    var biometricType by mutableStateOf(BiometricType.NONE)
        private set
    var availableBiometrics by mutableStateOf<List<BiometricType>>(emptyList())
        private set
    var selectedBiometric by mutableStateOf(BiometricType.NONE)
        private set
    var isLoading by mutableStateOf(false)
        private set
    var setupComplete by mutableStateOf(false)
        private set
    var authenticationSuccess by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set

    var isSetup = false

    fun checkBiometricAvailability(context: android.content.Context) {
        val biometricManager = BiometricManager.from(context)

        when (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
            BiometricManager.BIOMETRIC_SUCCESS -> {
                isAvailable = true

                // Determine available biometric types
                val availableTypes = mutableListOf<BiometricType>()

                // Check for specific biometric types
                when (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)) {
                    BiometricManager.BIOMETRIC_SUCCESS -> {
                        // Default to fingerprint as it's most common
                        availableTypes.add(BiometricType.FINGERPRINT)
                        biometricType = BiometricType.FINGERPRINT
                        selectedBiometric = BiometricType.FINGERPRINT
                    }
                }

                availableBiometrics = availableTypes
                error = null
            }
            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> {
                isAvailable = false
                error = "Biometric authentication is not available"
            }
            BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE -> {
                isAvailable = false
                error = "Biometric hardware is currently unavailable"
            }
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> {
                isAvailable = false
                error = "No biometrics enrolled on this device"
            }
            else -> {
                isAvailable = false
                error = "Biometric authentication is not available"
            }
        }
    }

    fun selectBiometric(type: BiometricType) {
        selectedBiometric = type
        biometricType = type
    }

    fun authenticateWithBiometric(activity: FragmentActivity) {
        isLoading = true
        error = null

        val executor = ContextCompat.getMainExecutor(activity)
        val biometricPrompt = BiometricPrompt(activity, executor, object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                super.onAuthenticationSucceeded(result)
                isLoading = false
                if (isSetup) {
                    setupComplete = true
                } else {
                    authenticationSuccess = true
                }
            }

            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                super.onAuthenticationError(errorCode, errString)
                isLoading = false
                error = when (errorCode) {
                    BiometricPrompt.ERROR_USER_CANCELED -> "Authentication was cancelled"
                    BiometricPrompt.ERROR_LOCKOUT -> "Too many failed attempts. Try again later"
                    BiometricPrompt.ERROR_LOCKOUT_PERMANENT -> "Too many failed attempts. Biometric authentication disabled"
                    else -> errString.toString()
                }
            }

            override fun onAuthenticationFailed() {
                super.onAuthenticationFailed()
                // Don't set loading to false here as user can retry
                error = "Authentication failed. Please try again"
            }
        })

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle(if (isSetup) "Setup Biometric Authentication" else "Biometric Authentication")
            .setSubtitle(if (isSetup) "Enable biometric authentication for your account" else "Authenticate to continue")
            .setNegativeButtonText("Cancel")
            .build()

        biometricPrompt.authenticate(promptInfo)
    }
}

@Preview(showBackground = true)
@Composable
fun BiometricAuthScreenPreview() {
    MaterialTheme {
        BiometricAuthScreen(isSetup = true)
    }
}

@Preview(showBackground = true)
@Composable
fun BiometricAuthUnavailablePreview() {
    MaterialTheme {
        BiometricAuthScreen(
            viewModel = BiometricAuthViewModel().apply {
                // Would need to simulate unavailable state
            }
        )
    }
}