using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.User
{
    public interface IGetUserService : IGetService<Models.User, UserResponse>
    {
        Task<PagedResponse<UserResponse>> GetUsersQuery(UserQuery userQuery, PagedRequest request);
        Task<UserResponse> GetByEmail(string email);

        Task<UserResponse> GetByEmailandPassword(string email, string password);

        Task<List<UserResponse>> GetAdminUsers(int roleId);
    }
}
