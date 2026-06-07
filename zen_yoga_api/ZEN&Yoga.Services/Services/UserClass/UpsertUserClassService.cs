using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.UserClass;
using ZEN_Yoga.Services.Services.Notifications;

namespace ZEN_Yoga.Services.Services.UserClass
{
    public class UpsertUserClassService : IUpsertUserClassService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;
        

        public UpsertUserClassService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }
        public async Task<bool> Join(int classId, int userId)
        {
            var classRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == classId);

            if (classRes == null)
            {
                return false;
            }

            var mappedClass = _mapper.Map<ClassResponse>(classRes);
            mappedClass.JoinedParticipants = await _dbContext.UserClasses.CountAsync(c=>c.Id == classId);

            var studioId = classRes.StudioId;
            
            var exists = await _dbContext.UserClasses.FirstOrDefaultAsync(uc => uc.ClassId == classId && uc.UserId == userId);

            if (exists == null)
            {
                if(mappedClass.JoinedParticipants < mappedClass.MaxParticipants)
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
                //return custom exception -> max number of participants
            }
            return false;

        }
    }
}
