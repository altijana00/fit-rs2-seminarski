using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Class;

namespace ZEN_Yoga.Services.Services.Class
{
    public class GetClassService : IGetClassService
    {

        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;

        public GetClassService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _mapper = mapper;
            _dbContext = dbContext;
        }

        public async Task<List<ClassResponse>> GetAll()
        {
            var classes = await _dbContext.Classes.ToListAsync();
            var mappedClasses = _mapper.Map<List<ClassResponse>>(classes);

            var participantCounts = await _dbContext.UserClasses
                .GroupBy(uc => uc.ClassId)
                .Select(g => new { ClassId = g.Key, Count = g.Count() })
                .ToListAsync();

            var countDict = participantCounts.ToDictionary(x => x.ClassId, x => x.Count);

            foreach (var c in mappedClasses)
                c.JoinedParticipants = countDict.GetValueOrDefault(c.Id, 0);

            return mappedClasses.OrderByDescending(c => c.Id).ToList();
        }

        public async Task<ClassResponse> GetById(int id)
        {
            var clasRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == id);

           var mappedClass = _mapper.Map<ClassResponse>(clasRes);
            mappedClass.JoinedParticipants = await GetJoinedParticipantsByClassId(id);

            return mappedClass;
        }


        public async Task<int> GetJoinedParticipantsByClassId(int classId)
        {
            var classExists = await _dbContext.Classes.AnyAsync(c => c.Id == classId);

            if (!classExists)
                throw new ClassNotFoundException("There is no class with this ID.");

            return await _dbContext.UserClasses.CountAsync(c => c.ClassId == classId);

        }

        

        public async Task<List<ClassResponse>> GetByInstructorId(int instructorId, ClassQuery? classQuery)
        {
            var query = _dbContext.Classes
        .AsQueryable();

            if (!string.IsNullOrWhiteSpace(classQuery?.Search))
            {
                var search = classQuery.Search.ToLower();
                query = query.Where(c =>
                    c.Name.ToLower().Contains(search) ||
                    c.Location!.ToLower().Contains(search) ||
                    c.Studio!.Name.ToLower().Contains(search));
            }

            if (classQuery?.YogaTypeId.HasValue == true)
                query = query.Where(c => c.YogaTypeId == classQuery.YogaTypeId);

            var classes = await query.ToListAsync();
            var mappedClasses = _mapper.Map<List<ClassResponse>>(classes);

            var classIds = mappedClasses.Select(c => c.Id).ToList();

            var participantCounts = await _dbContext.UserClasses
                .Where(uc => classIds.Contains(uc.ClassId))
                .GroupBy(uc => uc.ClassId)
                .Select(g => new { ClassId = g.Key, Count = g.Count() })
                .ToListAsync();

            var countDict = participantCounts.ToDictionary(x => x.ClassId, x => x.Count);

            foreach (var c in mappedClasses)
                c.JoinedParticipants = countDict.GetValueOrDefault(c.Id, 0);

            return mappedClasses.OrderByDescending(c => c.Id).ToList();
        }

        public async Task<List<ClassResponse>> GetByStudioId(int studioId)
        {
            var classes = await _dbContext.Classes
            .Where(c => c.StudioId == studioId)
            .ToListAsync();

            var mappedClasses = _mapper.Map<List<ClassResponse>>(classes);

            var classIds = mappedClasses.Select(c => c.Id).ToList();

            var participantCounts = await _dbContext.UserClasses
                .Where(uc => classIds.Contains(uc.ClassId))
                .GroupBy(uc => uc.ClassId)
                .Select(g => new { ClassId = g.Key, Count = g.Count() })
                .ToListAsync();

            var countDict = participantCounts.ToDictionary(x => x.ClassId, x => x.Count);

            foreach (var c in mappedClasses)
                c.JoinedParticipants = countDict.GetValueOrDefault(c.Id, 0);

            return mappedClasses.OrderByDescending(c => c.Id).ToList();
        }

       

        public async Task<GrouppedClasses> GetGroupped()
        {
            var classes = await _dbContext.Classes.ToListAsync();
            var mappedClasses = _mapper.Map<List<ClassResponse>>(classes);

            var classIds = mappedClasses.Select(c => c.Id).ToList();

            var participantCounts = await _dbContext.UserClasses
                .Where(uc => classIds.Contains(uc.ClassId))
                .GroupBy(uc => uc.ClassId)
                .Select(g => new { ClassId = g.Key, Count = g.Count() })
                .ToListAsync();

            var countDict = participantCounts.ToDictionary(x => x.ClassId, x => x.Count);

            foreach (var c in mappedClasses)
                c.JoinedParticipants = countDict.GetValueOrDefault(c.Id, 0);

            return new GrouppedClasses
            {
                HathaYoga = mappedClasses.Where(c => c.YogaTypeId == (int)YogaTypes.Hatha).ToList(),
                VinyasaYoga = mappedClasses.Where(c => c.YogaTypeId == (int)YogaTypes.Vinyasa).ToList(),
                YinYoga = mappedClasses.Where(c => c.YogaTypeId == (int)YogaTypes.Yin).ToList()
            };
        }

       

        public async Task<GrouppedClasses> GetStudioGroupped(int studioId, int userId, int userRoleId)
        {
            var classes = await _dbContext.Classes
        .Where(c =>
            c.StudioId == studioId &&
            !_dbContext.UserClasses.Any(uc =>
                uc.ClassId == c.Id &&
                uc.UserId == userId))
        .Select(c => new ClassResponse
        {
            Id = c.Id,
            StudioId = c.StudioId,
            InstructorId = c.InstructorId,
            YogaTypeId = c.YogaTypeId,
            Name = c.Name,
            Description = c.Description,
            Location = c.Location,
            StartDate = c.StartDate,
            EndDate = c.EndDate,
            MaxParticipants = c.MaxParticipants,
            JoinedParticipants = _dbContext.UserClasses
                .Count(uc => uc.ClassId == c.Id)
        })
        .ToListAsync();

            return new GrouppedClasses
            {
                HathaYoga = classes
                    .Where(c => c.YogaTypeId == (int)YogaTypes.Hatha)
                    .ToList(),

                VinyasaYoga = classes
                    .Where(c => c.YogaTypeId == (int)YogaTypes.Vinyasa)
                    .ToList(),

                YinYoga = classes
                    .Where(c => c.YogaTypeId == (int)YogaTypes.Yin)
                    .ToList()
            };
        }



        public async Task<List<InstructorClasses>> GetInstructorGrouppedByStudioId(int studioId)
        {

            var result = await _dbContext.Instructors
        .Where(i => i.StudioId == studioId)
        .Select(i => new InstructorClasses
        {
            Name = _dbContext.Users
                .Where(u => u.Id == i.Id)
                .Select(u => u.FirstName + " " + u.LastName)
                .FirstOrDefault()!,

            NumberOfClasses = _dbContext.Classes
                .Count(c => c.InstructorId == i.Id)
        })
        .ToListAsync();

            return result;
        }



    }
}
