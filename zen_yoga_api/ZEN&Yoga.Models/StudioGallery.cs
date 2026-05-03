using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEN_Yoga.Models
{
    [Table("StudioGalleries")]
    public class StudioGallery
    {
        [Key]
        [Required]
        public int GalleryId { get; set; }

        [ForeignKey(nameof(Studio))]
        [Required(ErrorMessage = "Studio ID is required.")]
        public int? StudioId { get; set; }
        public Studio? Studio { get; set; }

        public string? PhotoUrl { get; set; }

       
    }
}
