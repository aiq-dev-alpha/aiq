namespace {{PROJECT_NAME}}.DTOs;

public class LoginResponseDto
{
    public string Token { get; set; } = string.Empty;
    public UserResponseDto User { get; set; } = new();
    public DateTime ExpiresAt { get; set; }
}