using AutoMapper;
using {{PROJECT_NAME}}.DTOs;
using {{PROJECT_NAME}}.Models;

namespace {{PROJECT_NAME}}.Configurations;

public class AutoMapperProfile : Profile
{
    public AutoMapperProfile()
    {
        // User mappings
        CreateMap<ApplicationUser, UserResponseDto>()
            .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName));

        CreateMap<UserRegistrationDto, ApplicationUser>()
            .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.Email));

        // Post mappings
        CreateMap<Post, PostResponseDto>()
            .ForMember(dest => dest.Author, opt => opt.MapFrom(src => src.User));

        CreateMap<PostCreateDto, Post>();
        CreateMap<PostUpdateDto, Post>()
            .ForAllMembers(opt => opt.Condition((src, dest, srcMember) => srcMember != null));
    }
}