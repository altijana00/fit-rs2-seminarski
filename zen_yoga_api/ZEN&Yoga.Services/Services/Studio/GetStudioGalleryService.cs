using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class GetStudioGalleryService : IGetStudioGalleryService
    {
        private readonly ZenYogaDbContext _dbContext;
        public GetStudioGalleryService(ZenYogaDbContext dbContext) 
        { 
            _dbContext = dbContext;
        }


        public async Task<List<string>> GetStudioGalleryPhotos(int studioId)
        {
            return await _dbContext.StudioGalleries
                        .Where(g => g.StudioId == studioId)
                        .Select(g => g.PhotoUrl!)
                        .ToListAsync();
        }
    }
}
