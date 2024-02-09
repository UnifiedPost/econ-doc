namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentIdExtDto
    {
        public DocumentIdExtDto()
        {

        }
        public DocumentIdExtDto(string documentIdExt)
        {
            if (!string.IsNullOrEmpty(documentIdExt))
            {
                InboundId = documentIdExt.Split(":")[0];
                FileId = documentIdExt.Split(":")[1];
                DocumentId = documentIdExt.Split(":")[2];
            }
        }
        public string? InboundId { get; set; }
        public string? FileId { get; set; }
        public string? DocumentId { get; set; }

        public override string ToString()
        {
            return $"{InboundId}:{FileId}:{DocumentId}";
        }
    }
}
