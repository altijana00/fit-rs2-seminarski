using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.UserClass;

namespace ZEN_Yoga.Services.Services.UserClass
{
    public class UpsertUserClassService : IUpsertUserClassService
    {
        private readonly ZenYogaDbContext _dbContext;
        

        public UpsertUserClassService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<bool> Join(int classId, int userId)
        {
            var classRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == classId);

            if (classRes == null)
            {
                return false;
            }

            var studioId = classRes.StudioId;
            //var membership = await _dbContext.UsersStudios.FirstOrDefaultAsync(us => us.StudioId == studioId && us.UserId == userId);
            var exists = await _dbContext.UserClasses.FirstOrDefaultAsync(uc => uc.ClassId == classId && uc.UserId == userId);

            if (exists == null)
            {
                var userClass = new Models.UserClass
                {


                    UserId = userId,
                    ClassId = classId,
                    JoinedAt = DateTime.Now
                };

                await _dbContext.UserClasses.AddAsync(userClass);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;

        }
    }
}
