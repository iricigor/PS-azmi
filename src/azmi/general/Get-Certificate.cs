using System.Management.Automation;
using Azure.Identity;
using System;
using Azure.Security.KeyVault.Certificates;


namespace azmi
{
    //
    // Get-AzmiCertificate
    //
    //   Get certificate content from Azure Key Vault using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiCertificate")]
    [OutputType(typeof(String))]
    public class GetCertificate : PSCmdlet
    {
        //
        // Arguments private properties
        //
        private string identity;
        private string certificate;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity { get { return identity; } set { identity = value; } }

        [Parameter(Position = 0, Mandatory = true)]
        public string Certificate { get { return certificate; } set { certificate = value; } }

        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            var cred = new ManagedIdentityCredential(identity);

            WriteVerbose($"Parsing certificate... '{certificate}'");
            (Uri keyVault, string certName, string certVersion) = Shared.ParseUrl(certificate);

            WriteVerbose($"Obtaining certificate client for '{keyVault}' using '{identity}'...");
            // var secretClient = new SecretClient(keyVault, cred);
            var certificateClient = new CertificateClient(keyVault, cred);
            KeyVaultCertificate certObj;

            WriteVerbose($"Obtaining certificate Id {certName}...");
            if (String.IsNullOrEmpty(certVersion)) {
                certObj = certificateClient.GetCertificate(certName);
            } else
            {
                certObj = certificateClient.GetCertificateVersion(certName, certVersion);
            }
            var secretId = certObj.SecretId.ToString();

            WriteVerbose($"Obtaining certificate from {secretId}...");
            var gs = new GetSecret() { Secret = secretId, Identity = identity };
            var cert = gs.Invoke();
            WriteObject(cert);
        }
    }
}
