using EuroConnector.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentSearchRequest
    {
        public Guid? DocumentId { get; set; }
        public string? DocumentNo { get; set; }
        public DocType? DocumentType { get; set; }
        public string? SenderEndpointId { get; set; }
        public string? SenderName { get; set; }
        public string? SenderEntityCode { get; set; }
        public string? SenderVatNumber { get; set; }
        public string? RecipientEndpointId { get; set; }
        public string? RecipientName { get; set; }
        public string? RecipientEntityCode { get; set; }
        public string? RecipientVatNumber { get; set; }
        public string? DocumentReference { get; set; }
        public DateTime[]? CreatedBetween { get; set; }
        public DateTime[]? UpdatedBetween { get; set; }
        public DocStatusType? Status { get; set; }
        [Required]
        public string FolderName { get; set; } = default!;
        public int RecordsCountLimit { get; set; } = 100;

    }
}
