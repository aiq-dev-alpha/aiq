package com.template.android.data.repository

import com.template.android.data.local.dao.SampleDao
import com.template.android.data.local.entity.SampleEntity
import com.template.android.data.remote.api.SampleApiService
import com.template.android.data.remote.dto.SampleDto
import com.template.android.domain.model.SampleItem
import com.template.android.domain.repository.SampleRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SampleRepositoryImpl @Inject constructor(
    private val sampleDao: SampleDao,
    private val sampleApiService: SampleApiService
) : SampleRepository {

    override fun getAllSamples(): Flow<List<SampleItem>> {
        return sampleDao.getAllSamples().map { entities ->
            entities.map { it.toDomainModel() }
        }
    }

    override suspend fun getSampleById(id: Int): SampleItem? {
        return sampleDao.getSampleById(id)?.toDomainModel()
    }

    override suspend fun insertSample(sample: SampleItem) {
        sampleDao.insertSample(sample.toEntity())
    }

    override suspend fun updateSample(sample: SampleItem) {
        sampleDao.updateSample(sample.toEntity())
    }

    override suspend fun deleteSample(sample: SampleItem) {
        sampleDao.deleteSample(sample.toEntity())
    }

    override suspend fun syncSamples() {
        try {
            val remoteSamples = sampleApiService.getSamples()
            val entities = remoteSamples.map { it.toEntity() }
            sampleDao.insertSamples(entities)
        } catch (e: Exception) {
            // Handle network error
            // You might want to emit this to a UI state or log it
        }
    }

    private fun SampleEntity.toDomainModel(): SampleItem {
        return SampleItem(
            id = id,
            title = title,
            description = description,
            createdAt = createdAt
        )
    }

    private fun SampleItem.toEntity(): SampleEntity {
        return SampleEntity(
            id = id,
            title = title,
            description = description,
            createdAt = createdAt
        )
    }

    private fun SampleDto.toEntity(): SampleEntity {
        return SampleEntity(
            id = id,
            title = title,
            description = description,
            createdAt = createdAt ?: System.currentTimeMillis()
        )
    }
}