package com.example.auth.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.LockReset
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ResetPasswordScreen(
    token: String? = null,
    viewModel: ResetPasswordViewModel = viewModel(),
    onNavigateToLogin: () -> Unit = {}
) {
    val scrollState = rememberScrollState()
    val focusManager = LocalFocusManager.current

    LaunchedEffect(token) {
        viewModel.validateToken(token)
    }

    Scaffold { paddingValues ->
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

            if (viewModel.passwordReset) {
                SuccessContent(onNavigateToLogin = onNavigateToLogin)
            } else {
                ResetFormContent(
                    viewModel = viewModel,
                    focusManager = focusManager,
                    onNavigateToLogin = onNavigateToLogin
                )
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}

@Composable
fun ResetFormContent(
    viewModel: ResetPasswordViewModel,
    focusManager: androidx.compose.ui.focus.FocusManager,
    onNavigateToLogin: () -> Unit
) {
    // Header
    Text(
        text = "Create New Password",
        style = MaterialTheme.typography.headlineMedium,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(8.dp))

    Text(
        text = "Enter a new password for your account.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(40.dp))

    viewModel.error?.let { error ->
        ErrorCard(message = error)
        Spacer(modifier = Modifier.height(24.dp))
    }

    // New password field
    OutlinedTextField(
        value = viewModel.password,
        onValueChange = viewModel::updatePassword,
        label = { Text("New Password") },
        leadingIcon = { Icon(Icons.Default.Lock, contentDescription = null) },
        trailingIcon = {
            IconButton(onClick = { viewModel.togglePasswordVisibility() }) {
                Icon(
                    imageVector = if (viewModel.passwordVisible) Icons.Default.Visibility
                                 else Icons.Default.VisibilityOff,
                    contentDescription = if (viewModel.passwordVisible) "Hide password" else "Show password"
                )
            }
        },
        visualTransformation = if (viewModel.passwordVisible) VisualTransformation.None
                             else PasswordVisualTransformation(),
        supportingText = {
            Column {
                Text("At least 8 characters with uppercase, lowercase, number, and special character")
                viewModel.passwordError?.let { Text(it) }
                if (viewModel.password.isNotBlank() && viewModel.passwordError == null) {
                    PasswordStrengthIndicator(viewModel.password)
                }
            }
        },
        isError = viewModel.passwordError != null,
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Password,
            imeAction = ImeAction.Next
        ),
        keyboardActions = KeyboardActions(
            onNext = { focusManager.moveFocus(FocusDirection.Down) }
        ),
        modifier = Modifier.fillMaxWidth()
    )

    Spacer(modifier = Modifier.height(16.dp))

    // Confirm password field
    OutlinedTextField(
        value = viewModel.confirmPassword,
        onValueChange = viewModel::updateConfirmPassword,
        label = { Text("Confirm New Password") },
        leadingIcon = { Icon(Icons.Default.Lock, contentDescription = null) },
        trailingIcon = {
            IconButton(onClick = { viewModel.toggleConfirmPasswordVisibility() }) {
                Icon(
                    imageVector = if (viewModel.confirmPasswordVisible) Icons.Default.Visibility
                                 else Icons.Default.VisibilityOff,
                    contentDescription = if (viewModel.confirmPasswordVisible) "Hide password" else "Show password"
                )
            }
        },
        visualTransformation = if (viewModel.confirmPasswordVisible) VisualTransformation.None
                             else PasswordVisualTransformation(),
        isError = viewModel.confirmPasswordError != null,
        supportingText = viewModel.confirmPasswordError?.let { { Text(it) } },
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Password,
            imeAction = ImeAction.Done
        ),
        keyboardActions = KeyboardActions(
            onDone = {
                focusManager.clearFocus()
                viewModel.resetPassword()
            }
        ),
        modifier = Modifier.fillMaxWidth()
    )

    Spacer(modifier = Modifier.height(32.dp))

    // Password requirements card
    PasswordRequirementsCard(password = viewModel.password)

    Spacer(modifier = Modifier.height(32.dp))

    // Reset button
    Button(
        onClick = { viewModel.resetPassword() },
        enabled = !viewModel.isLoading && viewModel.isFormValid,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        if (viewModel.isLoading) {
            CircularProgressIndicator(
                modifier = Modifier.size(20.dp),
                color = MaterialTheme.colorScheme.onPrimary
            )
        } else {
            Text("Reset Password")
        }
    }

    Spacer(modifier = Modifier.height(24.dp))

    // Back to login
    TextButton(onClick = onNavigateToLogin) {
        Text("Back to Sign In")
    }
}

@Composable
fun SuccessContent(onNavigateToLogin: () -> Unit) {
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
        text = "Password Reset Successfully!",
        style = MaterialTheme.typography.headlineMedium,
        fontWeight = FontWeight.Bold,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(16.dp))

    Text(
        text = "Your password has been reset successfully. You can now sign in with your new password.",
        style = MaterialTheme.typography.bodyLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        textAlign = TextAlign.Center
    )

    Spacer(modifier = Modifier.height(64.dp))

    // Continue button
    Button(
        onClick = onNavigateToLogin,
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
    ) {
        Text("Continue to Sign In")
    }
}

@Composable
fun PasswordRequirementsCard(password: String) {
    val requirements = listOf(
        RequirementItem("At least 8 characters long", password.length >= 8),
        RequirementItem("Contains uppercase and lowercase letters",
            password.any { it.isUpperCase() } && password.any { it.isLowerCase() }),
        RequirementItem("Contains at least one number", password.any { it.isDigit() }),
        RequirementItem("Contains at least one special character", password.any { !it.isLetterOrDigit() })
    )

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
                    imageVector = Icons.Default.Security,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Password Requirements:",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            requirements.forEach { requirement ->
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.padding(vertical = 2.dp)
                ) {
                    Icon(
                        imageVector = if (requirement.isMet) Icons.Default.CheckCircle else Icons.Default.Lock,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp),
                        tint = if (requirement.isMet) Color.Green else MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = requirement.text,
                        style = MaterialTheme.typography.bodySmall,
                        color = if (requirement.isMet) Color.Green else MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

data class RequirementItem(
    val text: String,
    val isMet: Boolean
)

class ResetPasswordViewModel : androidx.lifecycle.ViewModel() {
    var password by mutableStateOf("")
        private set
    var confirmPassword by mutableStateOf("")
        private set
    var passwordVisible by mutableStateOf(false)
        private set
    var confirmPasswordVisible by mutableStateOf(false)
        private set

    var isLoading by mutableStateOf(false)
        private set
    var passwordReset by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set

    var passwordError by mutableStateOf<String?>(null)
        private set
    var confirmPasswordError by mutableStateOf<String?>(null)
        private set

    private var validToken = false

    val isFormValid: Boolean
        get() = isValidPassword(password) && password == confirmPassword && validToken

    fun validateToken(token: String?) {
        if (token.isNullOrBlank()) {
            error = "Invalid or expired reset link"
            validToken = false
        } else {
            validToken = true
        }
    }

    fun updatePassword(value: String) {
        password = value
        passwordError = if (value.isNotBlank() && !isValidPassword(value)) {
            "Password must meet all requirements"
        } else null

        // Revalidate confirm password
        if (confirmPassword.isNotBlank()) {
            confirmPasswordError = if (confirmPassword != value) "Passwords do not match" else null
        }
    }

    fun updateConfirmPassword(value: String) {
        confirmPassword = value
        confirmPasswordError = if (value.isNotBlank() && value != password) "Passwords do not match" else null
    }

    fun togglePasswordVisibility() {
        passwordVisible = !passwordVisible
    }

    fun toggleConfirmPasswordVisibility() {
        confirmPasswordVisible = !confirmPasswordVisible
    }

    fun resetPassword() {
        if (!isFormValid) return

        isLoading = true
        error = null

        // Simulate API call
        androidx.lifecycle.viewModelScope.launch {
            try {
                kotlinx.coroutines.delay(2000)
                passwordReset = true
            } catch (e: Exception) {
                error = "Failed to reset password. Please try again or request a new reset link."
            } finally {
                isLoading = false
            }
        }
    }

    private fun isValidPassword(password: String): Boolean {
        return password.length >= 8 &&
                password.any { it.isUpperCase() } &&
                password.any { it.isLowerCase() } &&
                password.any { it.isDigit() } &&
                password.any { !it.isLetterOrDigit() }
    }
}

@Preview(showBackground = true)
@Composable
fun ResetPasswordScreenPreview() {
    MaterialTheme {
        ResetPasswordScreen(token = "sample-token")
    }
}

@Preview(showBackground = true)
@Composable
fun ResetPasswordSuccessPreview() {
    MaterialTheme {
        ResetPasswordScreen(
            viewModel = ResetPasswordViewModel().apply {
                // Would need to set passwordReset = true for preview
            }
        )
    }
}