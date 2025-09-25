from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from drf_spectacular.utils import extend_schema
from apps.common.utils import generate_jwt_token
from .serializers import UserRegistrationSerializer, UserLoginSerializer, UserSerializer


@extend_schema(
    summary="Register a new user",
    description="Create a new user account",
    request=UserRegistrationSerializer,
    responses={201: UserSerializer}
)
@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    """
    Register a new user.
    """
    serializer = UserRegistrationSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        user_serializer = UserSerializer(user)
        return Response(user_serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@extend_schema(
    summary="Login user",
    description="Authenticate user and return JWT token",
    request=UserLoginSerializer,
    responses={200: {
        'type': 'object',
        'properties': {
            'access_token': {'type': 'string'},
            'refresh_token': {'type': 'string'},
            'user': UserSerializer
        }
    }}
)
@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    """
    Login user and return JWT tokens.
    """
    serializer = UserLoginSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.validated_data['user']
        access_token = generate_jwt_token(user.id, 'access')
        refresh_token = generate_jwt_token(user.id, 'refresh')

        user_serializer = UserSerializer(user)
        return Response({
            'access_token': access_token,
            'refresh_token': refresh_token,
            'user': user_serializer.data
        })
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@extend_schema(
    summary="Get current user",
    description="Get current authenticated user information",
    responses={200: UserSerializer}
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def me(request):
    """
    Get current user information.
    """
    serializer = UserSerializer(request.user)
    return Response(serializer.data)