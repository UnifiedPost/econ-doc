namespace EuroConnector.API.DTOs.Tokens
{
    public class TokenRequestDto
    {
        public string UserName { get; set; } = default!;
        public string SecretKey { get; set; } = default!;
    }
}
