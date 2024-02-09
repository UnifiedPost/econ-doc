using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.Infrastructure.Extensions;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using System.Security.Claims;

namespace EuroConnector.API.Controllers
{
    [ApiController]
    [Route("api/public/v{version:apiVersion}/[controller]")]
    [ApiVersion("1.0")]
    [Authorize(Roles = "ErpAdmin")]
    public class EntitiesController : ControllerBase
    {
        private readonly ICompanyService _companyService;
        private readonly IUserService _userService;
        private readonly IPeppolAccessPointService _peppolAccessPointService;

        public EntitiesController(
            ICompanyService companyService,
            IUserService userService,
            IPeppolAccessPointService peppolAccessPointService)
        {
            _companyService = companyService;
            _userService = userService;
            _peppolAccessPointService = peppolAccessPointService;
        }

        [HttpGet]
        [Route("peppol-lookup/{id}")]
        [SwaggerOperation(Summary = "ERP checks if entity is onboarded in Peppol")]
        [ProducesResponseType(typeof(EntityLookupResponseDto), 200)]
        public async Task<IActionResult> PeppolLookup(string id)
        {
            var result = await _peppolAccessPointService.PeppolLookup(id);

            return result.ToResponse();
        }

        [HttpPost]
        [Route("create")]
        [SwaggerOperation(Summary = "ERP creates new Entity (Company) and onboards it to Peppol, also creates Username, SecretKey (EntityUser)*")]
        [ProducesResponseType(typeof(EntityCreateResponseDto), 200)]
        public async Task<IActionResult> Create(EntityDto entity)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            var connectedErpProviderId = await _userService.GetConnectedErpProviderId(new Guid(userId));
            if (connectedErpProviderId is null || connectedErpProviderId == Guid.Empty) return new KnownErrors.ErpErrors().ErpNotFound.ToErrorResponse();

            var result =  await _peppolAccessPointService.OnboardNewEntity(entity, (Guid)connectedErpProviderId);

            return result.ToResponse();

        }

        [HttpPost]
        [Route("search")]
        [SwaggerOperation(Summary = "ERP searches by query and gets a list in return")]
        //[ProducesResponseType(typeof(EntitySearchResponse), 200)]
        public async Task<IActionResult> Search(EntitySearchRequest request)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            var connectedErpProviderId = await _userService.GetConnectedErpProviderId(new Guid(userId));
            if (connectedErpProviderId is null || connectedErpProviderId == Guid.Empty) return new KnownErrors.ErpErrors().ErpNotFound.ToErrorResponse();

            var results = await _companyService.SearchForEntity(request, (Guid)connectedErpProviderId);

            return results.ToResponse();
        }

        [HttpGet]
        [Route("{id}")]
        [SwaggerOperation(Summary = "ERP retrieves information about the entity")]
        [ProducesResponseType(typeof(EntityInfoDto), 200)]
        public async Task<IActionResult> Get(Guid id)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            var connectedErpProviderId = await _userService.GetConnectedErpProviderId(new Guid(userId));
            if (connectedErpProviderId is null || connectedErpProviderId == Guid.Empty) return new KnownErrors.ErpErrors().ErpNotFound.ToErrorResponse();

            var results = await _companyService.GetCompanyById(id, (Guid)connectedErpProviderId);

            return Ok(results);
        }

        [HttpPut]
        [Route("{id}/edit")]
        [SwaggerOperation(Summary = "The ERP edits the selected Entity (Company)")]
        public async Task<IActionResult> Edit(Guid id, EntityEditRequestDto request)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            var connectedErpProviderId = await _userService.GetConnectedErpProviderId(new Guid(userId));
            if (connectedErpProviderId is null || connectedErpProviderId == Guid.Empty) return new KnownErrors.ErpErrors().ErpNotFound.ToErrorResponse();

            var results = await _companyService.EditEntity(id, (Guid)connectedErpProviderId, request);

            return results.ToResponse();
        }

        [HttpDelete]
        [Route("{id}")]
        [SwaggerOperation(Summary = "The ERP deletes the chosen Entity and removes it from the peppol network.")]
        public async Task<IActionResult> Delete(Guid id)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            var connectedErpProviderId = await _userService.GetConnectedErpProviderId(new Guid(userId));
            if (connectedErpProviderId is null || connectedErpProviderId == Guid.Empty) return new KnownErrors.ErpErrors().ErpNotFound.ToErrorResponse();

            var results = await _companyService.DeleteEntity(id, (Guid)connectedErpProviderId);

            return results.ToResponse();
        }

        [HttpPut]
        [Route("{id}/secret-key")]
        [SwaggerOperation(Summary = "ERP generates a new secret key for the Entity to login")]
        [ProducesResponseType(typeof(EntityKeyUpdateResponseDto), 200)]
        public async Task<IActionResult> UpdateSecretKey(Guid id)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            var connectedErpProviderId = await _userService.GetConnectedErpProviderId(new Guid(userId));
            if (connectedErpProviderId is null || connectedErpProviderId == Guid.Empty) return new KnownErrors.ErpErrors().ErpNotFound.ToErrorResponse();

            var results = await _companyService.UpdateEntitySecretKey(id, (Guid)connectedErpProviderId);

            return results.Match<IActionResult>(
                value => Ok(value),
                error => new ObjectResult(error)
                {
                    StatusCode = error.StatusCode
                }
            );
        }
    }
}
