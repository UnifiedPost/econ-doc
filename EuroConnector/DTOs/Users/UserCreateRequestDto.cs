
using EuroConnector.Data.Models;
using Swashbuckle.AspNetCore.Annotations;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace EuroConnector.API.DTOs.Users
{
    public class UserCreateRequestDto: UserBaseRequestDto
    {
        [SwaggerSchema(ReadOnly = true)]
        public Guid? CompanyId { get; set; }
        [SwaggerSchema(ReadOnly = true)]
        public Guid? ErpProviderId { get; set; }
        [SwaggerSchema(ReadOnly = true)]
        public bool IsEnabled { get; set; } = false;
        [NotAdminRoleAttribute(ErrorMessage = "The RoleName canot be 'Admin'")]
        public ICollection<RolesType> RoleNames { get; set; } = new List<RolesType>();
    }

    public class NotAdminRoleAttribute : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            return (value as ICollection<RolesType>).Any(s => s != RolesType.Admin);
        }
    }
}
