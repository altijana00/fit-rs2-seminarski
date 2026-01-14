using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.Studio
{
    public interface IUploadStudioPhotoService
    {
        Task<string> UploadStudioPhoto(IFormFile file);
        Task EditStudioPhoto(string photoURL, int studioId);
    }
}
