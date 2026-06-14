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
            var payments = await _dbContext.Payments.ToListAsync();
            return _mapper.Map<List<PaymentResponse>>(payments);
        }

        public async Task<decimal> GetPaymentsTotal()
        {
            var payments = await _dbContext.Payments.ToListAsync();
            decimal total = 0;

            foreach (var payment in payments) 
            {
                total += payment.Amount;
            
            }

            return total;

        }

        public async Task<List<PaymentResponse>> GetPaymentsQuery(PaymentQuery paymentQuery)
        {
            IQueryable<ZEN_Yoga.Models.Payment> payments = _dbContext.Payments.AsQueryable();

            if (!string.IsNullOrWhiteSpace(paymentQuery.Search))
            {
                var search = paymentQuery.Search.ToLower();

                payments = payments.Where(u =>
                    u.Amount.ToString().Contains(search)

                );
            }


            var result = await payments.ToListAsync();
            return _mapper.Map<List<PaymentResponse>>(result);
        }

        public async Task<PaymentResponse> GetById(int paymentId)
        {
            var payment = await _dbContext.Payments.FirstOrDefaultAsync(p => p.Id == paymentId);
            return _mapper.Map<PaymentResponse>(payment);
        }

        public async Task<List<PaymentResponse>> GetUserPayments(int userId)
        {
            var payments = await _dbContext.Payments.Where(p => p.UserId == userId).ToListAsync();
            return _mapper.Map<List<PaymentResponse>>(payments);
        }

        public async Task<List<PaymentResponse>> GetStudioPayments(int studioId)
        {
            var payments = await _dbContext.Payments.Where(p => p.StudioId == studioId).ToListAsync();
            return _mapper.Map<List<PaymentResponse>>(payments);
        }




    }
}
