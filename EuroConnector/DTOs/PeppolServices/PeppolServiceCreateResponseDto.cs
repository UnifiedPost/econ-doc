using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.DTOs.PeppolServices.PeppolAccessPoint;
using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.PeppolServices
{
    public class PeppolServiceCreateResponseDto
    {
        public Guid PeppolServiceId { get; set; }
        public PeppolEndpointSchemes EndpointSchemeId { get; set; }
        public bool IsEnabled { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public CompanyInfoDto Entity { get; set; } = new();
    }
}
