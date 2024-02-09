namespace EuroConnector.API.DTOs.Versions
{
    public class ApiVersionDto
    {
        public string Version { get; set; } = default!;
        public DateTime ReleaseDate { get; set; }
    }
}
