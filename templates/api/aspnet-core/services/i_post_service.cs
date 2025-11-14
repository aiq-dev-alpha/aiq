using {{PROJECT_NAME}}.DTOs;

namespace {{PROJECT_NAME}}.Services;

public interface IPostService
{
    Task<IEnumerable<PostResponseDto>> GetAllPostsAsync();
    Task<PostResponseDto?> GetPostByIdAsync(int id);
    Task<PostResponseDto> CreatePostAsync(PostCreateDto postDto, string userId);
    Task<PostResponseDto> UpdatePostAsync(int id, PostUpdateDto postDto, string userId);
    Task<bool> DeletePostAsync(int id, string userId);
}