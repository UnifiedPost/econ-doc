namespace EuroConnector.API.DTOs.Users
{
    public class UserCreateResponseDto: UserDto
    {
        public string NewSecretKey { get; set; } = default!;
    }
}
