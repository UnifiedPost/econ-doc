using EuroConnector.API.DTOs.Tokens;
using EuroConnector.API.DTOs.Users;
using EuroConnector.API.Infrastructure.Extensions;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.Services;
using EuroConnector.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using System.Security.Claims;

namespace EuroConnector.API.Controllers
{
    [ApiController]
    [Route("api/public/v{version:apiVersion}/[controller]")]
    [ApiVersion("1.0")]
    public class AuthorizationController : ControllerBase
    {
        private readonly ITokenService _tokenService;
        private readonly IUserService _userService;

        public AuthorizationController(ITokenService tokenService, IUserService userManagerService)
        {
            _tokenService = tokenService;
            _userService = userManagerService;
        }

        [HttpPost]
        [ProducesResponseType(typeof(TokenResponseDto), 200)]
        [ProducesResponseType(typeof(string), 401)]
        [Route("token-create")]
        [AllowAnonymous]
        [SwaggerOperation(Summary = "Creates new access token")]
        public async Task<IActionResult> CreateToken([FromBody]TokenRequestDto tokenRequest)
        {
            var result = await _userService.GetUserViaAuthentication(tokenRequest);
            return result.ToResponse(user => _tokenService.GenerateToken(user!));
        }

        
        [HttpGet]
        [ProducesResponseType(typeof(TokenResponseDto), 200)]
        [Route("token-refresh")]
        [Authorize]
        [SwaggerOperation(Summary = "Refreshes access token")]
        public async Task<IActionResult> RefreshToken()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
			if (userId is null) return Unauthorized();
            UserDto user = await _userService.GetUserWithRoles(new Guid(userId));
            if (user.IsEnabled == false)
            {
                return new KnownErrors.UsersErrors().DisabledUser.ToErrorResponse();
            }
            return Ok(_tokenService.GenerateToken(user));
        }

        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<RolesType>), 200)]
        [Route("roles")]
        [AllowAnonymous]
        [SwaggerOperation(Summary = "Lists the all available roles")]
        public IActionResult ListRoles()
        {
            var roles = Enum.GetValues<RolesType>();

            return Ok(roles.Where(x => x != RolesType.Admin));
        }
    }
}
