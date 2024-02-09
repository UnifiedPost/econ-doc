using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentRecieveResponse
    {
        public List<DocumentRecieveDto> Documents { get; set; } = default!;
    }

    public class DocumentRecieveDto
    {
        public Guid DocumentId { get; set; }
        public DocStandard DocumentStandard { get; set; }
        public DocType? DocumentType { get; set; }
        public string Status { get; set; } = default!;
        public string FolderName { get; set; } = default!;
    }
}
