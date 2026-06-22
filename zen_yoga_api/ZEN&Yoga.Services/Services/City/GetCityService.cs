using AutoMapper;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Models.SearchObjects;

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
            var cities = await _dbContext.Cities.AsNoTracking().ToListAsync();

            return _mapper.Map<List<CityResponse>>(cities).OrderByDescending(c => c.Id).ToList();

        }

        public async Task<CityResponse> GetById(int id)
        {
            var city = await _dbContext.Cities.AsNoTracking().FirstOrDefaultAsync(c => c.Id == id);

            return _mapper.Map<CityResponse>(city);
        }


        public async Task<List<CityResponse>> GetCitiesQuery(CityQuery cityQuery)
        {
            var query = _dbContext.Cities.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(cityQuery.Search))
            {
                var search = cityQuery.Search.ToLower();
                query = query.Where(u => u.Name.ToLower().Contains(search));
            }

            return _mapper.Map<List<CityResponse>>(await query.ToListAsync()).OrderByDescending(c => c.Id).ToList();
        }


    }
}
