using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.Studio
{
    public interface IUploadUserPhotoService
    {
        Task<string> UploadUserPhoto(IFormFile file);
        Task EditUserPhoto(string photoURL, int userId);
    }
}
