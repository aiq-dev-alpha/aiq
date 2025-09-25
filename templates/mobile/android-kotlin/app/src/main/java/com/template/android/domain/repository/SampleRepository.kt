package com.template.android.domain.repository

import com.template.android.domain.model.SampleItem
import kotlinx.coroutines.flow.Flow

interface SampleRepository {
    fun getAllSamples(): Flow<List<SampleItem>>
    suspend fun getSampleById(id: Int): SampleItem?
    suspend fun insertSample(sample: SampleItem)
    suspend fun updateSample(sample: SampleItem)
    suspend fun deleteSample(sample: SampleItem)
    suspend fun syncSamples()
}