from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from drf_spectacular.utils import extend_schema
from .models import Post
from .serializers import PostSerializer, PostCreateSerializer


@extend_schema(
    summary="Get all posts",
    description="Get list of all posts with author information",
    responses={200: PostSerializer(many=True)}
)
@api_view(['GET'])
@permission_classes([AllowAny])
def post_list(request):
    """
    Get all posts.
    """
    posts = Post.objects.select_related('author').all()
    serializer = PostSerializer(posts, many=True)
    return Response(serializer.data)


@extend_schema(
    summary="Create a new post",
    description="Create a new post (requires authentication)",
    request=PostCreateSerializer,
    responses={201: PostSerializer}
)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def post_create(request):
    """
    Create a new post.
    """
    serializer = PostCreateSerializer(data=request.data, context={'request': request})
    if serializer.is_valid():
        post = serializer.save()
        response_serializer = PostSerializer(post)
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@extend_schema(
    summary="Get post by ID",
    description="Get a single post by its ID",
    responses={200: PostSerializer}
)
@api_view(['GET'])
@permission_classes([AllowAny])
def post_detail(request, pk):
    """
    Get a specific post.
    """
    post = get_object_or_404(Post.objects.select_related('author'), pk=pk)
    serializer = PostSerializer(post)
    return Response(serializer.data)


@extend_schema(
    summary="Update a post",
    description="Update a post (requires authentication and ownership)",
    request=PostCreateSerializer,
    responses={200: PostSerializer}
)
@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def post_update(request, pk):
    """
    Update a specific post.
    """
    post = get_object_or_404(Post, pk=pk)

    if post.author != request.user:
        return Response(
            {'error': 'You can only update your own posts'},
            status=status.HTTP_403_FORBIDDEN
        )

    serializer = PostCreateSerializer(post, data=request.data, context={'request': request})
    if serializer.is_valid():
        post = serializer.save()
        response_serializer = PostSerializer(post)
        return Response(response_serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@extend_schema(
    summary="Delete a post",
    description="Delete a post (requires authentication and ownership)",
    responses={204: None}
)
@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def post_delete(request, pk):
    """
    Delete a specific post.
    """
    post = get_object_or_404(Post, pk=pk)

    if post.author != request.user:
        return Response(
            {'error': 'You can only delete your own posts'},
            status=status.HTTP_403_FORBIDDEN
        )

    post.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)