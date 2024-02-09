using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.Entities
{
    public class EntityLookupResponseDto
    {
        public PeppolServiceDto PeppolService { get; set; } = new();
        public byte[] CustomInformation { get; set; } = default!;

        public class PeppolServiceDto
        {
            public string? AccessPoint { get; set; }
            public string EndpointSchemeId { get; set; } = default!;
            public string ParticipantId { get; set; } = default!;
            public string ParticipantIdentifierSchemeId { get; set; } = default!;
            public string Status { get; set; } = default!;
            public bool IsEnabled { get; set; } = default!;
            public string? Comment { get; set; }
            public string? CreatedAt { get; set; }
            public string? UpdatedAt { get; set; }
        }
    }
}
