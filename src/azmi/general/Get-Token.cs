using System;
using Azure.Identity;
using Azure.Core;
using System.Management.Automation;
using System.IdentityModel.Tokens.Jwt;


namespace azmi
{
    //
    // Get-AzmiToken
    //
    //   Returns Azure access token for a managed identity
    //


    [Cmdlet(VerbsCommon.Get, "AzmiToken")]
    [OutputType(typeof(String))]
    public class GetToken : Cmdlet
    {

        //
        // Arguments properties
        //

        private string identity;
        private string endpoint = "management";
        private bool jwtformat;

        ///
        /// Argument: Identity
        ///
        [Parameter(Position = 0)]
        public string Identity
        {
            get { return identity; }
            set { identity = value; }
        }

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
        ///
        /// Argument: JWTformat
        ///
        [Parameter()]
        public SwitchParameter JWTformat
        {
            get { return jwtformat; }
            set { jwtformat = value; }
        }


        //
        //
        //  **** Cmdlet start ****
        //
        //

        protected override void ProcessRecord()
        {
            var Cred = new ManagedIdentityCredential(identity);
            var Scope = new String[] { $"https://{endpoint}.azure.com" };
            var Request = new TokenRequestContext(Scope);
            var Token = Cred.GetToken(Request);
            if (jwtformat) {
                WriteObject(Decode_JWT(Token.Token));
            } else {
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
