package com.template.android.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "sample_items")
data class SampleEntity(
    @PrimaryKey val id: Int,
    val title: String,
    val description: String,
    val createdAt: Long = System.currentTimeMillis()
)