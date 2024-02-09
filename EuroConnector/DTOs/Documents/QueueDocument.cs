namespace EuroConnector.API.DTOs.Documents
{
    public class QueueDocument
    {
        public Guid DocumentId { get; set; } = default!;
        public string CompanyIdExt { get; set; } = default!;
        public DocumentSendRequestDto Request { get; set; } = default!;
        public Guid UserId { get; set; }
    }
}
