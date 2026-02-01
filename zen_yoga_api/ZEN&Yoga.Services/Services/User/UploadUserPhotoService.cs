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
    public class UploadUserPhotoService : IUploadUserPhotoService
    {
        private readonly IBlobStorageService _blobStorageService;
        private readonly AzureBlobStorageSettings _blobSettings;
        private readonly ZenYogaDbContext _dbContext;

        public UploadUserPhotoService(IBlobStorageService blobStorageService, IOptions<AzureBlobStorageSettings> blobSettings, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _blobStorageService = blobStorageService;
            _blobSettings = blobSettings.Value;
        }

        public async Task<string> UploadUserPhoto(IFormFile file)
        {
            return await _blobStorageService.UploadFileAsync(file, _blobSettings.UserPhotosContainer);
        }

        public async Task EditUserPhoto(string photoURL, int userId)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == userId);
            if (user != null)
            {
                user.ProfileImageUrl = photoURL;

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
