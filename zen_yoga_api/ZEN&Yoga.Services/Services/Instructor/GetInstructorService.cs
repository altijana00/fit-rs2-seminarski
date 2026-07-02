using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
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

        private IQueryable<InstructorResponse> GetBaseInstructorQuery()
        {
            return _dbContext.Users.AsNoTracking()
                .Where(user => user.RoleId == 3)
                .Join(
                    _dbContext.Instructors.AsNoTracking(),
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
                        ProfileImageUrl = user.ProfileImageUrl,
                        RoleId = user.RoleId,
                        CityId = user.CityId,
                        Biography = instructor.Biography,
                        Diplomas = instructor.Diplomas,
                        Certificates = instructor.Certificates,
                        StudioId = instructor.StudioId
                    });
        }

        public async Task<PagedResponse<InstructorResponse>> GetAll(PagedRequest request)
        {
            var query = GetBaseInstructorQuery()
        .OrderByDescending(x => x.Id);

            var totalCount = await query.CountAsync();

            var items = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<InstructorResponse>
            {
                Items = items,
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<InstructorResponse?> GetByEmail(string email)
        {
            return await GetBaseInstructorQuery()
                .FirstOrDefaultAsync(x => x.Email == email);
        }

        public async Task<InstructorResponse?> GetById(int id)
        {
            return await GetBaseInstructorQuery()!
                .FirstOrDefaultAsync(x => x.Id == id);
        }

        public async Task<List<InstructorResponse>> GetByStudioId(int studioId)
        {
            return await GetBaseInstructorQuery()
                .Where(x => x.StudioId == studioId)
                .ToListAsync();
        }
    }
}