using EuroConnector.API.DTOs.Tokens;
using EuroConnector.API.DTOs.Users;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.Data.Models;
using System.Net.Http.Headers;
using System.Security.Claims;

namespace EuroConnector.API.Services
{
    public interface ITokenService
    {
        TokenResponseDto GenerateToken(UserDto user);
        //public ClaimsPrincipal GetPrincipalFromToken(string token);
    }
}
