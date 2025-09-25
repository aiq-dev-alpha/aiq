using AutoMapper;
using Microsoft.EntityFrameworkCore;
using {{PROJECT_NAME}}.Data;
using {{PROJECT_NAME}}.DTOs;
using {{PROJECT_NAME}}.Models;

namespace {{PROJECT_NAME}}.Services;

public class PostService : IPostService
{
    private readonly ApplicationDbContext _context;
    private readonly IMapper _mapper;

    public PostService(ApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<IEnumerable<PostResponseDto>> GetAllPostsAsync()
    {
        var posts = await _context.Posts
            .Include(p => p.User)
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync();

        return _mapper.Map<IEnumerable<PostResponseDto>>(posts);
    }

    public async Task<PostResponseDto?> GetPostByIdAsync(int id)
    {
        var post = await _context.Posts
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.Id == id);

        return post != null ? _mapper.Map<PostResponseDto>(post) : null;
    }

    public async Task<PostResponseDto> CreatePostAsync(PostCreateDto postDto, string userId)
    {
        var post = _mapper.Map<Post>(postDto);
        post.UserId = userId;

        _context.Posts.Add(post);
        await _context.SaveChangesAsync();

        // Reload with user information
        var createdPost = await _context.Posts
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.Id == post.Id);

        return _mapper.Map<PostResponseDto>(createdPost);
    }

    public async Task<PostResponseDto> UpdatePostAsync(int id, PostUpdateDto postDto, string userId)
    {
        var post = await _context.Posts
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.Id == id);

        if (post == null)
        {
            throw new InvalidOperationException("Post not found");
        }

        if (post.UserId != userId)
        {
            throw new UnauthorizedAccessException("You can only update your own posts");
        }

        _mapper.Map(postDto, post);
        post.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return _mapper.Map<PostResponseDto>(post);
    }

    public async Task<bool> DeletePostAsync(int id, string userId)
    {
        var post = await _context.Posts.FindAsync(id);

        if (post == null)
        {
            return false;
        }

        if (post.UserId != userId)
        {
            throw new UnauthorizedAccessException("You can only delete your own posts");
        }

        _context.Posts.Remove(post);
        await _context.SaveChangesAsync();

        return true;
    }
}