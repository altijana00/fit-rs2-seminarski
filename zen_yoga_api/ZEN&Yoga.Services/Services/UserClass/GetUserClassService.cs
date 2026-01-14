using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
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
            var classes = await _dbContext.UserClasses
                .Include(uc => uc.Class)
                .Include(uc => uc.User)
                .Select(uc => new UserClassesResponse
                {
                    Id = uc.Id,
                    UserId = uc.UserId,
                    ClassId = uc.ClassId,
                    StudioId = uc.Class.StudioId,
                    Name = uc.Class.Name,
                    StartDate = uc.Class.StartDate,
                    EndDate = uc.Class.EndDate,
                    MaxParticipants = uc.Class.MaxParticipants,
                    InstructorId = uc.Class.InstructorId,
                    YogaTypeId = uc.Class.YogaTypeId,
                    Description = uc.Class.Description,
                    Location = uc.Class.Location,
                    JoinedAt = uc.JoinedAt

                }).ToListAsync();

            return _mapper.Map<List<UserClassesResponse>>(classes);
        }

        public List<int> GetAllByYogaTypeId(int yogaTypeId)
        {
            List<int> classes = _dbContext.UserClasses
                .Where(c => c.Class.YogaTypeId == yogaTypeId)
                .GroupBy(c => c.Class.StudioId)
                .OrderByDescending(g => g.Count())
                .Take(3)
                .Select(g => g.Key).ToList();
              
            return classes;
        }

        public async Task<UserClassesResponse> GetById(int id)
        {
            var userClasses = await GetAll();

            return userClasses.FirstOrDefault(uc => uc.Id == id);
        }

        public async Task<List<UserClassesResponse>> GetByUser(int id)
        {
            var userClasses = await GetAll();

            return userClasses.Where(uc => uc.UserId == id).ToList();
        }

        public async Task<List<ClassResponse>> GetByUserId(int userId)
        {
            var classes = new List<ZEN_Yoga.Models.Class>();

            var userClasses = await _dbContext.UserClasses.Where(uc => uc.UserId == userId).ToListAsync();

            foreach(var uc in userClasses)
            {
                var classRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == uc.ClassId);

                if (classRes != null)
                {
                    classes.Add(classRes);
                }
                
            }

            return _mapper.Map<List<ClassResponse>>(classes);


        }

        public async Task<List<StudioResponse>> GetUserRecommendedStudios(int userId, IGetStudioService getStudioService)
        {
            List<StudioResponse> recommendedStudios = new List<StudioResponse>();


            var userClasses = await GetByUser(userId); //njegove
            var userYogaType = await GetUserMostAppliedYogaTypeId(userId, userClasses);
            var mostApplied = GetAllByYogaTypeId(userYogaType);

            foreach (var s in mostApplied)
            {
                recommendedStudios.Add(await getStudioService.GetById(s));
            }

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
    }
}
