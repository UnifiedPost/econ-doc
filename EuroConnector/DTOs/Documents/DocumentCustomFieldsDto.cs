using System.Text.Json.Serialization;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentCustomFieldsDto: DocumentDetailsDto
    {
        [JsonPropertyOrder(order: 999)]
        public List<CustomField> CustomFields { get; set; } = default!;
    }

    public class CustomField
    {
        public string Field { get; set; }
        public string Value { get; set; }
    }
}
