using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
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
            return _mapper.Map<List<ClassResponse>>(classes);
        }

        public async Task<ClassResponse> GetById(int id)
        {
            var clasRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == id);

            return _mapper.Map<ClassResponse>(clasRes);
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

            return _mapper.Map<List<ClassResponse>>(result);
        }

        public async Task<List<ClassResponse>> GetByStudioId(int studioId)
        {
            var classes = await _dbContext.Classes.Where(c => c.StudioId == studioId).ToListAsync();

            return _mapper.Map<List<ClassResponse>>(classes);
        }

        public async Task<GrouppedClasses> GetGroupped()
        {
            var classes = await _dbContext.Classes.ToListAsync();
            var classesRes = _mapper.Map<List<ClassResponse>>(classes);
            var grouppedClasses = new GrouppedClasses();

            foreach (var c in classesRes)
            {
                if (c.YogaTypeId == 1)
                {
                    grouppedClasses.HathaYoga.Add(c);
                }
                else
                {
                    if (c.YogaTypeId == 2)
                    {
                        grouppedClasses.VinyasaYoga.Add(c);
                    }
                    else
                    {
                        if (c.YogaTypeId == 3)
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
                if (c.YogaTypeId == 1)
                {
                    grouppedClasses.HathaYoga.Add(c);
                }
                else
                {
                    if (c.YogaTypeId == 2)
                    {
                        grouppedClasses.VinyasaYoga.Add(c);
                    }
                    else
                    {
                        if (c.YogaTypeId == 3)
                        {
                            grouppedClasses.YinYoga.Add(c);
                        }
                    }
                }

            }

            return grouppedClasses;
        }
    }
}
