﻿using System.Management.Automation;
using System.Text.RegularExpressions;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using System;


namespace azmi
{
    //
    // Get-AzmiCertificate
    //
    //   Get certificate and its content from Azure Key Vault using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiCertificate")]
    public class GetAzmiCertificate : PSCmdlet
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

            // WriteVerbose($"Parsing secret... '{certificate}'");
            // (Uri keyVault, string secretName, string secretVersion) = ParseSecret(secret);

            // WriteVerbose($"Obtaining KV client for '{keyVault}' using '{identity}'...");
            // var secretClient = new SecretClient(keyVault, cred);

            // WriteVerbose($"Obtaining secret {secretName}...");
            // WriteObject(secretClient.GetSecret(secretName, secretVersion).Value.Value);

            WriteObject(1);
        }
    }
}
