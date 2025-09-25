from rest_framework import serializers
from apps.accounts.serializers import UserSerializer
from .models import Post


class PostSerializer(serializers.ModelSerializer):
    """
    Serializer for Post model with author information.
    """
    author = UserSerializer(read_only=True)

    class Meta:
        model = Post
        fields = ('id', 'title', 'content', 'author', 'created_at', 'updated_at')
        read_only_fields = ('id', 'author', 'created_at', 'updated_at')

    def create(self, validated_data):
        validated_data['author'] = self.context['request'].user
        return super().create(validated_data)


class PostCreateSerializer(serializers.ModelSerializer):
    """
    Serializer for creating posts.
    """
    class Meta:
        model = Post
        fields = ('title', 'content')

    def create(self, validated_data):
        validated_data['author'] = self.context['request'].user
        return super().create(validated_data)