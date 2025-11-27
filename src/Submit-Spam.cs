namespace Belin.Akismet.Cmdlets;

/// <summary>
/// Submits the specified comment that was not marked as spam but should have been.
/// </summary>
[Cmdlet(VerbsLifecycle.Submit, "Spam")]
public class SubmitSpam: Cmdlet {

}
