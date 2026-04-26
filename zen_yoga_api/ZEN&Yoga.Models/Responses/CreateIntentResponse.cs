namespace ZEN_Yoga.Models.Responses
{
    public record CreateIntentResponse
    (
    [property: System.Text.Json.Serialization.JsonPropertyName("client_secret")]
    string ClientSecret,

    [property: System.Text.Json.Serialization.JsonPropertyName("customer")]
    string Customer,

    [property: System.Text.Json.Serialization.JsonPropertyName("ephemeralKey")]
    string EphemeralKey
    );
}
