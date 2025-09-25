package com.template.android.data.local

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.template.android.data.local.dao.SampleDao
import com.template.android.data.local.entity.SampleEntity

@Database(
    entities = [SampleEntity::class],
    version = 1,
    exportSchema = false
)
abstract class TemplateDatabase : RoomDatabase() {
    abstract fun sampleDao(): SampleDao
}