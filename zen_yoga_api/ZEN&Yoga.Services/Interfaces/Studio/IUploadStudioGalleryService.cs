using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.Studio
{
    public interface IUploadStudioGalleryService
    {
        Task UploadStudioGalleryPhoto(int studioId, IFormFile file);
    }
}
