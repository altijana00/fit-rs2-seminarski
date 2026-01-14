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
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class GetStudioService : IGetStudioService
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;

        public GetStudioService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }
        public async Task<List<StudioResponse>> GetAll()
        {
            var studios = await _dbContext.Studios.ToListAsync();
            return _mapper.Map<List<StudioResponse>>(studios);
        }

        public async Task<List<StudioResponse>> GetStudiosQuery(StudioQuery studioQuery)
        {

            IQueryable<ZEN_Yoga.Models.Studio> studios = _dbContext.Studios.AsQueryable();

            if (!string.IsNullOrWhiteSpace(studioQuery.Search))
            {
                var search = studioQuery.Search.ToLower();

                studios = studios.Where(s =>
                    s.Name.ToLower().Contains(search) ||
                    s.Address!.ToLower().Contains(search) ||
                    s.ContactEmail!.ToLower().Contains(search) ||
                    s.ContactPhone!.Contains(search)

                );
            }

            if (studioQuery.CityId.HasValue)
            {
                studios = studios.Where(s => s.CityId == studioQuery.CityId);
            }

            var result = await studios.ToListAsync();
            return _mapper.Map<List<StudioResponse>>(result);
        }

        public async Task<List<StudioResponse>> GetByOwner(int ownerId)
        {
            var studios = await _dbContext.Studios.Where(s => s.OwnerId == ownerId).ToListAsync();
            return _mapper.Map<List<StudioResponse>>(studios);
        }

        public async Task<StudioResponse> GetByOwnerAndStudioName(int ownerId, string name)
        {
            var studio = await _dbContext.Studios.FirstOrDefaultAsync(s => s.OwnerId == ownerId && s.Name == name);
            return _mapper.Map<StudioResponse>(studio);
        }

        public async Task<StudioResponse> GetById(int id)
        {
            var studio = await _dbContext.Studios.FirstOrDefaultAsync(s => s.Id == id);

            return _mapper.Map<StudioResponse>(studio);
        }
    }
}
