namespace Belin.Akismet.Cmdlets;

/// <summary>
/// Checks the API key against the service database, and returns a value indicating whether it is valid.
/// </summary>
[Cmdlet(VerbsDiagnostic.Test, "ApiKey")]
[OutputType(typeof(bool))]
public class TestApiKey: Cmdlet {

}
