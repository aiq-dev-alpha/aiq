using System.ComponentModel.DataAnnotations;

namespace {{PROJECT_NAME}}.DTOs;

public class PostUpdateDto
{
    [StringLength(255, ErrorMessage = "Title cannot exceed 255 characters")]
    public string? Title { get; set; }

    public string? Content { get; set; }
}