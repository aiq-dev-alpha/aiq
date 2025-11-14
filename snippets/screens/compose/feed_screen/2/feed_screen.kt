package com.socialapp.screens

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
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
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.google.accompanist.swiperefresh.SwipeRefresh
import com.google.accompanist.swiperefresh.rememberSwipeRefreshState

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FeedScreen(
    onNavigateToNotifications: () -> Unit = {},
    onNavigateToMessages: () -> Unit = {},
    onNavigateToCreatePost: () -> Unit = {},
    onNavigateToPostDetail: (Post) -> Unit = {},
    onNavigateToProfile: (String) -> Unit = {}
) {
    val viewModel = remember { FeedViewModel() }
    val posts by viewModel.posts.collectAsState()
    val isRefreshing by viewModel.isRefreshing.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        "SocialApp",
                        fontWeight = FontWeight.Bold,
                        fontSize = 20.sp
                    )
                },
                actions = {
                    IconButton(onClick = onNavigateToNotifications) {
                        Icon(
                            Icons.Outlined.FavoriteBorder,
                            contentDescription = "Notifications"
                        )
                    }
                    IconButton(onClick = onNavigateToMessages) {
                        Icon(
                            Icons.Outlined.Send,
                            contentDescription = "Messages"
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.background
                )
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = onNavigateToCreatePost,
                containerColor = MaterialTheme.colorScheme.primary
            ) {
                Icon(
                    Icons.Default.Add,
                    contentDescription = "Create Post",
                    tint = Color.White
                )
            }
        }
    ) { paddingValues ->
        SwipeRefresh(
            state = rememberSwipeRefreshState(isRefreshing),
            onRefresh = { viewModel.refreshFeed() },
            modifier = Modifier.padding(paddingValues)
        ) {
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(posts) { post ->
                    PostCard(
                        post = post,
                        onLike = { viewModel.toggleLike(post.id) },
                        onComment = { onNavigateToPostDetail(post) },
                        onShare = { viewModel.sharePost(post) },
                        onUserTap = { onNavigateToProfile(post.username) }
                    )
                }
            }
        }
    }
}

@Composable
fun PostCard(
    post: Post,
    onLike: () -> Unit = {},
    onComment: () -> Unit = {},
    onShare: () -> Unit = {},
    onUserTap: () -> Unit = {}
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        )
    ) {
        Column {
            // Header
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                AsyncImage(
                    model = ImageRequest.Builder(LocalContext.current)
                        .data(post.userAvatar)
                        .crossfade(true)
                        .build(),
                    contentDescription = "User Avatar",
                    modifier = Modifier
                        .size(40.dp)
                        .clip(CircleShape)
                        .clickable { onUserTap() },
                    contentScale = ContentScale.Crop
                )

                Spacer(modifier = Modifier.width(12.dp))

                Column(
                    modifier = Modifier
                        .weight(1f)
                        .clickable { onUserTap() }
                ) {
                    Text(
                        text = post.username,
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 14.sp
                    )
                    Text(
                        text = post.timeAgo,
                        fontSize = 12.sp,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                    )
                }

                IconButton(onClick = { /* Show more options */ }) {
                    Icon(
                        Icons.Default.MoreVert,
                        contentDescription = "More options",
                        tint = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                    )
                }
            }

            // Image
            AsyncImage(
                model = ImageRequest.Builder(LocalContext.current)
                    .data(post.imageUrl)
                    .crossfade(true)
                    .build(),
                contentDescription = "Post Image",
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(1f),
                contentScale = ContentScale.Crop
            )

            // Actions
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 8.dp, vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = onLike) {
                    Icon(
                        if (post.isLiked) Icons.Filled.Favorite else Icons.Outlined.FavoriteBorder,
                        contentDescription = "Like",
                        tint = if (post.isLiked) Color.Red else MaterialTheme.colorScheme.onSurface
                    )
                }

                IconButton(onClick = onComment) {
                    Icon(
                        Icons.Outlined.ChatBubbleOutline,
                        contentDescription = "Comment"
                    )
                }

                IconButton(onClick = onShare) {
                    Icon(
                        Icons.Outlined.Send,
                        contentDescription = "Share"
                    )
                }

                Spacer(modifier = Modifier.weight(1f))

                IconButton(onClick = { /* Save post */ }) {
                    Icon(
                        Icons.Outlined.BookmarkBorder,
                        contentDescription = "Save"
                    )
                }
            }

            // Likes and caption
            Column(
                modifier = Modifier.padding(horizontal = 16.dp)
            ) {
                Text(
                    text = "${post.likes} likes",
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 14.sp
                )

                Spacer(modifier = Modifier.height(4.dp))

                Row {
                    Text(
                        text = post.username,
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 14.sp
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = post.caption,
                        fontSize = 14.sp,
                        maxLines = 2,
                        overflow = TextOverflow.Ellipsis
                    )
                }

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = "View all ${post.comments} comments",
                    fontSize = 14.sp,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f),
                    modifier = Modifier.clickable { onComment() }
                )

                Spacer(modifier = Modifier.height(12.dp))
            }
        }
    }
}

class FeedViewModel {
    private val _posts = MutableStateFlow(samplePosts)
    val posts: StateFlow<List<Post>> = _posts.asStateFlow()

    private val _isRefreshing = MutableStateFlow(false)
    val isRefreshing: StateFlow<Boolean> = _isRefreshing.asStateFlow()

    fun refreshFeed() {
        _isRefreshing.value = true
        // Simulate API call
        kotlinx.coroutines.CoroutineScope(kotlinx.coroutines.Dispatchers.Main).launch {
            kotlinx.coroutines.delay(2000)
            _isRefreshing.value = false
            // Refresh posts
        }
    }

    fun toggleLike(postId: String) {
        val currentPosts = _posts.value.toMutableList()
        val postIndex = currentPosts.indexOfFirst { it.id == postId }
        if (postIndex != -1) {
            val post = currentPosts[postIndex]
            currentPosts[postIndex] = post.copy(
                isLiked = !post.isLiked,
                likes = if (post.isLiked) post.likes - 1 else post.likes + 1
            )
            _posts.value = currentPosts
        }
    }

    fun sharePost(post: Post) {
        // Implement share functionality
    }

    companion object {
        private val samplePosts = listOf(
            Post(
                id = "1",
                username = "john_doe",
                userAvatar = "https://example.com/avatar1.jpg",
                imageUrl = "https://example.com/post1.jpg",
                caption = "Beautiful sunset at the beach! 🌅",
                likes = 156,
                comments = 23,
                timeAgo = "2h",
                isLiked = false
            ),
            Post(
                id = "2",
                username = "jane_smith",
                userAvatar = "https://example.com/avatar2.jpg",
                imageUrl = "https://example.com/post2.jpg",
                caption = "Morning coffee and coding session ☕️💻",
                likes = 89,
                comments = 12,
                timeAgo = "4h",
                isLiked = true
            )
        )
    }
}

data class Post(
    val id: String,
    val username: String,
    val userAvatar: String,
    val imageUrl: String,
    val caption: String,
    val likes: Int,
    val comments: Int,
    val timeAgo: String,
    val isLiked: Boolean
)

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow