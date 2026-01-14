using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Role;

namespace ZEN_Yoga.Services.Interfaces.User
{
    public interface IUpsertUserService<TEntity> : IUpsertService<EditUser> where TEntity : class
    {
        Task Add(IUserValidatorService userValidatorService, IRoleValidatorService roleValidatorService, ICityValidatorService cityValidatorService, RegisterUser registerUser);

        Task<string> UpdateUserPassword(UpdateUserPassword updateUserPassword, string token);
    }
}
