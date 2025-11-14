package com.example.contentviewer.ui.screens

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.compose.ui.zIndex
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.PlayerView
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*
import kotlin.time.Duration.Companion.seconds

data class VideoData(
    val id: String,
    val title: String,
    val description: String,
    val videoUrl: String,
    val thumbnailUrl: String,
    val duration: Long, // in milliseconds
    val author: String,
    val authorAvatarUrl: String,
    val views: Long,
    val uploadDate: Date,
    val isLiked: Boolean = false,
    val isSubscribed: Boolean = false
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun VideoPlayerScreen(
    video: VideoData,
    viewModel: VideoPlayerViewModel = viewModel(),
    onBackClick: () -> Unit = {}
) {
    val uiState by viewModel.uiState.collectAsState()
    val context = LocalContext.current

    var showControls by remember { mutableStateOf(true) }
    var isFullscreen by remember { mutableStateOf(false) }
    var showComments by remember { mutableStateOf(false) }
    var showDescription by remember { mutableStateOf(false) }

    val coroutineScope = rememberCoroutineScope()

    // Auto-hide controls
    LaunchedEffect(showControls, uiState.isPlaying) {
        if (showControls && uiState.isPlaying) {
            delay(3.seconds)
            showControls = false
        }
    }

    LaunchedEffect(video) {
        viewModel.initializePlayer(context, video)
    }

    DisposableEffect(Unit) {
        onDispose {
            viewModel.releasePlayer()
        }
    }

    if (isFullscreen) {
        // Fullscreen Video Player
        Box(modifier = Modifier.fillMaxSize()) {
            VideoPlayerView(
                exoPlayer = uiState.exoPlayer,
                showControls = showControls,
                onPlayerClick = { showControls = !showControls },
                modifier = Modifier.fillMaxSize()
            )

            // Fullscreen Controls
            AnimatedVisibility(
                visible = showControls,
                enter = fadeIn(),
                exit = fadeOut(),
                modifier = Modifier.zIndex(1f)
            ) {
                VideoControlsOverlay(
                    uiState = uiState,
                    onPlayPause = viewModel::togglePlayPause,
                    onSeek = viewModel::seekTo,
                    onFullscreenToggle = { isFullscreen = false },
                    onBackClick = onBackClick,
                    isFullscreen = true
                )
            }
        }
    } else {
        // Normal Video Player with Content
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Video Player") },
                    navigationIcon = {
                        IconButton(onClick = onBackClick) {
                            Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                        }
                    },
                    actions = {
                        IconButton(onClick = { /* Share */ }) {
                            Icon(Icons.Default.Share, contentDescription = "Share")
                        }
                        IconButton(onClick = { viewModel.toggleBookmark() }) {
                            Icon(
                                imageVector = if (video.isLiked) Icons.Default.Bookmark else Icons.Default.BookmarkBorder,
                                contentDescription = "Bookmark",
                                tint = if (video.isLiked) MaterialTheme.colorScheme.primary else LocalContentColor.current
                            )
                        }
                    }
                )
            }
        ) { paddingValues ->
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
            ) {
                item {
                    // Video Player
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .aspectRatio(16f / 9f)
                    ) {
                        VideoPlayerView(
                            exoPlayer = uiState.exoPlayer,
                            showControls = showControls,
                            onPlayerClick = { showControls = !showControls }
                        )

                        // Video Controls
                        AnimatedVisibility(
                            visible = showControls,
                            enter = fadeIn(),
                            exit = fadeOut(),
                            modifier = Modifier.zIndex(1f)
                        ) {
                            VideoControlsOverlay(
                                uiState = uiState,
                                onPlayPause = viewModel::togglePlayPause,
                                onSeek = viewModel::seekTo,
                                onFullscreenToggle = { isFullscreen = true },
                                onBackClick = null,
                                isFullscreen = false
                            )
                        }
                    }
                }

                item {
                    // Video Information
                    VideoInfoSection(
                        video = video,
                        uiState = uiState,
                        onLikeClick = viewModel::toggleLike,
                        onSubscribeClick = viewModel::toggleSubscribe,
                        onDescriptionToggle = { showDescription = !showDescription },
                        showDescription = showDescription
                    )
                }

                item {
                    // Comments Section Preview
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp)
                            .clickable { showComments = true },
                        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                    ) {
                        Column(
                            modifier = Modifier.padding(16.dp)
                        ) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Text(
                                    text = "Comments",
                                    style = MaterialTheme.typography.titleMedium,
                                    fontWeight = FontWeight.Bold
                                )
                                Spacer(modifier = Modifier.weight(1f))
                                Text(
                                    text = "View all",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.primary
                                )
                                Icon(
                                    imageVector = Icons.Default.ChevronRight,
                                    contentDescription = null,
                                    modifier = Modifier.size(16.dp),
                                    tint = MaterialTheme.colorScheme.primary
                                )
                            }
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                text = "Tap to view comments and join the discussion",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }

                item {
                    // Related Videos
                    RelatedVideosSection()
                }
            }
        }
    }

    // Comments Bottom Sheet
    if (showComments) {
        ModalBottomSheet(
            onDismissRequest = { showComments = false }
        ) {
            CommentsBottomSheet(
                onDismiss = { showComments = false }
            )
        }
    }
}

@Composable
private fun VideoPlayerView(
    exoPlayer: ExoPlayer?,
    showControls: Boolean,
    onPlayerClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    AndroidView(
        factory = { context ->
            PlayerView(context).apply {
                player = exoPlayer
                useController = false // We'll use custom controls
                setOnClickListener { onPlayerClick() }
            }
        },
        update = { playerView ->
            playerView.player = exoPlayer
        },
        modifier = modifier
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun VideoControlsOverlay(
    uiState: VideoPlayerUiState,
    onPlayPause: () -> Unit,
    onSeek: (Long) -> Unit,
    onFullscreenToggle: () -> Unit,
    onBackClick: (() -> Unit)?,
    isFullscreen: Boolean
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black.copy(alpha = 0.3f))
    ) {
        // Top Controls
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
                .align(Alignment.TopStart),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            if (onBackClick != null) {
                IconButton(onClick = onBackClick) {
                    Icon(
                        imageVector = Icons.Default.ArrowBack,
                        contentDescription = "Back",
                        tint = Color.White
                    )
                }
            } else {
                Spacer(modifier = Modifier.size(48.dp))
            }

            Row {
                IconButton(onClick = { /* Settings */ }) {
                    Icon(
                        imageVector = Icons.Default.Settings,
                        contentDescription = "Settings",
                        tint = Color.White
                    )
                }
                IconButton(onClick = { /* More */ }) {
                    Icon(
                        imageVector = Icons.Default.MoreVert,
                        contentDescription = "More",
                        tint = Color.White
                    )
                }
            }
        }

        // Center Play/Pause Button
        IconButton(
            onClick = onPlayPause,
            modifier = Modifier
                .align(Alignment.Center)
                .size(80.dp)
        ) {
            Icon(
                imageVector = if (uiState.isPlaying) Icons.Default.Pause else Icons.Default.PlayArrow,
                contentDescription = if (uiState.isPlaying) "Pause" else "Play",
                tint = Color.White,
                modifier = Modifier.size(48.dp)
            )
        }

        // Bottom Controls
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomStart)
                .padding(16.dp)
        ) {
            // Progress Bar
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    text = formatDuration(uiState.currentPosition),
                    color = Color.White,
                    fontSize = 12.sp
                )
                Spacer(modifier = Modifier.width(8.dp))
                Slider(
                    value = if (uiState.duration > 0) uiState.currentPosition.toFloat() / uiState.duration.toFloat() else 0f,
                    onValueChange = { progress ->
                        val newPosition = (progress * uiState.duration).toLong()
                        onSeek(newPosition)
                    },
                    modifier = Modifier.weight(1f),
                    colors = SliderDefaults.colors(
                        thumbColor = Color.Red,
                        activeTrackColor = Color.Red
                    )
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = formatDuration(uiState.duration),
                    color = Color.White,
                    fontSize = 12.sp
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Control Buttons
            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                Row {
                    IconButton(onClick = { onSeek(uiState.currentPosition - 10000) }) {
                        Icon(
                            imageVector = Icons.Default.Replay10,
                            contentDescription = "Replay 10s",
                            tint = Color.White
                        )
                    }
                    IconButton(onClick = onPlayPause) {
                        Icon(
                            imageVector = if (uiState.isPlaying) Icons.Default.Pause else Icons.Default.PlayArrow,
                            contentDescription = if (uiState.isPlaying) "Pause" else "Play",
                            tint = Color.White
                        )
                    }
                    IconButton(onClick = { onSeek(uiState.currentPosition + 10000) }) {
                        Icon(
                            imageVector = Icons.Default.Forward10,
                            contentDescription = "Forward 10s",
                            tint = Color.White
                        )
                    }
                }

                IconButton(onClick = onFullscreenToggle) {
                    Icon(
                        imageVector = if (isFullscreen) Icons.Default.FullscreenExit else Icons.Default.Fullscreen,
                        contentDescription = if (isFullscreen) "Exit fullscreen" else "Fullscreen",
                        tint = Color.White
                    )
                }
            }
        }
    }
}

@Composable
private fun VideoInfoSection(
    video: VideoData,
    uiState: VideoPlayerUiState,
    onLikeClick: () -> Unit,
    onSubscribeClick: () -> Unit,
    onDescriptionToggle: () -> Unit,
    showDescription: Boolean
) {
    Column(
        modifier = Modifier.padding(16.dp)
    ) {
        // Title and View Count
        Text(
            text = video.title,
            style = MaterialTheme.typography.headlineSmall,
            fontWeight = FontWeight.Bold
        )
        Spacer(modifier = Modifier.height(4.dp))
        Text(
            text = "${formatViews(video.views)} views • ${formatUploadDate(video.uploadDate)}",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Action Buttons
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            item {
                VideoActionButton(
                    icon = if (uiState.isLiked) Icons.Default.ThumbUp else Icons.Default.ThumbUpOffAlt,
                    label = "Like",
                    isActive = uiState.isLiked,
                    onClick = onLikeClick
                )
            }
            item {
                VideoActionButton(
                    icon = Icons.Default.ThumbDownOffAlt,
                    label = "Dislike",
                    isActive = false,
                    onClick = { /* Handle dislike */ }
                )
            }
            item {
                VideoActionButton(
                    icon = Icons.Default.Share,
                    label = "Share",
                    isActive = false,
                    onClick = { /* Handle share */ }
                )
            }
            item {
                VideoActionButton(
                    icon = Icons.Default.Download,
                    label = "Download",
                    isActive = false,
                    onClick = { /* Handle download */ }
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Divider()
        Spacer(modifier = Modifier.height(16.dp))

        // Channel Information
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            AsyncImage(
                model = ImageRequest.Builder(LocalContext.current)
                    .data(video.authorAvatarUrl)
                    .crossfade(true)
                    .build(),
                contentDescription = video.author,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .size(48.dp)
                    .clip(CircleShape),
                error = painterResource(id = android.R.drawable.ic_menu_gallery)
            )

            Spacer(modifier = Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = video.author,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold
                )
                Text(
                    text = "1.2M subscribers",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            Button(
                onClick = onSubscribeClick,
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (uiState.isSubscribed) MaterialTheme.colorScheme.surfaceVariant else MaterialTheme.colorScheme.primary
                )
            ) {
                Text(
                    text = if (uiState.isSubscribed) "Subscribed" else "Subscribe",
                    color = if (uiState.isSubscribed) MaterialTheme.colorScheme.onSurfaceVariant else MaterialTheme.colorScheme.onPrimary
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Description
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .clickable { onDescriptionToggle() },
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
            )
        ) {
            Column(
                modifier = Modifier.padding(16.dp)
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = "Description",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.SemiBold,
                        modifier = Modifier.weight(1f)
                    )
                    Icon(
                        imageVector = if (showDescription) Icons.Default.ExpandLess else Icons.Default.ExpandMore,
                        contentDescription = if (showDescription) "Collapse" else "Expand"
                    )
                }

                AnimatedVisibility(
                    visible = showDescription,
                    enter = expandVertically() + fadeIn(),
                    exit = shrinkVertically() + fadeOut()
                ) {
                    Column {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = video.description,
                            style = MaterialTheme.typography.bodyMedium,
                            lineHeight = 20.sp
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun VideoActionButton(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    label: String,
    isActive: Boolean,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.clickable { onClick() }
    ) {
        Icon(
            imageVector = icon,
            contentDescription = label,
            tint = if (isActive) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.size(24.dp)
        )
        Spacer(modifier = Modifier.height(4.dp))
        Text(
            text = label,
            style = MaterialTheme.typography.bodySmall,
            color = if (isActive) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun RelatedVideosSection() {
    Column(
        modifier = Modifier.padding(16.dp)
    ) {
        Text(
            text = "Up Next",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold
        )
        Spacer(modifier = Modifier.height(12.dp))

        repeat(5) { index ->
            RelatedVideoItem(
                title = "Related Video ${index + 1}",
                channel = "Channel Name",
                views = "${(index + 1) * 123}K views",
                duration = "${3 + index}:${String.format("%02d", (index * 15) % 60)}",
                thumbnailUrl = "https://picsum.photos/120/68?random=${index + 20}"
            )
            if (index < 4) {
                Spacer(modifier = Modifier.height(12.dp))
            }
        }
    }
}

@Composable
private fun RelatedVideoItem(
    title: String,
    channel: String,
    views: String,
    duration: String,
    thumbnailUrl: String
) {
    Row(
        modifier = Modifier.fillMaxWidth()
    ) {
        Box {
            AsyncImage(
                model = ImageRequest.Builder(LocalContext.current)
                    .data(thumbnailUrl)
                    .crossfade(true)
                    .build(),
                contentDescription = title,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .width(120.dp)
                    .height(68.dp)
                    .clip(RoundedCornerShape(8.dp)),
                error = painterResource(id = android.R.drawable.ic_menu_gallery)
            )

            // Duration Badge
            Text(
                text = duration,
                color = Color.White,
                fontSize = 12.sp,
                fontWeight = FontWeight.SemiBold,
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .background(
                        Color.Black.copy(alpha = 0.8f),
                        RoundedCornerShape(4.dp)
                    )
                    .padding(horizontal = 4.dp, vertical = 2.dp)
            )
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Medium,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = channel,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Text(
                text = views,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }

        IconButton(onClick = { /* More options */ }) {
            Icon(
                imageVector = Icons.Default.MoreVert,
                contentDescription = "More options",
                modifier = Modifier.size(20.dp)
            )
        }
    }
}

@Composable
private fun CommentsBottomSheet(
    onDismiss: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                text = "Comments",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.weight(1f)
            )
            IconButton(onClick = onDismiss) {
                Icon(Icons.Default.Close, contentDescription = "Close")
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn {
            items(10) { index ->
                CommentItem(
                    author = "User ${index + 1}",
                    comment = "This is a great video! Really enjoyed the content and learned a lot.",
                    timestamp = "${index + 1}h ago"
                )
                if (index < 9) {
                    Spacer(modifier = Modifier.height(16.dp))
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Comment Input
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            TextField(
                value = "",
                onValueChange = { },
                placeholder = { Text("Add a comment...") },
                modifier = Modifier.weight(1f),
                colors = TextFieldDefaults.colors(
                    unfocusedIndicatorColor = Color.Transparent,
                    focusedIndicatorColor = Color.Transparent
                ),
                shape = RoundedCornerShape(24.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            IconButton(onClick = { /* Send comment */ }) {
                Icon(Icons.Default.Send, contentDescription = "Send")
            }
        }

        Spacer(modifier = Modifier.height(32.dp))
    }
}

@Composable
private fun CommentItem(
    author: String,
    comment: String,
    timestamp: String
) {
    Row(
        modifier = Modifier.fillMaxWidth()
    ) {
        Box(
            modifier = Modifier
                .size(32.dp)
                .clip(CircleShape)
                .background(MaterialTheme.colorScheme.primary),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = author.first().toString(),
                color = MaterialTheme.colorScheme.onPrimary,
                fontWeight = FontWeight.Bold,
                fontSize = 14.sp
            )
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column(modifier = Modifier.weight(1f)) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = author,
                    style = MaterialTheme.typography.bodySmall,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = timestamp,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            Spacer(modifier = Modifier.height(2.dp))
            Text(
                text = comment,
                style = MaterialTheme.typography.bodyMedium
            )
        }
    }
}

// Helper functions
private fun formatDuration(durationMs: Long): String {
    val totalSeconds = durationMs / 1000
    val minutes = totalSeconds / 60
    val seconds = totalSeconds % 60
    return String.format("%d:%02d", minutes, seconds)
}

private fun formatViews(views: Long): String {
    return when {
        views >= 1_000_000 -> String.format("%.1fM", views / 1_000_000.0)
        views >= 1_000 -> String.format("%.1fK", views / 1_000.0)
        else -> views.toString()
    }
}

private fun formatUploadDate(date: Date): String {
    val now = Date()
    val diffInMillis = now.time - date.time
    val diffInDays = diffInMillis / (24 * 60 * 60 * 1000)

    return when {
        diffInDays == 0L -> "Today"
        diffInDays == 1L -> "Yesterday"
        diffInDays < 7 -> "$diffInDays days ago"
        diffInDays < 30 -> "${diffInDays / 7} weeks ago"
        diffInDays < 365 -> "${diffInDays / 30} months ago"
        else -> "${diffInDays / 365} years ago"
    }
}

// ViewModel classes
class VideoPlayerViewModel : androidx.lifecycle.ViewModel() {
    private val _uiState = MutableState(
        VideoPlayerUiState(
            exoPlayer = null,
            isPlaying = false,
            currentPosition = 0L,
            duration = 0L,
            isLiked = false,
            isSubscribed = false
        )
    )
    val uiState: State<VideoPlayerUiState> = _uiState

    fun initializePlayer(context: android.content.Context, video: VideoData) {
        // Initialize ExoPlayer with video
    }

    fun releasePlayer() {
        // Release ExoPlayer resources
    }

    fun togglePlayPause() {
        // Toggle play/pause
    }

    fun seekTo(position: Long) {
        // Seek to position
    }

    fun toggleLike() {
        // Toggle like status
    }

    fun toggleSubscribe() {
        // Toggle subscription status
    }

    fun toggleBookmark() {
        // Toggle bookmark status
    }
}

data class VideoPlayerUiState(
    val exoPlayer: ExoPlayer?,
    val isPlaying: Boolean,
    val currentPosition: Long,
    val duration: Long,
    val isLiked: Boolean,
    val isSubscribed: Boolean
)