namespace EuroConnector.API.DTOs.PeppolServices.PeppolAccessPoint
{
    public class PeppolUserCreateResponseDto
    {
        public Guid PapUserId { get; set; }
        public string UserName { get; set; } = default!;
        public string SecretKey { get; set; } = default!;
    }
}
