using System;
using Azure.Identity;
using Azure.Core;
using System.IdentityModel.Tokens.Jwt;

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

        ///
        /// Argument: JWTformat
        ///
        [Parameter(Position = 2)]
        public SwitchParameter JWTformat
        {
            get { return jwtformat; }
            set { jwtformat = value; }
        }
        private bool jwtformat;



        protected override void ProcessRecord()
        {
            var Cred = new ManagedIdentityCredential(identity);
            // If no process names are passed to the cmdlet, get all processes.
            var Scope = new String[] { $"https://{endpoint}.azure.com/" };
            var Request = new TokenRequestContext(Scope);
            var Token = Cred.GetToken(Request);
            if (jwtformat)
            {
                WriteObject(Decode_JWT(Token.Token));
            } else
            {
                WriteObject(Token.Token);
            }
        }

        private string Decode_JWT(string tokenEncoded)
        {
            var handler = new JwtSecurityTokenHandler();
            var tokenDecoded = handler.ReadJwtToken(tokenEncoded);
            return tokenDecoded.ToString(); // decoded JSON Web Token

        }
    }
}
