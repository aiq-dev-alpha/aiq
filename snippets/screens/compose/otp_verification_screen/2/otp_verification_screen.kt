package com.example.auth.screens

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Smartphone
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OTPVerificationScreen(
    phoneNumber: String = "",
    email: String = "",
    viewModel: OTPVerificationViewModel = viewModel(),
    onNavigateBack: () -> Unit = {},
    onVerificationSuccess: () -> Unit = {}
) {
    val scrollState = rememberScrollState()
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    LaunchedEffect(viewModel.verificationSuccess) {
        if (viewModel.verificationSuccess) {
            coroutineScope.launch {
                snackbarHostState.showSnackbar("OTP verified successfully!")
            }
            onVerificationSuccess()
        }
    }

    LaunchedEffect(viewModel.resendSuccess) {
        if (viewModel.resendSuccess) {
            coroutineScope.launch {
                snackbarHostState.showSnackbar("OTP sent successfully!")
            }
            viewModel.clearResendSuccess()
        }
    }

    LaunchedEffect(Unit) {
        viewModel.startCountdown()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Verify OTP") },
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
                imageVector = Icons.Default.Smartphone,
                contentDescription = null,
                modifier = Modifier.size(80.dp),
                tint = MaterialTheme.colorScheme.primary
            )

            Spacer(modifier = Modifier.height(32.dp))

            // Header
            Text(
                text = "Verify Your Account",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "We've sent a 6-digit code to\n${if (phoneNumber.isNotBlank()) phoneNumber else email}",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(40.dp))

            // OTP Input
            OTPInputField(
                otp = viewModel.otp,
                onOtpChange = { newOtp ->
                    viewModel.updateOtp(newOtp)
                    if (newOtp.length == 6) {
                        viewModel.verifyOtp()
                    }
                },
                isEnabled = !viewModel.isLoading
            )

            Spacer(modifier = Modifier.height(24.dp))

            viewModel.error?.let { error ->
                ErrorCard(message = error)
                Spacer(modifier = Modifier.height(16.dp))
            }

            // Resend section
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Didn't receive the code? ",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )

                if (viewModel.canResend) {
                    TextButton(
                        onClick = viewModel::resendOtp,
                        enabled = !viewModel.isLoading
                    ) {
                        Text("Resend")
                    }
                } else {
                    Text(
                        text = "Resend in ${viewModel.countdown}s",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Verify button
            Button(
                onClick = viewModel::verifyOtp,
                enabled = viewModel.otp.length == 6 && !viewModel.isLoading,
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
                    Text("Verify OTP")
                }
            }

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
                        modifier = Modifier.size(20.dp),
                        tint = MaterialTheme.colorScheme.onPrimaryContainer
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Enter the 6-digit code sent to your ${if (phoneNumber.isNotBlank()) "phone" else "email"}. The code expires in 10 minutes.",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onPrimaryContainer,
                        textAlign = TextAlign.Center
                    )
                }
            }

            Spacer(modifier = Modifier.height(64.dp))

            // Change contact info
            TextButton(onClick = onNavigateBack) {
                Text("Change ${if (phoneNumber.isNotBlank()) "Phone Number" else "Email"}")
            }

            Spacer(modifier = Modifier.height(40.dp))
        }
    }
}

@Composable
fun OTPInputField(
    otp: String,
    onOtpChange: (String) -> Unit,
    isEnabled: Boolean = true,
    digitCount: Int = 6
) {
    val focusRequesters = remember { List(digitCount) { FocusRequester() } }
    val focusManager = LocalFocusManager.current

    LaunchedEffect(Unit) {
        focusRequesters[0].requestFocus()
    }

    Row(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        repeat(digitCount) { index ->
            val digit = otp.getOrNull(index)?.toString() ?: ""
            val isFocused = index == otp.length

            OTPDigitBox(
                digit = digit,
                isFocused = isFocused,
                isEnabled = isEnabled,
                modifier = Modifier
                    .weight(1f)
                    .focusRequester(focusRequesters[index])
            ) {
                when {
                    it.isEmpty() && otp.isNotEmpty() -> {
                        // Backspace - remove last digit
                        onOtpChange(otp.dropLast(1))
                        if (otp.length > 1) {
                            focusRequesters[otp.length - 2].requestFocus()
                        }
                    }
                    it.isNotEmpty() && it.all { char -> char.isDigit() } -> {
                        val newOtp = if (index < otp.length) {
                            otp.substring(0, index) + it.last() + otp.substring(index + 1)
                        } else {
                            otp + it.last()
                        }

                        if (newOtp.length <= digitCount) {
                            onOtpChange(newOtp)

                            // Auto-focus next field
                            if (newOtp.length < digitCount) {
                                focusRequesters[newOtp.length].requestFocus()
                            } else {
                                focusManager.clearFocus()
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun OTPDigitBox(
    digit: String,
    isFocused: Boolean,
    isEnabled: Boolean,
    modifier: Modifier = Modifier,
    onValueChange: (String) -> Unit
) {
    BasicTextField(
        value = digit,
        onValueChange = onValueChange,
        enabled = isEnabled,
        singleLine = true,
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Number,
            imeAction = ImeAction.Next
        ),
        textStyle = MaterialTheme.typography.headlineSmall.copy(
            textAlign = TextAlign.Center,
            fontWeight = FontWeight.Bold,
            color = if (isEnabled) MaterialTheme.colorScheme.onSurface
                   else MaterialTheme.colorScheme.onSurfaceVariant
        ),
        modifier = modifier
            .height(60.dp)
            .border(
                width = if (isFocused) 2.dp else 1.dp,
                color = if (isFocused) MaterialTheme.colorScheme.primary
                       else MaterialTheme.colorScheme.outline,
                shape = RoundedCornerShape(12.dp)
            ),
        decorationBox = { innerTextField ->
            Box(
                contentAlignment = Alignment.Center,
                modifier = Modifier
                    .fillMaxSize()
                    .padding(8.dp)
            ) {
                innerTextField()
            }
        }
    )
}

class OTPVerificationViewModel : androidx.lifecycle.ViewModel() {
    var otp by mutableStateOf("")
        private set
    var isLoading by mutableStateOf(false)
        private set
    var verificationSuccess by mutableStateOf(false)
        private set
    var resendSuccess by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set
    var canResend by mutableStateOf(false)
        private set
    var countdown by mutableStateOf(30)
        private set

    fun updateOtp(value: String) {
        if (value.all { it.isDigit() } && value.length <= 6) {
            otp = value
            error = null
        }
    }

    fun startCountdown() {
        canResend = false
        countdown = 30

        androidx.lifecycle.viewModelScope.launch {
            while (countdown > 0) {
                delay(1000)
                countdown--
            }
            canResend = true
        }
    }

    fun verifyOtp() {
        if (otp.length != 6) return

        isLoading = true
        error = null

        // Simulate API call
        androidx.lifecycle.viewModelScope.launch {
            try {
                delay(2000)

                // Mock verification - in real app, call your API
                if (otp == "123456") {
                    verificationSuccess = true
                } else {
                    throw Exception("Invalid OTP")
                }
            } catch (e: Exception) {
                error = "Invalid OTP. Please check and try again."
                otp = ""
            } finally {
                isLoading = false
            }
        }
    }

    fun resendOtp() {
        if (!canResend) return

        isLoading = true
        error = null

        // Simulate API call
        androidx.lifecycle.viewModelScope.launch {
            try {
                delay(1000)
                resendSuccess = true
                startCountdown()
            } catch (e: Exception) {
                error = "Failed to resend OTP. Please try again."
            } finally {
                isLoading = false
            }
        }
    }

    fun clearResendSuccess() {
        resendSuccess = false
    }
}

@Preview(showBackground = true)
@Composable
fun OTPVerificationScreenPreview() {
    MaterialTheme {
        OTPVerificationScreen(
            phoneNumber = "+1 (555) 123-4567"
        )
    }
}

@Preview(showBackground = true)
@Composable
fun OTPInputFieldPreview() {
    MaterialTheme {
        Column(modifier = Modifier.padding(24.dp)) {
            OTPInputField(
                otp = "123",
                onOtpChange = {}
            )
        }
    }
}