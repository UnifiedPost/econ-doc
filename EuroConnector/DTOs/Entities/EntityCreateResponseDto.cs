using System.Runtime.Serialization;

namespace EuroConnector.API.DTOs.Entities
{
	public class EntityCreateResponseDto
	{
		public IEnumerable<EntityCreateResponseObj> Entities { get; set; } = default!;
	}

	public class EntityCreateResponseObj
	{
		[DataMember(Order = 3)]
		public UserInfoDto UserInfo { get; set; } = new();
		[DataMember(Order = 2)]
		public PeppolServiceDto PeppolService { get; set; } = new();
		[DataMember(Order = 1)]
		public EntityDto EntityInfo { get; set; } = new();

		public class UserInfoDto
		{
			public string UserName { get; set; } = default!;
			public string? FirstName { get; set; }
			public string? LastName { get; set; }
			public string SecretKey { get; set; } = default!;
			public string EmailAddress { get; set; } = default!;
			public bool IsEnabled { get; set; }
			public DateTime CreatedAt { get; set; }
			public DateTime UpdatedAt { get; set; }
		}

		public class PeppolServiceDto
		{
			public string AccessPoint { get; set; } = default!;
			public string EndpointSchemeId { get; set; } = default!;
			public string ParticipantId { get; set; } = default!;
			public string ParticipantIdentifierSchemeId { get; set; } = default!;
			public string Status { get; set; } = default!;
			public bool IsEnabled { get; set; } = false;
			public DateTime CreatedAt { get; set; }
			public DateTime UpdatedAt { get; set; }
		}
		public class EntityDto
		{
			public Guid EntityId { get; set; }
			public string EntityCode { get; set; } = default!;
			public string? VatNumber { get; set; }
			public string EntityName { get; set; } = default!;
			public string EmailAddress { get; set; } = default!;
			public string? PhoneNumber { get; set; } = default!;
			public string? Street { get; set; }
			public string? Locality { get; set; }
			public string? Municipality { get; set; }
			public string? PostalCode { get; set; }
			public string CountryCode { get; set; } = default!;
			public bool IsEnabled { get; set; }
			public DateTime CreatedAt { get; set; }
			public DateTime UpdatedAt { get; set; }
		}
	}
}
