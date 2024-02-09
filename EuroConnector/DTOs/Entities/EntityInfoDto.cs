namespace EuroConnector.API.DTOs.Entities
{
    public class EntityInfoDto
    {
        public IEnumerable<EntityInfoObj> Entities { get; set; } = new List<EntityInfoObj>();
    }

    public class EntityInfoObj
    {
        public EntityFullDto EntityInfo { get; set; } = new();
        public UserInfoDto UserInfo { get; set; } = new();
        public EntityCreateResponseObj.PeppolServiceDto PeppolService { get; set; } = new();

        public class UserInfoDto
        {
            public string UserName { get; set; } = default!;
            public string? FirstName { get; set; }
            public string? LastName { get; set; }
            public string EmailAddress { get; set; } = default!;
            public bool IsEnabled { get; set; }
            public DateTime CreatedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
        }
    }
}
