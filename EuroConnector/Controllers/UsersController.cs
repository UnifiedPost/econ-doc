using EuroConnector.API.DTOs.Users;
using EuroConnector.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;

namespace EuroConnector.API.Controllers
{
    [ApiController]
    [Route("api/internal/v{version:apiVersion}/[controller]")]
    [ApiVersion("1.0")]
    [Authorize(Roles = "Admin")]
    public class UsersController : ControllerBase
    {
        private readonly IUserService _userService;


        public UsersController(IUserService userManagerService)
        {
            _userService = userManagerService;
        }

        [HttpPost]
        [ProducesResponseType(typeof(UserCreateResponseDto), 200)]
        [Route("create")]
        [SwaggerOperation(Summary = "Admin creates new user*")]
        public async Task<IActionResult> Create(UserCreateRequestDto user)
        {
            var model = await _userService.CreateUser(user);
            return Ok(model);
        }

        [HttpGet]
        [Route("{id}")]
        [SwaggerOperation(Summary = "Admin retrieves information about the user")]
        public IActionResult Get(string id)
        {
            return Ok();
        }

        [HttpPut]
        [Route("{id}")]
        [SwaggerOperation(Summary = "Admin updates the user record")]
        public IActionResult Update(string id)
        {
            return Ok();
        }

        [HttpDelete]
        [Route("{id}")]
        [SwaggerOperation(Summary = "Admin deletes the user record")]
        public IActionResult Dellete(string id)
        {
            return Ok();
        }

    }
}
