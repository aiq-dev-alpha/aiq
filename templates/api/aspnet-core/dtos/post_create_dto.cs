using System.ComponentModel.DataAnnotations;

namespace {{PROJECT_NAME}}.DTOs;

public class PostCreateDto
{
    [Required(ErrorMessage = "Title is required")]
    [StringLength(255, ErrorMessage = "Title cannot exceed 255 characters")]
    public string Title { get; set; } = string.Empty;

    [Required(ErrorMessage = "Content is required")]
    public string Content { get; set; } = string.Empty;
}