using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentsSendResponseDto
    {
        public List<DocumentSendInfoDto> Documents { get; set; } = default!;
    }
    public class DocumentSendInfoDto
    {
        public Guid DocumentId { get; set; } = default!;
        public DocStandard DocumentStandard { get; set; }
        public DocType? DocumentType { get; set; }
        public DocStatusType Status { get; set; }
        public string FolderName { get; set; } = default!;
    }

    public class DocumentSendInfoExtDto: DocumentSendInfoDto
    {
        public string CompanyIdExt { get; set; } = default!;
    }
}
