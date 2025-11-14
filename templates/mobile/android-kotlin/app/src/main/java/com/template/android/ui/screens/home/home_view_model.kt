package com.template.android.ui.screens.home

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.template.android.domain.model.SampleItem
import com.template.android.domain.repository.SampleRepository
import com.template.android.domain.usecase.GetSamplesUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
    private val getSamplesUseCase: GetSamplesUseCase,
    private val repository: SampleRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(HomeUiState())
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()

    init {
        loadSamples()
        syncSamples()
    }

    private fun loadSamples() {
        viewModelScope.launch {
            getSamplesUseCase()
                .catch { exception ->
                    _uiState.update { currentState ->
                        currentState.copy(
                            isLoading = false,
                            error = exception.message
                        )
                    }
                }
                .collect { samples ->
                    _uiState.update { currentState ->
                        currentState.copy(
                            isLoading = false,
                            samples = samples,
                            error = null
                        )
                    }
                }
        }
    }

    private fun syncSamples() {
        viewModelScope.launch {
            try {
                repository.syncSamples()
            } catch (e: Exception) {
                // Handle sync error if needed
            }
        }
    }

    fun refresh() {
        _uiState.update { it.copy(isLoading = true, error = null) }
        syncSamples()
    }
}

data class HomeUiState(
    val isLoading: Boolean = true,
    val samples: List<SampleItem> = emptyList(),
    val error: String? = null
)