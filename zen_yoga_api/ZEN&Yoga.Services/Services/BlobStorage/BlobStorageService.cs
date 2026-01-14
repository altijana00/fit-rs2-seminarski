using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.BlobStorage;



namespace ZEN_Yoga.Services.Services.BlobStorage
{
    public class BlobStorageService : IBlobStorageService
    {
        private readonly AzureBlobStorageSettings _storageSettings;

        public BlobStorageService(IOptions<AzureBlobStorageSettings> options) 
        { 
            _storageSettings = options.Value;
        }

        public async Task<string> UploadFileAsync(IFormFile file, string containerName)
        {
            var container = new BlobContainerClient(_storageSettings.ConnectionString, containerName);
            await container.CreateIfNotExistsAsync(PublicAccessType.Blob);

            var fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);

            var blobClient = container.GetBlobClient(fileName);

            using (var stream = file.OpenReadStream()) 
            {
                await blobClient.UploadAsync(stream, overwrite:true);
            }

            return blobClient.Uri.ToString();
        }

        public async Task DeleteFileAsync(string fileUrl, string containerName)
        {
            var container = new BlobContainerClient(_storageSettings.ConnectionString, containerName);

            var fileName = Path.GetFileName(new Uri(fileUrl).AbsolutePath);

            var blobClient = container.GetBlobClient(fileName);

            await blobClient.DeleteIfExistsAsync();
        }
    }
}
