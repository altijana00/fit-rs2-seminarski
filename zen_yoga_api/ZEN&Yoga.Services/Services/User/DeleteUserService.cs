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
                if(user.RoleId == 2)
                {
                    var studios = await _dbContext.Studios.Where(s => s.OwnerId == user.Id).ToListAsync();

                    foreach (var s in studios)
                    {
                        var instructors = await _dbContext.Instructors.Where(i => i.StudioId == s.Id).ToListAsync();
                        var classes = await _dbContext.Classes.Where(c => c.StudioId == s.Id).ToListAsync();

                        foreach (var c in classes)
                        {
                            var userClasses = await _dbContext.UserClasses.Where(uc => uc.ClassId == c.Id).ToListAsync();

                            _dbContext.UserClasses.RemoveRange(userClasses);
                            _dbContext.Classes.Remove(c);
                        }

                        _dbContext.Instructors.RemoveRange(instructors);
                        _dbContext.Studios.Remove(s);
                    }
                }

                _dbContext.Remove(user);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
