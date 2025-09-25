package com.template.android.data.remote.api

import com.template.android.data.remote.dto.SampleDto
import retrofit2.http.*

interface SampleApiService {

    @GET("samples")
    suspend fun getSamples(): List<SampleDto>

    @GET("samples/{id}")
    suspend fun getSampleById(@Path("id") id: Int): SampleDto

    @POST("samples")
    suspend fun createSample(@Body sample: SampleDto): SampleDto

    @PUT("samples/{id}")
    suspend fun updateSample(
        @Path("id") id: Int,
        @Body sample: SampleDto
    ): SampleDto

    @DELETE("samples/{id}")
    suspend fun deleteSample(@Path("id") id: Int)
}