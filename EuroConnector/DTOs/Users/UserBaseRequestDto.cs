using Swashbuckle.AspNetCore.Annotations;
using System.ComponentModel.DataAnnotations;

namespace EuroConnector.API.DTOs.Users
{
    public class UserBaseRequestDto
    {

        [Required]
        [StringLength(100)]
        public string UserName { get; set; } = default!;
        [Required]
        [EmailAddress]
        [StringLength(500)]
        public string EmailAddress { get; set; } = default!;
        public string FirstName { get; set; } = default!;
        public string LastName { get; set; } = default!;
    }
}
