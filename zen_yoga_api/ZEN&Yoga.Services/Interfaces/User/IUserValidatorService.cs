using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.User
{
    public interface IUserValidatorService 
    {
        Task<bool> ValidateEmail(string email);

        Task<bool> ValidateUserId(int id);
    }
}
