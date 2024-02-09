using EuroConnector.Data.Models;
using System.ComponentModel;
using System.Text.Json.Serialization;

namespace EuroConnector.API.DTOs.PeppolServices
{
    public class PeppolServiceCreateDto
    {
        [JsonIgnore(Condition = JsonIgnoreCondition.Always)]
        public string AccessPoint { get; set; } = "crossinx";
        public PeppolEndpointSchemes EndpointSchemeId { get; set; }
    }
}
