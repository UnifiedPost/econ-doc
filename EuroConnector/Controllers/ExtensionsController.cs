using EuroConnector.API.Clients;
using EuroConnector.API.Infrastructure.Extensions;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using System.Globalization;
using System.Security.Claims;

namespace EuroConnector.API.Controllers
{
    //[Authorize]
    [ApiController]
    [ApiVersion("1.0")]
    public class ExtensionsController : ControllerBase
    {
        private readonly IDxGatewayClient _dxGatewayClient;
        private readonly ICrossnetClient _crossnetClient;
        private readonly IUserService _userService;
        private readonly IDocumentService _documentService;

        public ExtensionsController(
            IDxGatewayClient dxGatewayClient,
            ICrossnetClient crossnetClient,
            IUserService userService, 
            IDocumentService documentService)
        {
            _dxGatewayClient = dxGatewayClient;
            _crossnetClient = crossnetClient;
            _userService = userService;
            _documentService = documentService;
        }

        [Route("api/public/v{version:apiVersion}/[controller]/version")]
        [HttpGet]
        [ProducesResponseType(typeof(string), 200)]
        [AllowAnonymous]
        [SwaggerOperation(Summary = "Presents the version of this API")]
        public IActionResult GetVersion()
        {
            return Ok(new
            {
                Version = "0.9.2",
                ReleaseDate = new DateOnly(2024, 2, 9),
                Comment = $"Copyright © 2024 Unifiedpost, UAB. All rights reserved.",
            });
        }

        [HttpGet]
        [ProducesResponseType(typeof(string), 200)]
        [Route("api/internal/v{version:apiVersion}/[controller]/version-crossnet")]
        [Authorize(Roles = "Admin")]
        [SwaggerOperation(Summary = "Presents the version of Crossnet REST API")]
        public async Task<IActionResult> GetCrossnetVersion()
        {
            return Ok(await _crossnetClient.GetVersion());
        }

        [HttpGet]
        [ProducesResponseType(typeof(string), 200)]
        [Route("api/internal/v{version:apiVersion}/[controller]/version-dxGateway")]
        [Authorize(Roles = "Admin")]
        [SwaggerOperation(Summary = "Presents the version of dxgateway API")]
        public async Task<IActionResult> GetDxGatewayVersion()
        {
            return Ok(await _dxGatewayClient.GetVersion());
        }

        [HttpGet]
        [ProducesResponseType(typeof(string), 200)]
        [Route("api/public/v{version:apiVersion}/[controller]/billing-report/{periodFrom}/{periodTo}")]
        [Authorize(Roles = "ErpAdmin")]
        [SwaggerOperation(Summary = "Returns billing statistics for specified period. Available for ERP")]
        public async Task<IActionResult> BillingReport(string periodFrom,string periodTo)
        {
            string userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
            var connectedErpProviderId = await _userService.GetConnectedErpProviderId(new Guid(userId));
            if (connectedErpProviderId is null) return new KnownErrors.ErpErrors().ErpNotFound.ToErrorResponse();

            if(!DateOnly.TryParseExact(periodFrom, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out var dateFrom))
            {
                return new Error("PeriodFrom date format is invalid. Expected format: yyyy-MM-dd", 400).ToErrorResponse();
            }
            if(!DateOnly.TryParseExact(periodTo, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out var dateTo))
            {
                return new Error("PeriodTo date format is invalid. Expected format: yyyy-MM-dd", 400).ToErrorResponse();
            }

            var results = await _documentService.GetBillingReort(dateFrom, dateTo, (Guid)connectedErpProviderId);
            return results.ToResponse();
        }

    }
}
