package com.template.android.di

import android.content.Context
import androidx.room.Room
import com.template.android.data.local.TemplateDatabase
import com.template.android.data.local.dao.SampleDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideTemplateDatabase(@ApplicationContext context: Context): TemplateDatabase {
        return Room.databaseBuilder(
            context,
            TemplateDatabase::class.java,
            "template_database"
        ).build()
    }

    @Provides
    fun provideSampleDao(database: TemplateDatabase): SampleDao {
        return database.sampleDao()
    }
}