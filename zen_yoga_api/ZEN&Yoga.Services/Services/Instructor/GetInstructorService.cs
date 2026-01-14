using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Instructor;

namespace ZEN_Yoga.Services.Services.Instructor
{
    public class GetInstructorService : IGetInstructorService
    {
        private readonly ZenYogaDbContext _dbContext;

        public GetInstructorService(ZenYogaDbContext dbContext)
        {
           
            _dbContext = dbContext;
        }
        public async Task<List<InstructorResponse>> GetAll()
        {
            return await _dbContext.Users
           .Where(user => user.RoleId == 3)
            .Join(
               _dbContext.Instructors,
               user => user.Id,
               instructor => instructor.Id,
               (user, instructor) => new InstructorResponse
               {
                   Id = user.Id,
                   FirstName = user.FirstName,
                   LastName = user.LastName,
                   Gender = user.Gender,
                   DateOfBirth = user.DateOfBirth,
                   Email = user.Email,
                   RoleId = user.RoleId,
                   CityId = user.CityId,
                   Biography = instructor.Biography,
                   Certificates = instructor.Certificates,
                   Diplomas = instructor.Diplomas,
                   StudioId = instructor.StudioId
               })
           .ToListAsync();
        }

        public async Task<InstructorResponse> GetByEmail(string email)
        {
            var instructors = await GetAll();

            return instructors.FirstOrDefault(i => i.Email == email);
        }

        public async Task<InstructorResponse> GetById(int id)
        {
            var instructors = await GetAll();

            return instructors.FirstOrDefault(i => i.Id == id);
        }

        public async Task<List<InstructorResponse>> GetByStudioId(int studioId)
        {
            var instructors = await GetAll();

            return instructors.Where(i => i.StudioId == studioId).ToList();
        }
    }
}
