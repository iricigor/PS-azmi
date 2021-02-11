using System.Management.Automation;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using System;


namespace azmi
{
    //
    // Get-AzmiSecret
    //
    //   Get content of the secret from Azure Key Vault using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiSecret")]
    [OutputType(typeof(String))]
    public class GetSecret : PSCmdlet
    {
        //
        // Arguments private properties
        //
        //private string identity;
        //private string secret;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity { get; set; }

        [Parameter(Position = 0, Mandatory = true, HelpMessage = "Full secret URL like https://ContosoVault.vault.azure.net/secrets/Password")]
        public string Secret { get; set; }

        [Parameter(Mandatory = false)]
        public string File { get; set; }

        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            var cred = new ManagedIdentityCredential(Identity);

            WriteVerbose($"Parsing secret... '{Secret}'");
            //(Uri keyVault, string secretName, string secretVersion) = ParseSecret(secrets);
            (Uri keyVault, string secretName, string secretVersion) = Shared.ParseUrl(Secret, "secrets");

            WriteVerbose($"Obtaining KV client for '{keyVault}' using '{Identity}'...");
            var secretClient = new SecretClient(keyVault, cred);

            WriteVerbose($"Obtaining secret {secretName}...");
            var secretValue = secretClient.GetSecret(secretName, secretVersion).Value.Value;

            // return value
            if (String.IsNullOrEmpty(File))
            {
                WriteObject(secretValue);
            } else
            {
                WriteVerbose($"Saving secret to file {File}...");
                System.IO.File.WriteAllText(File, secretValue);
                // TODO: Add test for file in current dir
                // TODO: Candidate for async
            }
        }

        // for multiple secrets see here
        // https://docs.microsoft.com/en-us/dotnet/api/overview/azure/security.keyvault.secrets-readme#list-secrets

    }
}
