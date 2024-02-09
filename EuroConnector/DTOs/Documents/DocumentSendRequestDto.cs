using EuroConnector.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentSendRequestDto
    {
        public DocStandard DocumentStandard { get; set; } = DocStandard.BIS3;
        [Required]
        public string DocumentContent { get; set; } = default!;
    }
}
