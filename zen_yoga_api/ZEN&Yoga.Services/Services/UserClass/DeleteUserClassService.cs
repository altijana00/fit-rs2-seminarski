using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Services.Interfaces.UserClass;

namespace ZEN_Yoga.Services.Services.UserClass
{
    public class DeleteUserClassService : IDeleteUserClassService
    {
        private readonly ZenYogaDbContext _dbContext;

        public DeleteUserClassService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<bool> Delete(int id)
        {
            var classRes = await _dbContext.UserClasses.FirstOrDefaultAsync(uc => uc.Id == id);

            if (classRes != null)
            {


                classRes.Status = UserClassStatus.Cancelled;
                classRes.CancelledAt = DateTime.Now;
                classRes.CancelledByUserId = classRes.UserId;

                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<bool> DeleteUserClass(int classId, int userId)
        {
            var classRes = await _dbContext.UserClasses.FirstOrDefaultAsync(uc => uc.ClassId == classId && uc.UserId == userId);

            if (classRes != null)
            {

                classRes.Status = UserClassStatus.Cancelled;
                classRes.CancelledAt = DateTime.Now;
                classRes.CancelledByUserId = userId;

                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
