using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_Yoga.Services.Services.User
{
    public class DeleteUserService : IDeleteUserService
    {

    
        private readonly ZenYogaDbContext _dbContext;


        public DeleteUserService( ZenYogaDbContext dbContext)
        {
           
            _dbContext = dbContext;

        }

        public async Task<bool> Delete(int id)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == id);

            if (user != null)
            {
                _dbContext.Remove(user);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
