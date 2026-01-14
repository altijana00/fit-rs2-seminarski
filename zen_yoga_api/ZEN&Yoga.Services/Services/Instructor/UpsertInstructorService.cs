using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Instructor;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_Yoga.Services.Services.Instructor
{
    public class UpsertInstructorService : IUpsertInstructorService<AddInstructor>
    {
        
        private readonly ZenYogaDbContext _dbContext;

        public UpsertInstructorService(ZenYogaDbContext dbContext)
        {
           
            _dbContext = dbContext;
        }
        public async Task<bool> Add(IGetUserService getUserService, IInstructorValidatorService instructorValidatorService, AddInstructor addInstructor, string email, int studioId)
        {
            var user = await getUserService.GetByEmail(email);

           await instructorValidatorService.ValidateEmail(email);
            
                var instructor = new Models.Instructor()
                {
                    Id = user.Id,
                    Biography = addInstructor.Biography,
                    Diplomas = addInstructor.Diplomas,
                    Certificates = addInstructor.Certificates,
                    StudioId = studioId
                };

                await _dbContext.Instructors.AddAsync(instructor);
                await _dbContext.SaveChangesAsync();

                return true;
            

            
        }

        public async Task Edit(EditInstructor editInstructor, int id)
        {
            var instructor = await _dbContext.Instructors.FirstOrDefaultAsync(i => i.Id == id);
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == id);

            if (user != null && instructor != null) 
            { 
                user.FirstName = editInstructor.FirstName;
                user.LastName = editInstructor.LastName;
                user.Email = editInstructor.Email;
                user.Gender = editInstructor.Gender;
                user.ProfileImageUrl = editInstructor.ProfileImageUrl;
                instructor.Biography = editInstructor.Biography;
                instructor.Certificates = editInstructor.Certificates;
                instructor.Diplomas = editInstructor.Diplomas;

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
