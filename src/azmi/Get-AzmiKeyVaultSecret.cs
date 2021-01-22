using System.Management.Automation;
using System.Text.RegularExpressions;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using System;


namespace azmi
{
    //
    // Get-AzmiBlobContent
    //
    //   Lists secrets from Azure Key Vault using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiKeyVaultSecret")]
    public class GetAzmiKeyVaultSecret : PSCmdlet
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
            (Uri keyVault, string secretName, string secretVersion) = ParseSecret(secret);

            WriteVerbose($"Obtaining KV client for '{keyVault}' using '{identity}'...");
            var secretClient = new SecretClient(keyVault, cred);

            WriteVerbose($"Obtaining secret {secretName}...");
            WriteObject(secretClient.GetSecret(secretName, secretVersion).Value.Value);
        }

        // for multiple secrets see here
        // https://docs.microsoft.com/en-us/dotnet/api/overview/azure/security.keyvault.secrets-readme#list-secrets

        private (Uri, string, string) ParseSecret(string secret) {
            // Example of expected URLs: https://my-key-vault.vault.azure.net/secrets/mySecretpwd (latest version)
            // or https://my-key-vault.vault.azure.net/secrets/mySecretpwd/67d1f6c499824607b81d5fa852f9865c (specific version)

            // split
            var u = new Uri(secret);
            var kv = u.Scheme + Uri.SchemeDelimiter + u.Host;
            var p = u.AbsolutePath.Split('/');

            // validate
            //var t = kv + "/secret/" + p[2];
            //if (!String.IsNullOrEmpty(p[3])) { t += $"/{p[3]}"; };
            //if (t != secret) { throw new Exception(); };

            // return values
            return (new Uri(kv), p[2], (p.Length < 4) ? null : p[3]);
        }
    }
}
