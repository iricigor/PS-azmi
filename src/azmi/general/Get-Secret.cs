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
    public class GetSecret : PSCmdlet
    {
        //
        // Arguments private properties
        //
        private string identity;
        private string secret;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity { get { return identity; } set { identity = value; } }

        [Parameter(Position = 0, Mandatory = true)]
        public string Secret { get { return secret; } set { secret = value; } }

        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            var cred = new ManagedIdentityCredential(identity);

            WriteVerbose($"Parsing secret... '{secret}'");
            //(Uri keyVault, string secretName, string secretVersion) = ParseSecret(secret);
            (Uri keyVault, string secretName, string secretVersion) = Shared.ParseUrl(secret);

            WriteVerbose($"Obtaining KV client for '{keyVault}' using '{identity}'...");
            var secretClient = new SecretClient(keyVault, cred);

            WriteVerbose($"Obtaining secret {secretName}...");
            WriteObject(secretClient.GetSecret(secretName, secretVersion).Value.Value);
        }

        // for multiple secrets see here
        // https://docs.microsoft.com/en-us/dotnet/api/overview/azure/security.keyvault.secrets-readme#list-secrets

    }
}
