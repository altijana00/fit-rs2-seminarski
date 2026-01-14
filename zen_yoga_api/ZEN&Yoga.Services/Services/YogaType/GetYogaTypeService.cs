using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.YogaType;

namespace ZEN_Yoga.Services.Services.YogaType
{
    public class GetYogaTypeService : IGetYogaTypeService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetYogaTypeService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task<List<YogaTypeResponse>> GetAll()
        {
            var types = await _dbContext.YogaTypes.ToListAsync();

            return _mapper.Map<List<YogaTypeResponse>>(types);
        }

        public async Task<YogaTypeResponse> GetById(int id)
        {
            var type = await _dbContext.YogaTypes.FirstOrDefaultAsync(t => t.Id == id);

            return _mapper.Map<YogaTypeResponse>(type);
        }
    }
}
