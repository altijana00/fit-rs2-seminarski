using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;
using ZEN_Yoga.Services.Interfaces.YogaType;

namespace ZEN_Yoga.Services.Services.YogaType
{
    public class UpsertYogaTypeService : IUpsertYogaTypeService<AddYogaType>
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;


        public UpsertYogaTypeService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }

        public async Task Add(AddYogaType addYogaType)
        {
            var yogaType = _mapper.Map<Models.YogaType>(addYogaType);

            await _dbContext.YogaTypes.AddAsync(yogaType);

            await _dbContext.SaveChangesAsync();
        }

        public async Task Edit(EditYogaType editYogaType, int id)
        {
            var yogaType = await _dbContext.YogaTypes.FirstOrDefaultAsync(u => u.Id == id);

            if (yogaType != null)
            {
                _mapper.Map(editYogaType, yogaType);

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
