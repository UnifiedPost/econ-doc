using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.PeppolServices
{
    public class PeppolServiceBaseDto
    {
        public PeppolEndpointSchemes EndpointSchemeId { get; set; }
        public string ParticipantId { get; set; } = default!;
        public string ParticipantIdentifierSchemeId { get; set; } = default!;
        public string? CompanyIdExt { get; set; }
        public string? StatusExt { get; set; }
    }
}
