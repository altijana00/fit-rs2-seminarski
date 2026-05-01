using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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

            foreach (var c in mappedClasses) {
                c.JoinedParticipants = await GetJoinedParticipantsByClassId(c.Id);
            }

            return mappedClasses;

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
            var classRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == classId);

            if(classRes != null)
            {
                var classesList = await _dbContext.UserClasses.Where(c => c.ClassId == classId).ToListAsync();

                return classesList.Count();
            }

            throw new ClassNotFoundException("There is no class with this ID.");
                       
        }

        public async Task<List<ClassResponse>> GetByInstructorId(int instructorId, ClassQuery? classQuery)
        {
            IQueryable<ZEN_Yoga.Models.Class> classes = _dbContext.Classes.AsQueryable();

            if (!string.IsNullOrWhiteSpace(classQuery!.Search))
            {
                var search = classQuery.Search.ToLower();

                classes = classes.Where(c =>
                    c.Name.ToLower().Contains(search) ||
                    c.Location!.ToLower().Contains(search) ||
                    c.Studio!.Name.ToLower().Contains(search) 
                   
                );
            }

            if (classQuery.YogaTypeId.HasValue)
            {
                classes = classes.Where(c => c.YogaTypeId == classQuery.YogaTypeId);
            }

            var result = await classes.ToListAsync();

           var mappedClasses = _mapper.Map<List<ClassResponse>>(result);

            foreach (var c in mappedClasses) {
                c.JoinedParticipants = await GetJoinedParticipantsByClassId(c.Id);
            }

            return mappedClasses;
        }

        public async Task<List<ClassResponse>> GetByStudioId(int studioId)
        {
            var classes = await _dbContext.Classes.Where(c => c.StudioId == studioId).ToListAsync();

            var mappedClasses = _mapper.Map<List<ClassResponse>>(classes);

            foreach (var c in mappedClasses)
            {
                c.JoinedParticipants = await GetJoinedParticipantsByClassId(c.Id);
            }

            return mappedClasses;
        }

        public async Task<GrouppedClasses> GetGroupped()
        {
            var classes = await _dbContext.Classes.ToListAsync();
            var classesRes = _mapper.Map<List<ClassResponse>>(classes);
            var grouppedClasses = new GrouppedClasses();

            foreach (var c in classesRes)
            {
                c.JoinedParticipants = await GetJoinedParticipantsByClassId(c.Id);

                if (c.YogaTypeId == (int)YogaTypes.Hatha)
                {
                    grouppedClasses.HathaYoga.Add(c);
                }
                else
                {
                    if (c.YogaTypeId == (int)YogaTypes.Vinyasa)
                    {
                        grouppedClasses.VinyasaYoga.Add(c);
                    }
                    else
                    {
                        if (c.YogaTypeId == (int)YogaTypes.Yin)
                        {
                            grouppedClasses.YinYoga.Add(c);
                        }
                    }
                }

            }

            return grouppedClasses;
        }

        public async Task<GrouppedClasses> GetStudioGroupped(int studioId)
        {
            var classes = await _dbContext.Classes.Where(c => c.StudioId == studioId).ToListAsync();
            var classesRes = _mapper.Map<List<ClassResponse>>(classes);

            var grouppedClasses = new GrouppedClasses();

            foreach (var c in classesRes)
            {
                c.JoinedParticipants = await GetJoinedParticipantsByClassId(c.Id);
                if (c.YogaTypeId == (int)YogaTypes.Hatha)
                {
                    grouppedClasses.HathaYoga.Add(c);
                }
                else
                {
                    if (c.YogaTypeId == (int)YogaTypes.Vinyasa)
                    {
                        grouppedClasses.VinyasaYoga.Add(c);
                    }
                    else
                    {
                        if (c.YogaTypeId == (int)YogaTypes.Yin)
                        {
                            grouppedClasses.YinYoga.Add(c);
                        }
                    }
                }

            }

            return grouppedClasses;
        }

        public async Task<List<InstructorClasses>> GetInstructorGrouppedByStudioId(int studioId)
        {
            var instructors = await _dbContext.Instructors.Where(i => i.StudioId == studioId).ToListAsync();
            var instuctorGrouppedClasses = new List<InstructorClasses>();

            foreach(var i in instructors)
            {
                var numberOfInstructorClasses = await _dbContext.Classes.Where(c => c.InstructorId == i.Id).CountAsync();

                instuctorGrouppedClasses.Add(new InstructorClasses() {

                    Name = i.User!.FirstName + " " + i.User!.LastName,
                    NumberOfClasses = numberOfInstructorClasses
                }
                );                
            }
            return instuctorGrouppedClasses;        
        }



    }
}
