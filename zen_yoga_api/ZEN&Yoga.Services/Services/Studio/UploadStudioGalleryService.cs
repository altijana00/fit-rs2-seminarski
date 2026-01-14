using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.BlobStorage;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class UploadStudioGalleryService : IUploadStudioGalleryService
    {
        private readonly IBlobStorageService _blobStorageService;
        private readonly AzureBlobStorageSettings _blobSettings;
        private readonly ZenYogaDbContext _dbContext;

        public UploadStudioGalleryService(IBlobStorageService blobStorageService, IOptions<AzureBlobStorageSettings> blobSettings, ZenYogaDbContext dbContext) 
        {
            
            _blobStorageService = blobStorageService;
            _blobSettings = blobSettings.Value;
            _dbContext = dbContext;
        }

        public async Task UploadStudioGalleryPhoto (int studioId, IFormFile file)
        {
            var galleryCount = await _dbContext.StudioGalleries.CountAsync(g => g.StudioId == studioId);
            if (galleryCount >= 5)
            {
                throw new InvalidOperationException("Maximum number of gallery photos reached.");
            }


            var photoUrl = await _blobStorageService.UploadFileAsync(file, _blobSettings.StudioPhotosContainer);


            var galleryPhoto = new StudioGallery
            {
                StudioId = studioId,
                PhotoUrl = photoUrl
            };

            _dbContext.StudioGalleries.Add(galleryPhoto);
            await _dbContext.SaveChangesAsync();
        }
    }
}
