using System;
using Azure.Identity;
using Azure.Core;

using System.Diagnostics;
using System.Management.Automation;

namespace azmi
{
    [Cmdlet(VerbsCommon.Get, "azmiToken")]
    public class GetProcCommand : Cmdlet
    {
        ///
        /// Argument: Identity
        ///
        [Parameter(Position = 0)]
        public string Identity
        {
            get { return identity; }
            set { identity = value; }
        }
        private string identity;

        ///
        /// Argument: Endpoint
        ///
        [Parameter(Position = 1)]
        [ValidateSet("management", "storage")]
        public string Endpoint
        {
            get { return endpoint; }
            set { endpoint = value; }
        }
        private string endpoint = "management";


        protected override void ProcessRecord()
        {
            var Cred = new ManagedIdentityCredential(identity);
            // If no process names are passed to the cmdlet, get all processes.
            var Scope = new String[] { $"https://{endpoint}.azure.com" };
            var Request = new TokenRequestContext(Scope);
            var Token = Cred.GetToken(Request);
            WriteObject(Token.Token);
        }
    }
}
