package com.template.android.domain.usecase

import com.template.android.domain.model.SampleItem
import com.template.android.domain.repository.SampleRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class GetSamplesUseCase @Inject constructor(
    private val repository: SampleRepository
) {
    operator fun invoke(): Flow<List<SampleItem>> {
        return repository.getAllSamples()
    }
}