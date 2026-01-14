using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.YogaType;

namespace ZEN_Yoga.Services.Services.Class
{
    public class UpsertClassService : IUpsertClassService<AddClass>
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;

        public UpsertClassService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _mapper = mapper;
            _dbContext = dbContext;
        }


        public async Task Add(AddClass addClass, int instructorId, IYogaTypeValidatorService yogaTypeValidatorService)
        {
            var instructor = await _dbContext.Instructors.FirstOrDefaultAsync(i => i.Id == instructorId);

            var classRes = _mapper.Map<Models.Class>(addClass);

            classRes.InstructorId = instructorId;
            classRes.StudioId = instructor!.StudioId;

            await yogaTypeValidatorService.ValidateYogaTypeId(classRes.YogaTypeId);

            await _dbContext.Classes.AddAsync(classRes);

            await _dbContext.SaveChangesAsync();
        }

        public async Task Edit(EditClass editClass, int id)
        {
            var classRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == id);

            if (classRes != null)
            {

                classRes.Name = editClass.Name;
                classRes.Description = editClass.Description;
                classRes.Location = editClass.Location;
                classRes.StartDate = editClass.StartDate;
                classRes.EndDate = editClass.EndDate;
                classRes.MaxParticipants = editClass.MaxParticipants;

                await _dbContext.SaveChangesAsync();


            }
        }
    }
}
