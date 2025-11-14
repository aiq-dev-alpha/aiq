package com.example.auth.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.LockReset
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ForgotPasswordScreen(
    viewModel: ForgotPasswordViewModel = viewModel(),
    onNavigateBack: () -> Unit = {},
    onNavigateToLogin: () -> Unit = {}
) {
    val scrollState = rememberScrollState()
    val focusManager = LocalFocusManager.current
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    LaunchedEffect(viewModel.resendSuccess) {
        if (viewModel.resendSuccess) {
            coroutineScope.launch {
                snackbarHostState.showSnackbar("Reset email sent again!")
            }
            viewModel.clearResendSuccess()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Reset Password") },
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
            Spacer(modifier = Modifier.height(40.dp))

            // Icon
            Icon(
                imageVector = Icons.Default.LockReset,
                contentDescription = null,
                modifier = Modifier.size(80.dp),
                tint = MaterialTheme.colorScheme.primary
            )

            Spacer(modifier = Modifier.height(32.dp))

            if (viewModel.emailSent) {
                SuccessContent(
                    email = viewModel.email,
                    isLoading = viewModel.isLoading,
                    error = viewModel.error,
                    onResendEmail = viewModel::resendEmail,
                    onNavigateToLogin = onNavigateToLogin,
                    onUseDifferentEmail = viewModel::resetToEmailInput
                )
            } else {
                EmailInputContent(
                    email = viewModel.email,
                    emailError = viewModel.emailError,
                    isLoading = viewModel.isLoading,
                    error = viewModel.error,
                    onEmailChange = viewModel::updateEmail,
                    onSendResetLink = viewModel::sendResetLink,
                    onNavigateToLogin = onNavigateToLogin,
                    focusManager = focusManager
                )
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}

@Composable
fun EmailInputContent(
    email: String,
    emailError: String?,
    isLoading: Boolean,
    error: String?,
    onEmailChange: (String) -> Unit,
    onSendResetLink: () -> Unit,
    onNavigateToLogin: () -> Unit,
    focusManager: androidx.compose.ui.focus.FocusManager
) {
    // Header
    Text(
        text = "Forgot Password?",
        style = MaterialTheme.typography.headlineMedium,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(8.dp))

    Text(
        text = "Enter your email address and we'll send you a link to reset your password.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(40.dp))

    // Email input
    OutlinedTextField(
        value = email,
        onValueChange = onEmailChange,
        label = { Text("Email Address") },
        leadingIcon = { Icon(Icons.Default.Email, contentDescription = null) },
        supportingText = {
            if (emailError != null) {
                Text(emailError)
            } else {
                Text("We'll send a reset link to this email")
            }
        },
        isError = emailError != null,
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Email,
            imeAction = ImeAction.Done
        ),
        keyboardActions = KeyboardActions(
            onDone = {
                focusManager.clearFocus()
                onSendResetLink()
            }
        ),
        modifier = Modifier.fillMaxWidth()
    )

    error?.let {
        Spacer(modifier = Modifier.height(16.dp))
        ErrorCard(message = it)
    }

    Spacer(modifier = Modifier.height(32.dp))

    // Send button
    Button(
        onClick = onSendResetLink,
        enabled = !isLoading && email.isNotBlank() && emailError == null,
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
            Text("Send Reset Link")
        }
    }

    Spacer(modifier = Modifier.height(24.dp))

    // Back to login
    TextButton(onClick = onNavigateToLogin) {
        Text("Back to Sign In")
    }
}

@Composable
fun SuccessContent(
    email: String,
    isLoading: Boolean,
    error: String?,
    onResendEmail: () -> Unit,
    onNavigateToLogin: () -> Unit,
    onUseDifferentEmail: () -> Unit
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

    Spacer(modifier = Modifier.height(32.dp))

    // Header
    Text(
        text = "Check Your Email",
        style = MaterialTheme.typography.headlineMedium,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(16.dp))

    Text(
        text = "We've sent a password reset link to:",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(8.dp))

    Text(
        text = email,
        style = MaterialTheme.typography.bodyLarge,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(24.dp))

    // Info card
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
                imageVector = Icons.Default.Info,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onPrimaryContainer
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Didn't receive the email? Check your spam folder or try again.",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onPrimaryContainer,
                textAlign = TextAlign.Center
            )
        }
    }

    Spacer(modifier = Modifier.height(32.dp))

    // Resend button
    Button(
        onClick = onResendEmail,
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
            Text("Resend Email")
        }
    }

    Spacer(modifier = Modifier.height(16.dp))

    // Back to login
    OutlinedButton(
        onClick = onNavigateToLogin,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Text("Back to Sign In")
    }

    error?.let {
        Spacer(modifier = Modifier.height(16.dp))
        ErrorCard(message = it)
    }

    Spacer(modifier = Modifier.height(32.dp))

    // Use different email
    TextButton(onClick = onUseDifferentEmail) {
        Text("Use Different Email")
    }
}

class ForgotPasswordViewModel : androidx.lifecycle.ViewModel() {
    var email by mutableStateOf("")
        private set
    var isLoading by mutableStateOf(false)
        private set
    var emailSent by mutableStateOf(false)
        private set
    var resendSuccess by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set
    var emailError by mutableStateOf<String?>(null)
        private set

    fun updateEmail(value: String) {
        email = value
        emailError = if (value.isNotBlank() && !isValidEmail(value)) {
            "Enter a valid email"
        } else null
        error = null
    }

    fun sendResetLink() {
        if (!isValidEmail(email)) {
            emailError = "Enter a valid email"
            return
        }

        isLoading = true
        error = null

        // Simulate API call
        androidx.lifecycle.viewModelScope.launch {
            try {
                kotlinx.coroutines.delay(2000)
                emailSent = true
            } catch (e: Exception) {
                error = "Failed to send reset email. Please try again."
            } finally {
                isLoading = false
            }
        }
    }

    fun resendEmail() {
        isLoading = true
        error = null

        // Simulate API call
        androidx.lifecycle.viewModelScope.launch {
            try {
                kotlinx.coroutines.delay(1000)
                resendSuccess = true
            } catch (e: Exception) {
                error = "Failed to resend email. Please try again."
            } finally {
                isLoading = false
            }
        }
    }

    fun resetToEmailInput() {
        emailSent = false
        email = ""
        error = null
        emailError = null
    }

    fun clearResendSuccess() {
        resendSuccess = false
    }

    private fun isValidEmail(email: String): Boolean {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()
    }
}

@Preview(showBackground = true)
@Composable
fun ForgotPasswordScreenPreview() {
    MaterialTheme {
        ForgotPasswordScreen()
    }
}

@Preview(showBackground = true)
@Composable
fun ForgotPasswordSuccessPreview() {
    MaterialTheme {
        ForgotPasswordScreen(
            viewModel = ForgotPasswordViewModel().apply {
                updateEmail("test@example.com")
                // Would need to set emailSent = true for preview
            }
        )
    }
}