using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Payment;

namespace ZEN_Yoga.Services.Services.Payment
{
    public class GetPaymentService : IGetPaymentService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetPaymentService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task<PagedResponse<PaymentResponse>> GetAll(PagedRequest request)
        {
            var query = _dbContext.Payments
                                  .AsNoTracking()
                                  .OrderByDescending(r => r.Id);

            var totalCount = await query.CountAsync();

            var result = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<PaymentResponse>
            {
                Items = _mapper.Map<List<PaymentResponse>>(result),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }


        public async Task<decimal> GetPaymentsTotal()
        {
            return await _dbContext.Payments.AsNoTracking().SumAsync(p => p.Amount);

        }

        public async Task<PagedResponse<PaymentResponse>> GetPaymentsQuery(PaymentQuery paymentQuery, PagedRequest request)
        {
            IQueryable<ZEN_Yoga.Models.Payment> query = _dbContext.Payments.AsNoTracking();

            if (!string.IsNullOrWhiteSpace(paymentQuery.Search))
            {
                var search = paymentQuery.Search.ToLower();

                query = query.Where(u =>
                    u.Amount.ToString().Contains(search)

                );
            }

            query = query.OrderByDescending(c => c.Id);
            var totalCount = await query.CountAsync();

            var results = await query
               .Skip((request.Page - 1) * request.PageSize)
               .Take(request.PageSize)
               .ToListAsync();


            return new PagedResponse<PaymentResponse>
            {
                Items = _mapper.Map<List<PaymentResponse>>(results),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };


        }

        public async Task<PaymentResponse> GetById(int paymentId)
        {
            var payment = await _dbContext.Payments.AsNoTracking().FirstOrDefaultAsync(p => p.Id == paymentId);
            return _mapper.Map<PaymentResponse>(payment);
        }

        public async Task<List<PaymentResponse>> GetUserPayments(int userId)
        {
            var payments = await _dbContext.Payments.AsNoTracking().Where(p => p.UserId == userId).ToListAsync();
            return _mapper.Map<List<PaymentResponse>>(payments).OrderByDescending(p => p.Id).ToList();
        }


        public async Task<List<PaymentResponse>> GetPaymentsOfOwnerStudios(int ownerId)
        {
            var payments = await _dbContext.Payments.AsNoTracking()
                .Where(p => _dbContext.Studios
                    .Any(s => s.Id == p.StudioId && s.OwnerId == ownerId))
                .ToListAsync();

            return _mapper.Map<List<PaymentResponse>>(payments).OrderByDescending(p => p.Id).ToList();
        }
    }
}
