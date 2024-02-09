using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentContentResponse
    {
        public Guid DocumentId { get; set; }
        public DocStandard DocumentStandard { get; set; }
        public string DocumentContent { get; set; } = default!;
    }
}
