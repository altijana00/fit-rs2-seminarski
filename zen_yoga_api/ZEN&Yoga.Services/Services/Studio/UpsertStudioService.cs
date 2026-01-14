using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class UpsertStudioService : IUpsertStudioService<AddStudio>
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;
       

        public UpsertStudioService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            
        }

        public async Task Add(AddStudio addStudio)
        {
            var studio = _mapper.Map<Models.Studio>(addStudio);

            await _dbContext.Studios.AddAsync(studio);

            await _dbContext.SaveChangesAsync();
        }

        public async Task Edit(EditStudio editStudio, int id)
        {
            var studio = await _dbContext.Studios.FirstOrDefaultAsync(u => u.Id == id);

            if (studio != null)
            {
                _mapper.Map(editStudio, studio);

                await _dbContext.SaveChangesAsync();
            }
        }

       
    }
}
