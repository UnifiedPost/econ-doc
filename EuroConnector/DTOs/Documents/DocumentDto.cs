namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentDto
    {
        public Guid DocumentId { get; set; }
        public string? DocumentNo { get; set; }
        public string SenderEndpointId { get; set; } = default!;
        public string RecipientEndpointId { get; set; } = default!;
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string Status { get; set; } = default!;
        public string FolderName { get; set; } = default!;
    }
}
