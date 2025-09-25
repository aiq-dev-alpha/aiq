package com.template.android.data.remote.dto

import kotlinx.serialization.Serializable

@Serializable
data class SampleDto(
    val id: Int,
    val title: String,
    val description: String,
    val createdAt: Long? = null
)