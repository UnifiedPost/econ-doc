using EuroConnector.API.DTOs.Tokens;
using EuroConnector.API.DTOs.Users;
using ILogger = Serilog.ILogger;

namespace EuroConnector.API.Services
{
    public class TokenService : ITokenService
    {
        private readonly IConfiguration _config;
        private readonly ILogger _logger;
        public TokenService(IConfiguration config, ILogger logger)
        {
            _config = config;
            _logger = logger;
        }

        public TokenResponseDto GenerateToken(UserDto user)
        {
            throw new NotImplementedException();
        }
    }
}
