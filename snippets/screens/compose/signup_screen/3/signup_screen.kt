package com.example.auth.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Person
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
fun SignupScreen(
    viewModel: SignupViewModel = viewModel(),
    onNavigateToLogin: () -> Unit = {},
    onSignupSuccess: () -> Unit = {}
) {
    val scrollState = rememberScrollState()
    val focusManager = LocalFocusManager.current
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    LaunchedEffect(viewModel.signupSuccess) {
        if (viewModel.signupSuccess) {
            coroutineScope.launch {
                snackbarHostState.showSnackbar("Account created successfully!")
            }
            onSignupSuccess()
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
            Spacer(modifier = Modifier.height(40.dp))

            // Header
            Text(
                text = "Create Account",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "Sign up to get started",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(40.dp))

            // Name fields row
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                OutlinedTextField(
                    value = viewModel.firstName,
                    onValueChange = viewModel::updateFirstName,
                    label = { Text("First Name") },
                    leadingIcon = { Icon(Icons.Default.Person, contentDescription = null) },
                    isError = viewModel.firstNameError != null,
                    supportingText = viewModel.firstNameError?.let { { Text(it) } },
                    keyboardOptions = KeyboardOptions(
                        imeAction = ImeAction.Next
                    ),
                    keyboardActions = KeyboardActions(
                        onNext = { focusManager.moveFocus(FocusDirection.Next) }
                    ),
                    modifier = Modifier.weight(1f)
                )

                OutlinedTextField(
                    value = viewModel.lastName,
                    onValueChange = viewModel::updateLastName,
                    label = { Text("Last Name") },
                    leadingIcon = { Icon(Icons.Default.Person, contentDescription = null) },
                    isError = viewModel.lastNameError != null,
                    supportingText = viewModel.lastNameError?.let { { Text(it) } },
                    keyboardOptions = KeyboardOptions(
                        imeAction = ImeAction.Next
                    ),
                    keyboardActions = KeyboardActions(
                        onNext = { focusManager.moveFocus(FocusDirection.Next) }
                    ),
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Email field
            OutlinedTextField(
                value = viewModel.email,
                onValueChange = viewModel::updateEmail,
                label = { Text("Email") },
                leadingIcon = { Icon(Icons.Default.Email, contentDescription = null) },
                isError = viewModel.emailError != null,
                supportingText = viewModel.emailError?.let { { Text(it) } },
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Email,
                    imeAction = ImeAction.Next
                ),
                keyboardActions = KeyboardActions(
                    onNext = { focusManager.moveFocus(FocusDirection.Next) }
                ),
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Password field
            OutlinedTextField(
                value = viewModel.password,
                onValueChange = viewModel::updatePassword,
                label = { Text("Password") },
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
                isError = viewModel.passwordError != null,
                supportingText = {
                    Column {
                        viewModel.passwordError?.let { Text(it) }
                        if (viewModel.password.isNotBlank() && viewModel.passwordError == null) {
                            PasswordStrengthIndicator(viewModel.password)
                        }
                    }
                },
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Password,
                    imeAction = ImeAction.Next
                ),
                keyboardActions = KeyboardActions(
                    onNext = { focusManager.moveFocus(FocusDirection.Next) }
                ),
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Confirm password field
            OutlinedTextField(
                value = viewModel.confirmPassword,
                onValueChange = viewModel::updateConfirmPassword,
                label = { Text("Confirm Password") },
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
                        if (viewModel.acceptTerms) viewModel.signup()
                    }
                ),
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Terms and conditions checkbox
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Checkbox(
                    checked = viewModel.acceptTerms,
                    onCheckedChange = viewModel::updateAcceptTerms
                )

                Spacer(modifier = Modifier.width(8.dp))

                Text(
                    text = "I accept the Terms and Conditions and Privacy Policy",
                    style = MaterialTheme.typography.bodySmall,
                    modifier = Modifier.weight(1f)
                )
            }

            viewModel.error?.let { error ->
                Spacer(modifier = Modifier.height(16.dp))
                ErrorCard(message = error)
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Sign up button
            Button(
                onClick = { viewModel.signup() },
                enabled = !viewModel.isLoading && viewModel.isFormValid && viewModel.acceptTerms,
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
                    Text("Sign Up")
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Sign in link
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Already have an account? ",
                    style = MaterialTheme.typography.bodyMedium
                )
                TextButton(onClick = onNavigateToLogin) {
                    Text("Sign In")
                }
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}

@Composable
fun PasswordStrengthIndicator(password: String) {
    val strength = calculatePasswordStrength(password)
    val (color, text) = when (strength) {
        1 -> Pair(Color.Red, "Weak")
        2, 3 -> Pair(Color(0xFFFF9800), "Medium")
        4, 5 -> Pair(Color.Green, "Strong")
        else -> Pair(Color.Gray, "")
    }

    Column {
        LinearProgressIndicator(
            progress = strength / 5f,
            modifier = Modifier.fillMaxWidth(),
            color = color
        )
        Spacer(modifier = Modifier.height(4.dp))
        Text(
            text = "Password strength: $text",
            style = MaterialTheme.typography.bodySmall,
            color = color
        )
    }
}

private fun calculatePasswordStrength(password: String): Int {
    var score = 0
    if (password.length >= 8) score++
    if (password.any { it.isUpperCase() }) score++
    if (password.any { it.isLowerCase() }) score++
    if (password.any { it.isDigit() }) score++
    if (password.any { !it.isLetterOrDigit() }) score++
    return score
}

@Composable
fun ErrorCard(message: String) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.errorContainer
        )
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.Person, // You would use an error icon here
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onErrorContainer
            )
            Spacer(modifier = Modifier.width(12.dp))
            Text(
                text = message,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onErrorContainer,
                modifier = Modifier.weight(1f)
            )
        }
    }
}

// ViewModel would be implemented separately
class SignupViewModel : androidx.lifecycle.ViewModel() {
    var firstName by mutableStateOf("")
        private set
    var lastName by mutableStateOf("")
        private set
    var email by mutableStateOf("")
        private set
    var password by mutableStateOf("")
        private set
    var confirmPassword by mutableStateOf("")
        private set
    var acceptTerms by mutableStateOf(false)
        private set

    var passwordVisible by mutableStateOf(false)
        private set
    var confirmPasswordVisible by mutableStateOf(false)
        private set

    var isLoading by mutableStateOf(false)
        private set
    var signupSuccess by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set

    // Validation errors
    var firstNameError by mutableStateOf<String?>(null)
        private set
    var lastNameError by mutableStateOf<String?>(null)
        private set
    var emailError by mutableStateOf<String?>(null)
        private set
    var passwordError by mutableStateOf<String?>(null)
        private set
    var confirmPasswordError by mutableStateOf<String?>(null)
        private set

    val isFormValid: Boolean
        get() = firstName.isNotBlank() &&
                lastName.isNotBlank() &&
                isValidEmail(email) &&
                isValidPassword(password) &&
                password == confirmPassword

    fun updateFirstName(value: String) {
        firstName = value
        firstNameError = if (value.isBlank()) "First name is required" else null
    }

    fun updateLastName(value: String) {
        lastName = value
        lastNameError = if (value.isBlank()) "Last name is required" else null
    }

    fun updateEmail(value: String) {
        email = value
        emailError = if (value.isNotBlank() && !isValidEmail(value)) "Enter a valid email" else null
    }

    fun updatePassword(value: String) {
        password = value
        passwordError = if (value.isNotBlank() && !isValidPassword(value)) {
            "Password must be at least 8 characters with uppercase, lowercase, and number"
        } else null

        // Revalidate confirm password if it's filled
        if (confirmPassword.isNotBlank()) {
            confirmPasswordError = if (confirmPassword != value) "Passwords do not match" else null
        }
    }

    fun updateConfirmPassword(value: String) {
        confirmPassword = value
        confirmPasswordError = if (value.isNotBlank() && value != password) "Passwords do not match" else null
    }

    fun updateAcceptTerms(value: Boolean) {
        acceptTerms = value
        if (!value) {
            error = "Please accept the terms and conditions"
        } else {
            error = null
        }
    }

    fun togglePasswordVisibility() {
        passwordVisible = !passwordVisible
    }

    fun toggleConfirmPasswordVisibility() {
        confirmPasswordVisible = !confirmPasswordVisible
    }

    fun signup() {
        if (!isFormValid || !acceptTerms) {
            error = "Please complete all fields and accept terms"
            return
        }

        isLoading = true
        error = null

        // Simulate API call
        androidx.lifecycle.viewModelScope.launch {
            try {
                kotlinx.coroutines.delay(2000)
                signupSuccess = true
            } catch (e: Exception) {
                error = "Failed to create account. Please try again."
            } finally {
                isLoading = false
            }
        }
    }

    private fun isValidEmail(email: String): Boolean {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()
    }

    private fun isValidPassword(password: String): Boolean {
        return password.length >= 8 &&
                password.any { it.isUpperCase() } &&
                password.any { it.isLowerCase() } &&
                password.any { it.isDigit() }
    }
}

@Preview(showBackground = true)
@Composable
fun SignupScreenPreview() {
    MaterialTheme {
        SignupScreen()
    }
}