using EuroConnector.Data.Models;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentValidationRequestDto
    {
        public DocStandard DocumentStandard { get; set; } = DocStandard.BIS3;
        [Required]
        public string DocumentContent { get; set; } = default!;
    }
}
