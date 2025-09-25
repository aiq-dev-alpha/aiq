using {{PROJECT_NAME}}.DTOs;

namespace {{PROJECT_NAME}}.Services;

public interface IAuthService
{
    Task<UserResponseDto> RegisterAsync(UserRegistrationDto registrationDto);
    Task<LoginResponseDto> LoginAsync(UserLoginDto loginDto);
    Task<UserResponseDto> GetCurrentUserAsync(string userId);
}