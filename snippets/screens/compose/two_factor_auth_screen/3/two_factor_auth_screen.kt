package com.example.auth.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.launch

enum class TwoFactorMode {
    Setup,
    Verify
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TwoFactorAuthScreen(
    mode: TwoFactorMode = TwoFactorMode.Setup,
    qrCodeUrl: String? = null,
    secret: String? = null,
    viewModel: TwoFactorAuthViewModel = viewModel(),
    onNavigateBack: () -> Unit = {},
    onSetupComplete: () -> Unit = {},
    onVerificationSuccess: () -> Unit = {}
) {
    val scrollState = rememberScrollState()
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()
    val clipboardManager = LocalClipboardManager.current

    LaunchedEffect(mode) {
        viewModel.setMode(mode)
        if (mode == TwoFactorMode.Setup) {
            viewModel.generateBackupCodes()
        }
    }

    LaunchedEffect(viewModel.setupSuccess) {
        if (viewModel.setupSuccess) {
            onSetupComplete()
        }
    }

    LaunchedEffect(viewModel.verificationSuccess) {
        if (viewModel.verificationSuccess) {
            coroutineScope.launch {
                snackbarHostState.showSnackbar("2FA verification successful!")
            }
            onVerificationSuccess()
        }
    }

    var showBackupCodeDialog by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        when (mode) {
                            TwoFactorMode.Setup -> "Setup 2FA"
                            TwoFactorMode.Verify -> "Two-Factor Authentication"
                        }
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                }
            )
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
            Spacer(modifier = Modifier.height(20.dp))

            // Icon
            Icon(
                imageVector = Icons.Default.Security,
                contentDescription = null,
                modifier = Modifier.size(80.dp),
                tint = MaterialTheme.colorScheme.primary
            )

            Spacer(modifier = Modifier.height(32.dp))

            when {
                mode == TwoFactorMode.Setup && viewModel.setupComplete -> {
                    BackupCodesContent(
                        backupCodes = viewModel.backupCodes,
                        onCopyAllCodes = { codes ->
                            val allCodes = "Your backup codes:\n\n${codes.joinToString("\n")}"
                            clipboardManager.setText(AnnotatedString(allCodes))
                            coroutineScope.launch {
                                snackbarHostState.showSnackbar("Copied to clipboard")
                            }
                        },
                        onContinue = onSetupComplete
                    )
                }
                mode == TwoFactorMode.Setup -> {
                    SetupContent(
                        secret = secret ?: "JBSWY3DPEHPK3PXP",
                        verificationCode = viewModel.verificationCode,
                        onVerificationCodeChange = viewModel::updateVerificationCode,
                        isLoading = viewModel.isLoading,
                        error = viewModel.error,
                        onEnable2FA = viewModel::enable2FA,
                        onCopySecret = { secretToCopy ->
                            clipboardManager.setText(AnnotatedString(secretToCopy))
                            coroutineScope.launch {
                                snackbarHostState.showSnackbar("Copied to clipboard")
                            }
                        }
                    )
                }
                else -> {
                    VerifyContent(
                        verificationCode = viewModel.verificationCode,
                        onVerificationCodeChange = viewModel::updateVerificationCode,
                        isLoading = viewModel.isLoading,
                        error = viewModel.error,
                        onVerify = viewModel::verify2FA,
                        onShowBackupCodeDialog = { showBackupCodeDialog = true }
                    )
                }
            }

            Spacer(modifier = Modifier.height(20.dp))
        }
    }

    if (showBackupCodeDialog) {
        BackupCodeDialog(
            onDismiss = { showBackupCodeDialog = false },
            onVerifyBackupCode = { code ->
                showBackupCodeDialog = false
                // Handle backup code verification
                onVerificationSuccess()
            }
        )
    }
}

@Composable
fun SetupContent(
    secret: String,
    verificationCode: String,
    onVerificationCodeChange: (String) -> Unit,
    isLoading: Boolean,
    error: String?,
    onEnable2FA: () -> Unit,
    onCopySecret: (String) -> Unit
) {
    // Header
    Text(
        text = "Setup Two-Factor Authentication",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(8.dp))

    Text(
        text = "Secure your account with an additional layer of protection.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(24.dp))

    // Step 1: Install Authenticator App
    SetupStepCard(
        stepNumber = 1,
        title = "Install an Authenticator App"
    ) {
        AuthenticatorAppsRow()
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Step 2: Scan QR Code
    SetupStepCard(
        stepNumber = 2,
        title = "Scan QR Code or Enter Secret"
    ) {
        QRCodeSection(
            secret = secret,
            onCopySecret = onCopySecret
        )
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Step 3: Enter Verification Code
    SetupStepCard(
        stepNumber = 3,
        title = "Enter Verification Code"
    ) {
        Column {
            Text(
                text = "Enter the 6-digit code from your authenticator app:",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(16.dp))

            OTPInputField(
                otp = verificationCode,
                onOtpChange = onVerificationCodeChange,
                isEnabled = !isLoading
            )

            error?.let {
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = it,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.error,
                    textAlign = TextAlign.Center
                )
            }
        }
    }

    Spacer(modifier = Modifier.height(32.dp))

    // Enable button
    Button(
        onClick = onEnable2FA,
        enabled = verificationCode.length == 6 && !isLoading,
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
            Text("Verify & Enable 2FA")
        }
    }
}

@Composable
fun VerifyContent(
    verificationCode: String,
    onVerificationCodeChange: (String) -> Unit,
    isLoading: Boolean,
    error: String?,
    onVerify: () -> Unit,
    onShowBackupCodeDialog: () -> Unit
) {
    // Header
    Text(
        text = "Two-Factor Authentication",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(8.dp))

    Text(
        text = "Enter the 6-digit code from your authenticator app.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(40.dp))

    // Verification code input
    OTPInputField(
        otp = verificationCode,
        onOtpChange = { newOtp ->
            onVerificationCodeChange(newOtp)
            if (newOtp.length == 6) {
                onVerify()
            }
        },
        isEnabled = !isLoading
    )

    error?.let {
        Spacer(modifier = Modifier.height(24.dp))
        ErrorCard(message = it)
    }

    Spacer(modifier = Modifier.height(32.dp))

    // Verify button
    Button(
        onClick = onVerify,
        enabled = verificationCode.length == 6 && !isLoading,
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
            Text("Verify")
        }
    }

    Spacer(modifier = Modifier.height(24.dp))

    // Backup code button
    TextButton(onClick = onShowBackupCodeDialog) {
        Text("Use Backup Code Instead")
    }
}

@Composable
fun BackupCodesContent(
    backupCodes: List<String>,
    onCopyAllCodes: (List<String>) -> Unit,
    onContinue: () -> Unit
) {
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
        text = "2FA Setup Complete!",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(8.dp))

    Text(
        text = "Save these backup codes in a safe place. You can use them to access your account if you lose your authenticator app.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(24.dp))

    // Warning card
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.warningContainer
        )
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.Warning,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onWarningContainer
            )
            Spacer(modifier = Modifier.width(12.dp))
            Column {
                Text(
                    text = "Important: Save Your Backup Codes",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onWarningContainer
                )
                Text(
                    text = "These codes can only be used once. Store them securely offline.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onWarningContainer
                )
            }
        }
    }

    Spacer(modifier = Modifier.height(24.dp))

    // Backup codes grid
    BackupCodesGrid(
        codes = backupCodes,
        onCopyAllCodes = onCopyAllCodes
    )

    Spacer(modifier = Modifier.height(32.dp))

    // Continue button
    Button(
        onClick = onContinue,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Text("Continue")
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Copy all codes button
    OutlinedButton(
        onClick = { onCopyAllCodes(backupCodes) },
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Icon(
            imageVector = Icons.Default.ContentCopy,
            contentDescription = null,
            modifier = Modifier.size(18.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
        Text("Copy All Codes")
    }
}

@Composable
fun SetupStepCard(
    stepNumber: Int,
    title: String,
    content: @Composable () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Surface(
                    modifier = Modifier.size(24.dp),
                    shape = androidx.compose.foundation.shape.CircleShape,
                    color = MaterialTheme.colorScheme.primary
                ) {
                    Box(
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = stepNumber.toString(),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onPrimary,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
                Spacer(modifier = Modifier.width(12.dp))
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            content()
        }
    }
}

@Composable
fun AuthenticatorAppsRow() {
    Row(
        horizontalArrangement = Arrangement.SpaceEvenly,
        modifier = Modifier.fillMaxWidth()
    ) {
        AuthenticatorAppItem("Google\nAuthenticator")
        AuthenticatorAppItem("Microsoft\nAuthenticator")
        AuthenticatorAppItem("Authy")
    }
}

@Composable
fun AuthenticatorAppItem(name: String) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Surface(
            modifier = Modifier.size(60.dp),
            shape = RoundedCornerShape(12.dp),
            color = MaterialTheme.colorScheme.secondaryContainer
        ) {
            Box(
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Security,
                    contentDescription = null,
                    modifier = Modifier.size(32.dp),
                    tint = MaterialTheme.colorScheme.onSecondaryContainer
                )
            }
        }
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = name,
            style = MaterialTheme.typography.bodySmall,
            textAlign = TextAlign.Center
        )
    }
}

@Composable
fun QRCodeSection(
    secret: String,
    onCopySecret: (String) -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // QR Code placeholder
        Surface(
            modifier = Modifier.size(200.dp),
            shape = RoundedCornerShape(12.dp),
            color = MaterialTheme.colorScheme.surfaceVariant
        ) {
            Column(
                modifier = Modifier.fillMaxSize(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Security, // Would use QR code icon
                    contentDescription = null,
                    modifier = Modifier.size(60.dp),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "QR Code",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        Text("Can't scan? Enter this code manually:")

        Spacer(modifier = Modifier.height(8.dp))

        Surface(
            shape = RoundedCornerShape(8.dp),
            color = MaterialTheme.colorScheme.surfaceVariant
        ) {
            Row(
                modifier = Modifier.padding(horizontal = 12.dp, vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = secret,
                    style = MaterialTheme.typography.bodyMedium.copy(fontFamily = FontFamily.Monospace),
                    fontWeight = FontWeight.Medium,
                    modifier = Modifier.weight(1f)
                )
                IconButton(onClick = { onCopySecret(secret) }) {
                    Icon(
                        imageVector = Icons.Default.ContentCopy,
                        contentDescription = "Copy to clipboard"
                    )
                }
            }
        }
    }
}

@Composable
fun BackupCodesGrid(
    codes: List<String>,
    onCopyAllCodes: (List<String>) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Backup Codes",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold
                )
                IconButton(onClick = { onCopyAllCodes(codes) }) {
                    Icon(
                        imageVector = Icons.Default.ContentCopy,
                        contentDescription = "Copy all codes"
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            LazyVerticalGrid(
                columns = GridCells.Fixed(2),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.height(200.dp)
            ) {
                items(codes) { code ->
                    Surface(
                        shape = RoundedCornerShape(6.dp),
                        color = MaterialTheme.colorScheme.surface,
                        border = androidx.compose.foundation.BorderStroke(
                            1.dp,
                            MaterialTheme.colorScheme.outline
                        )
                    ) {
                        Text(
                            text = code,
                            style = MaterialTheme.typography.bodySmall.copy(fontFamily = FontFamily.Monospace),
                            fontWeight = FontWeight.Medium,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp)
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun BackupCodeDialog(
    onDismiss: () -> Unit,
    onVerifyBackupCode: (String) -> Unit
) {
    var backupCode by remember { mutableStateOf("") }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Enter Backup Code") },
        text = {
            Column {
                Text("Enter one of your backup codes to sign in:")
                Spacer(modifier = Modifier.height(16.dp))
                OutlinedTextField(
                    value = backupCode,
                    onValueChange = { backupCode = it.uppercase() },
                    label = { Text("Backup Code") },
                    placeholder = { Text("XXXX-XXXX") },
                    singleLine = true
                )
            }
        },
        confirmButton = {
            Button(
                onClick = { onVerifyBackupCode(backupCode) },
                enabled = backupCode.isNotBlank()
            ) {
                Text("Verify")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}

class TwoFactorAuthViewModel : androidx.lifecycle.ViewModel() {
    var mode by mutableStateOf(TwoFactorMode.Setup)
        private set
    var verificationCode by mutableStateOf("")
        private set
    var isLoading by mutableStateOf(false)
        private set
    var setupComplete by mutableStateOf(false)
        private set
    var verificationSuccess by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set
    var backupCodes by mutableStateOf<List<String>>(emptyList())
        private set

    fun setMode(newMode: TwoFactorMode) {
        mode = newMode
    }

    fun updateVerificationCode(code: String) {
        if (code.all { it.isDigit() } && code.length <= 6) {
            verificationCode = code
            error = null
        }
    }

    fun generateBackupCodes() {
        backupCodes = (0..7).map {
            "${(1000..9999).random()}-${(1000..9999).random()}"
        }
    }

    fun enable2FA() {
        if (verificationCode.length != 6) return

        isLoading = true
        error = null

        androidx.lifecycle.viewModelScope.launch {
            try {
                kotlinx.coroutines.delay(2000)
                setupComplete = true
            } catch (e: Exception) {
                error = "Failed to enable 2FA. Please try again."
            } finally {
                isLoading = false
            }
        }
    }

    fun verify2FA() {
        if (verificationCode.length != 6) return

        isLoading = true
        error = null

        androidx.lifecycle.viewModelScope.launch {
            try {
                kotlinx.coroutines.delay(2000)
                verificationSuccess = true
            } catch (e: Exception) {
                error = "Invalid code. Please try again."
                verificationCode = ""
            } finally {
                isLoading = false
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun TwoFactorAuthSetupPreview() {
    MaterialTheme {
        TwoFactorAuthScreen(mode = TwoFactorMode.Setup)
    }
}

@Preview(showBackground = true)
@Composable
fun TwoFactorAuthVerifyPreview() {
    MaterialTheme {
        TwoFactorAuthScreen(mode = TwoFactorMode.Verify)
    }
}