namespace Belin.Akismet.Cmdlets;

/// <summary>
/// Submits the specified comment that was incorrectly marked as spam but should not have been.
/// </summary>
[Cmdlet(VerbsLifecycle.Submit, "Ham")]
public class SubmitHam: Cmdlet {

}
