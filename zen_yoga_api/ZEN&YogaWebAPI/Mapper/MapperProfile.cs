using AutoMapper;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.Requests;

namespace ZEN_YogaWebAPI.Mapper
{
    public class MapperProfile : Profile
    {
        public MapperProfile() 
        {
            CreateMap<User, UserResponse>();
            CreateMap<RegisterUser, User>();
            CreateMap<EditUser, User>();

            CreateMap<AddStudio, Studio>();
            CreateMap<Studio, StudioResponse>();
            CreateMap<EditStudio, Studio>();

            CreateMap<Class, ClassResponse>();
            CreateMap<AddClass, Class>();

            CreateMap<Instructor, InstructorResponse>();

            CreateMap<UserClass, UserClassesResponse>();

            CreateMap<YogaType, YogaTypeResponse>();
            CreateMap<EditYogaType, YogaType>();
            CreateMap<AddYogaType, YogaType>();

            CreateMap<Role, RoleResponse>();
            CreateMap<EditRole, Role>();
            CreateMap<AddRole, Role>();

            CreateMap<City, CityResponse>();
            CreateMap<EditCity, City>();
            CreateMap<AddCity, City>();

            CreateMap<AddNotification, Notification>();
            CreateMap<EditNotification, Notification>();
            CreateMap<Notification, NotificationResponse>();



        }
    }
}
