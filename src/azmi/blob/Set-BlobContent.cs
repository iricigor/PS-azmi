using System;
using System.Linq;
using System.Threading.Tasks;
using System.IO;
using Azure.Identity;
using System.Management.Automation;
using Azure.Storage.Blobs;
using System.Text.RegularExpressions;

namespace azmi
{

    //
    // Set-AzmiBlobContent
    //
    //   Uploads local file/directory to Azure storage blob/container using managed identity
    //

    [Cmdlet(VerbsCommon.Set, "AzmiBlobContent")]
    [OutputType(typeof(void))]
    public class SetBlobContent : PSCmdlet
    {

        //
        // Arguments private properties
        //

        //private string identity;
        //private string blob;
        //private string file;
        //private string container;
        //private string directory;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity { get; set; }

        [Parameter()]
        public SwitchParameter Force { get; set; }

        // Single File/Blob parameter set
        [Parameter(Position = 0, Mandatory = true, ParameterSetName = "Single")]
        public string Blob { get; set; }

        [Parameter(Position = 1, Mandatory = true, ParameterSetName = "Single")]
        public string File { get; set; }

        //
        // Multiple files/blobs parameter set
        //
        [Parameter(Mandatory = true, ParameterSetName = "Multi")]
        public string Container { get; set; }

        [Parameter(Mandatory = true, ParameterSetName = "Multi")]
        public string Directory { get; set; }

        [Parameter(ParameterSetName = "Multi")]
        public string Exclude { get; set; }


        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {

            if (ParameterSetName == "Single")
            {
                ProcessSingle();
            }
            else if (ParameterSetName == "Multi")
            {
                ProcessMulti();
            }
            else
            {
                throw new ArgumentException("Bad ParameterSet Name");
            }
        }

        private void ProcessSingle()
        {
            WriteVerbose("Starting to process a single blob");
            // Connection
            var cred = new ManagedIdentityCredential(Identity);
            var blobClient = new BlobClient(new Uri(Blob), cred);
            // Fix path
            File ??= Blob.Split('/').Last();
            File = Path.GetFullPath(File, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using source: '{File}'");
            // Download
            blobClient.Upload(File, Force);
            WriteVerbose("Upload completed");
        }

        private void ProcessMulti()
        {
            WriteVerbose("Starting to process a container");
            // Connection
            var cred = new ManagedIdentityCredential(Identity);
            var containerClient = new BlobContainerClient(new Uri(Container), cred);

            // fix path
            Directory ??= Container.Split('/').Last();
            Directory = Path.GetFullPath(Directory, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using source: '{Directory}'");

            // get list of files
            WriteVerbose("Obtaining list of files...");
            var fileList = System.IO.Directory.EnumerateFiles(Directory, "*", SearchOption.AllDirectories);
            WriteVerbose($"Obtained {fileList.Count()} files");

            // apply -Exclude regular expression
            if (!String.IsNullOrEmpty(Exclude))
            {
                WriteVerbose("Filtering list of files...");
                Regex excludeRegEx = new Regex(Exclude);
                fileList = fileList.Where(file => !excludeRegEx.IsMatch(file));
                WriteVerbose($"Filtered to {fileList.Count()} files");
            }

            Parallel.ForEach(fileList, file =>
            {
                var blobPath = file.Substring(Directory.Length).TrimStart(Path.DirectorySeparatorChar);
                BlobClient blobClient = containerClient.GetBlobClient(blobPath);
                blobClient.Upload(file, Force);
            });
            WriteVerbose("Upload completed");
        }
    }
}
