using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class DeleteStudioGalleryPhotoService : IDeleteStudioGalleryPhotoService
    {
        private readonly ZenYogaDbContext _dbContext;

        public DeleteStudioGalleryPhotoService(ZenYogaDbContext dbContext) 
        {
            _dbContext = dbContext;
        }

        public async Task<bool> DeleteStudioGalleryPhoto (string photoURL, int studioId)
        {
            var galleryPhoto = await _dbContext.StudioGalleries.FirstOrDefaultAsync(x => x.PhotoUrl == photoURL && x.StudioId == studioId);

            if (galleryPhoto == null)
            {
                return false;
            }

            _dbContext.StudioGalleries.Remove(galleryPhoto);
            await _dbContext.SaveChangesAsync();
            return true;
        }
    }
}
