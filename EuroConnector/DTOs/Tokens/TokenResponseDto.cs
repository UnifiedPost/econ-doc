namespace EuroConnector.API.DTOs.Tokens
{
    public class TokenResponseDto
    {
        public string AccessToken { get; set; } = default!;
        public DateTime AccessTokenExpiresUtc { get; set; } = default!;
        public string RefreshToken { get; set; } = default!;
        public DateTime RefreshTokenExpiresUtc { get; set; } = default!;
    }
}
