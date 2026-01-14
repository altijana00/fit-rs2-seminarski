using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_Yoga.Services.Services.User
{
    public class UserValidatorService : IUserValidatorService
    {
        
        private readonly ZenYogaDbContext _dbContext;

        public UserValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }
        public async Task<bool> ValidateEmail(string email)
        {

            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Email == email);

            if(user!=null)
            {
                throw new UserAlreadyExistsException("User with this email already exists!");
            }

            return true;
        }

        public async Task<bool> ValidateUserId(int id)
        {

            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
            {
                throw new UserNotFoundException("There is no user with this Id!");
            }

            return true;
        }


    }
}
