namespace ZEN_Yoga.Models.Responses
{
    public class YogaTypeResponse
    {
        public int Id { get; set; }
       
        public required string Name { get; set; }
        
        public string? Description { get; set; }
    }
}
