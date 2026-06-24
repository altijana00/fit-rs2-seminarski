using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.UserClass;

namespace ZEN_Yoga.Services.Services.UserClass
{
    public class GetUserClassService : IGetUserClassService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetUserClassService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }


        public async Task<List<UserClassesResponse>> GetAll()
        {
            var classes = await GetBaseUserClassesQuery().ToListAsync();

            return _mapper.Map<List<UserClassesResponse>>(classes).OrderByDescending(uc => uc.Id).ToList();
        }

        public List<int> GetAllByYogaTypeId(int yogaTypeId)
        {
            List<int> classes = _dbContext.UserClasses
                .AsNoTracking()
                .Where(c => c.Class!.YogaTypeId == yogaTypeId)
                .GroupBy(c => c.Class!.StudioId)
                .OrderByDescending(g => g.Count())
                .Take(3)
                .Select(g => g.Key).ToList();
              
            return classes;
        }

        public async Task<UserClassesResponse?> GetById(int id)
        {
            return await GetBaseUserClassesQuery().FirstOrDefaultAsync(uc => uc.Id == id);
        }

        public async Task<List<UserClassesResponse>> GetByUser(int id)
        {
            return await GetBaseUserClassesQuery()
                .Where(uc => uc.UserId == id).OrderByDescending(uc => uc.Id)
                .ToListAsync();
        }


        public async Task<List<ClassResponse>> GetByUserId(int userId)
        {
            var classes = await _dbContext.UserClasses.AsNoTracking()
                .Where(uc => uc.UserId == userId)
                .Select(uc => uc.Class)
                .ToListAsync();

            return _mapper.Map<List<ClassResponse>>(classes).OrderByDescending(c => c.Id).ToList();


        }

       

        public async Task<List<StudioResponse>> GetUserRecommendedStudios(int userId, IGetStudioService getStudioService)
        {
            var userClasses = await GetByUser(userId);
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == userId);

            var userYogaType = await GetUserMostAppliedYogaTypeId(userId, userClasses);

            var mostApplied = GetAllByYogaTypeId(userYogaType);

            var recommendedStudios = await _dbContext.Studios.AsNoTracking()
                .Where(s => mostApplied.Contains(s.Id) && s.CityId == user!.CityId)
                .Select(s => new StudioResponse
                {
                    Id = s.Id,
                    OwnerId = s.OwnerId,
                    Name = s.Name,
                    Description = s.Description,
                    CityId = s.CityId,
                    Address = s.Address,
                    ContactEmail = s.ContactEmail,
                    ContactPhone = s.ContactPhone,
                    ProfileImageUrl = s.ProfileImageUrl,
                    MembershipPrice = s.MembershipPrice
                })
                .ToListAsync();

            return recommendedStudios;
        }

        private int GetMaxYogaType(int yogatype1, int yogatype2, int yogatype3)
        {
            if (yogatype1 >= yogatype2 && yogatype1 >= yogatype3)
                return 1;
            else if (yogatype2 >= yogatype1 && yogatype2 >= yogatype3)
                return 2;
            else
                return 3;
        }

        private async Task<int> GetUserMostAppliedYogaTypeId(int userId, List<UserClassesResponse> userClasses)
        {
            int yogatype1Counter = 0;
            int yogatype2Counter = 0;
            int yogatype3Counter = 0;

            foreach (var userClass in userClasses)
            {
                if (userClass.YogaTypeId == 1) yogatype1Counter++;
                if (userClass.YogaTypeId == 2) yogatype2Counter++;
                if (userClass.YogaTypeId == 3) yogatype3Counter++;
            }

            return GetMaxYogaType(yogatype1Counter, yogatype2Counter, yogatype3Counter);
        }

        private IQueryable<UserClassesResponse> GetBaseUserClassesQuery()
        {
            return _dbContext.UserClasses.AsNoTracking()
                .Select(uc => new UserClassesResponse
                {
                    Id = uc.Id,
                    UserId = uc.UserId,
                    ClassId = uc.ClassId,
                    StudioId = uc.Class!.StudioId,
                    Name = uc.Class.Name,
                    StartDate = uc.Class.StartDate,
                    EndDate = uc.Class.EndDate,
                    MaxParticipants = uc.Class.MaxParticipants,
                    InstructorId = uc.Class.InstructorId,
                    YogaTypeId = uc.Class.YogaTypeId,
                    Description = uc.Class.Description,
                    Location = uc.Class.Location,
                    JoinedAt = uc.JoinedAt
                });
        }
    }
}
