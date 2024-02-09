using EuroConnector.API.DTOs.Erp;
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
    public class ErpController : ControllerBase
    {
        private readonly IErpProviderService _erpProviderService;

        public ErpController(IErpProviderService erpProviderService)
        {
            _erpProviderService = erpProviderService;
        }

        [HttpPost]
        [Route("create")]
        [SwaggerOperation(Summary = "Admin creates an ERP provider")]
        [ProducesResponseType(typeof(ErpResponseDto), 200)]
        public async Task<IActionResult> Create(ErpCreateRequestDto erp)
        {
            var response = await _erpProviderService.CreateErpProvider(erp);
            return Ok(response);
        }

        [HttpPost]
        [Route("search")]
        [SwaggerOperation(Summary = "Admin searches for ERP by query and gets a list in return")]
        public IActionResult Search(object request)
        {
            return Ok();
        }

        [HttpGet]
        [Route("{id}")]
        [SwaggerOperation(Summary = "Admin retrieves information about the ERP provider")]
        public async Task<IActionResult> Get(Guid id)
        {
            var result = await _erpProviderService.GetErpProviderById(id);

            return Ok(result);
        }

        [HttpPut]
        [Route("{id}")]
        [SwaggerOperation(Summary = "Admin updates the ERP record")]
        public IActionResult Update(string id)
        {
            //not implemented
            return Ok();
        }

        [HttpDelete]
        [Route("{id}")]
        [SwaggerOperation(Summary = "Admin deletes the ERP record")]
        public IActionResult Dellete(string id)
        {
            //not implemented
            return Ok();
        }
    }
}
