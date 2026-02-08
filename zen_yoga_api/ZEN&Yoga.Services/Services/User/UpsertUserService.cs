using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_Yoga.Services.Services.User
{
    public class UpsertUserService : IUpsertUserService<RegisterUser>
    {

        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;


        public UpsertUserService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _mapper = mapper;
            _dbContext = dbContext;

        }

        public async Task Add(IUserValidatorService userValidatorService, IRoleValidatorService roleValidatorService, ICityValidatorService cityValidatorService, RegisterUser registerUser)
        {
            var user = _mapper.Map<Models.User>(registerUser);

            var hashedPassword = PasswordHelpers.HashPassword(registerUser.Password);


            user.PasswordHash = hashedPassword.Hash;
            user.PasswordSalt = hashedPassword.Salt;


            await userValidatorService.ValidateEmail(registerUser.Email);
            await roleValidatorService.ValidateRoleId(registerUser.RoleId);
            await cityValidatorService.ValidateCity(registerUser.CityId);


            await _dbContext.Users.AddAsync(user);

            await _dbContext.SaveChangesAsync();


        }

        public async Task Edit(EditUser editUser, int id)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == id);

            if (user != null)
            {
                _mapper.Map(editUser, user);

                await _dbContext.SaveChangesAsync();
            }

        }

        public async Task<string> UpdateUserPassword(UpdateUserPassword updateUserPassword)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Id == updateUserPassword.UserId);

            if (user != null)
            {

                var newPasswordHashed = PasswordHelpers.HashPassword(updateUserPassword.NewPassword);

                if (PasswordHelpers.HashPassword(updateUserPassword.OldPassword).Hash != user.PasswordHash) return "Incorrect old password";
                if (newPasswordHashed.Hash == user.PasswordHash) return "New password cannot be the same as the old";


                user.PasswordHash = newPasswordHashed.Hash;
                user.PasswordSalt = newPasswordHashed.Salt;

                await _dbContext.SaveChangesAsync();


                return "Ok";
            }


            return "Error";

        }
    }
}
