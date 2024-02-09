using EuroConnector.Data.Models;
using System.Text.Json.Serialization;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentDetailsDto
    {
        public Guid DocumentId { get; set; }
        public string? DocumentNo { get; set; }
        public DocStandard DocumentStandard { get; set; }
        public DocType? DocumentType { get; set; }
        public string SenderEndpointId { get; set; } = default!;
        public string SenderName { get; set; } = default!;
        public string SenderEntityCode { get; set; } = default!;
        public string SenderVatNumber { get; set; } = default!;
        public string RecipientEndpointId { get; set; } = default!;
        public string RecipientName { get; set; } = default!;
        public string RecipientEntityCode { get; set; } = default!;
        public string RecipientVatNumber { get; set; } = default!;
        public string? PeppolMessageId { get; set; }
        public string? PocumentReference { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string Status { get; set; } = default!;
        public string StatusNotes { get; set; } = default!;
        public string FolderName { get; set; } = default!;
    }
}