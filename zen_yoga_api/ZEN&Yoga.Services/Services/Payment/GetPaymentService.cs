using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
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

        public async Task<List<PaymentResponse>> GetAll()
        {
            var payments = await _dbContext.Payments.AsNoTracking().ToListAsync();
            return _mapper.Map<List<PaymentResponse>>(payments).OrderByDescending(p => p.Id).ToList();
        }


        public async Task<decimal> GetPaymentsTotal()
        {
            return await _dbContext.Payments.AsNoTracking().SumAsync(p => p.Amount);

        }

        public async Task<List<PaymentResponse>> GetPaymentsQuery(PaymentQuery paymentQuery)
        {
            IQueryable<ZEN_Yoga.Models.Payment> payments = _dbContext.Payments.AsNoTracking();

            if (!string.IsNullOrWhiteSpace(paymentQuery.Search))
            {
                var search = paymentQuery.Search.ToLower();

                payments = payments.Where(u =>
                    u.Amount.ToString().Contains(search)

                );
            }


            var result = await payments.ToListAsync();
            return _mapper.Map<List<PaymentResponse>>(result).OrderByDescending(c => c.Id).ToList();
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
