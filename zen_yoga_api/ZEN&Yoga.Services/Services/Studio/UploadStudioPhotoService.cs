using AutoMapper;
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
using ZEN_Yoga.Services.Services.BlobStorage;


namespace ZEN_Yoga.Services.Services.Studio
{
    public class UploadStudioPhotoService : IUploadStudioPhotoService
    {
        private readonly IBlobStorageService _blobStorageService;
        private readonly AzureBlobStorageSettings _blobSettings;
        private readonly ZenYogaDbContext _dbContext;

        public UploadStudioPhotoService(IBlobStorageService blobStorageService, IOptions<AzureBlobStorageSettings> blobSettings, ZenYogaDbContext dbContext)
        {
           _dbContext = dbContext;
            _blobStorageService = blobStorageService;
            _blobSettings = blobSettings.Value;
        }

        public async Task<string> UploadStudioPhoto(IFormFile file)
        {
            return await _blobStorageService.UploadFileAsync(file, _blobSettings.StudioPhotosContainer);
        }

        public async Task EditStudioPhoto(string photoURL, int studioId)
        {
            var studio = await _dbContext.Studios.FirstOrDefaultAsync(s => s.Id == studioId);
            if (studio != null) {
                studio.ProfileImageUrl = photoURL;

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
