using EuroConnector.API.DTOs.Entities;
using EuroConnector.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace EuroConnector.API.DTOs.PeppolServices
{
    public class PeppolServiceDto: PeppolServiceFullDto
    {
        public CompanyInfoDto Entity { get; set; } = new();
    }
}
