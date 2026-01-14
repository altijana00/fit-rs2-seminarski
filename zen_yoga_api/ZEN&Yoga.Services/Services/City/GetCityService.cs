using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Services.Interfaces.City;

namespace ZEN_Yoga.Services.Services.City
{
    public class GetCityService : IGetCityService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;


        public GetCityService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }

        public async Task<List<CityResponse>> GetAll()
        {
            var cities = await _dbContext.Cities.ToListAsync();

            return _mapper.Map<List<CityResponse>>(cities);

        }

        public async Task<CityResponse> GetById(int id)
        {
            var city = await _dbContext.Cities.FirstOrDefaultAsync(c => c.Id == id);

            return _mapper.Map<CityResponse>(city);
        }
    }
}
