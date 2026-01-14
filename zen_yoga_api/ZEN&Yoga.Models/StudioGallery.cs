using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
