namespace ZEN_Yoga.Models.Responses
{
    public  class PaymentResponse
    {
        public int UserId { get; set; }

        public int StudioId { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public required string Status { get; set; }

    }
}
