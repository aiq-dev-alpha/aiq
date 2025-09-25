package com.template.android.data.local.dao

import androidx.room.*
import com.template.android.data.local.entity.SampleEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface SampleDao {

    @Query("SELECT * FROM sample_items ORDER BY createdAt DESC")
    fun getAllSamples(): Flow<List<SampleEntity>>

    @Query("SELECT * FROM sample_items WHERE id = :id")
    suspend fun getSampleById(id: Int): SampleEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSample(sample: SampleEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSamples(samples: List<SampleEntity>)

    @Update
    suspend fun updateSample(sample: SampleEntity)

    @Delete
    suspend fun deleteSample(sample: SampleEntity)

    @Query("DELETE FROM sample_items")
    suspend fun deleteAllSamples()
}