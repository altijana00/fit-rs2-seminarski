using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Helpers;
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

        //public async Task<bool> Delete(int id)
        //{
        //    var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == id);

        //    if (user != null)
        //    {
        //        if(user.RoleId == 2)
        //        {
        //            var studios = await _dbContext.Studios.Where(s => s.OwnerId == user.Id).ToListAsync();

        //            foreach (var s in studios)
        //            {
        //                var instructors = await _dbContext.Instructors.Where(i => i.StudioId == s.Id).ToListAsync();
        //                var classes = await _dbContext.Classes.Where(c => c.StudioId == s.Id).ToListAsync();

        //                foreach (var c in classes)
        //                {
        //                    var userClasses = await _dbContext.UserClasses.Where(uc => uc.ClassId == c.Id).ToListAsync();

        //                    _dbContext.UserClasses.RemoveRange(userClasses);
        //                    _dbContext.Classes.Remove(c);
        //                }

        //                _dbContext.Instructors.RemoveRange(instructors);
        //                _dbContext.Studios.Remove(s);
        //            }
        //        }

        //        _dbContext.Remove(user);
        //        await _dbContext.SaveChangesAsync();
        //        return true;
        //    }
        //    return false;
        //}

        public async Task<bool> Delete(int id)
        {
            var user = await _dbContext.Users
        .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
                return false;

            if (user.RoleId == int.Parse(AuthRoles.Owner))
            {
                var studioIds = await _dbContext.Studios
                    .Where(s => s.OwnerId == user.Id)
                    .Select(s => s.Id)
                    .ToListAsync();

                var classIds = await _dbContext.Classes
                    .Where(c => studioIds.Contains(c.StudioId))
                    .Select(c => c.Id)
                    .ToListAsync();

                var userClasses = await _dbContext.UserClasses
                    .Where(uc => classIds.Contains(uc.ClassId))
                    .ToListAsync();

                var classes = await _dbContext.Classes
                    .Where(c => studioIds.Contains(c.StudioId))
                    .ToListAsync();

                var instructors = await _dbContext.Instructors
                    .Where(i => studioIds.Contains(i.StudioId))
                    .ToListAsync();

                var studios = await _dbContext.Studios
                    .Where(s => studioIds.Contains(s.Id))
                    .ToListAsync();

                _dbContext.UserClasses.RemoveRange(userClasses);
                _dbContext.Classes.RemoveRange(classes);
                _dbContext.Instructors.RemoveRange(instructors);
                _dbContext.Studios.RemoveRange(studios);
            }


            _dbContext.Users.Remove(user);

            await _dbContext.SaveChangesAsync();

            return true;
        }
    }
}
