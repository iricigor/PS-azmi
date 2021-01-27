using System;
using System.Linq;
using System.Threading.Tasks;
using System.IO;
using Azure.Identity;
using System.Management.Automation;
using Azure.Storage.Blobs;

namespace azmi
{

    //
    // Set-AzmiBlobContent
    //
    //   Uploads local file/directory to Azure storage blob/container using managed identity
    //

    [Cmdlet(VerbsCommon.Set, "AzmiBlobContent")]
    public class SetBlobContent : PSCmdlet
    {

        //
        // Arguments private properties
        //

        private string identity;
        private string blob;
        private string file;
        private string container;
        private string directory;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity { get { return identity; } set { identity = value; } }

        [Parameter(Position = 0, Mandatory = true, ParameterSetName = "Single")]
        public string Blob { get { return blob; } set { blob = value; } }

        [Parameter(Position = 1, Mandatory = false, ParameterSetName = "Single")]
        public string File { get { return file; } set { file = value; } }

        [Parameter(Mandatory = true, ParameterSetName = "Multi")]
        public string Container { get { return container; } set { container = value; } }

        [Parameter(Mandatory = false, ParameterSetName = "Multi")]
        public string Directory { get { return directory; } set { directory = value; } }


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
            var cred = new ManagedIdentityCredential(identity);
            var blobClient = new BlobClient(new Uri(blob), cred);
            // Fix path
            file ??= blob.Split('/').Last();
            file = Path.GetFullPath(file, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using source: '{file}'");
            // Download
            blobClient.Upload(file);
            WriteVerbose("Upload completed");
        }

        private void ProcessMulti()
        {
            WriteVerbose("Starting to process a container");
            // Connection
            var cred = new ManagedIdentityCredential(identity);
            var containerClient = new BlobContainerClient(new Uri(container), cred);

            // fix path
            directory ??= container.Split('/').Last();
            directory = Path.GetFullPath(directory, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using source: '{directory}'");

            // get list of files
            WriteVerbose("Obtaining list of files...");
            var fileList = System.IO.Directory.EnumerateFiles(directory, "*", SearchOption.AllDirectories);
            WriteVerbose($"Obtained {fileList.Count()} files");

            Parallel.ForEach(fileList, file =>
            {
                var blobPath = file.Substring(directory.Length).TrimStart(Path.DirectorySeparatorChar);
                BlobClient blobClient = containerClient.GetBlobClient(blobPath);
                blobClient.Upload(file);
            });
            WriteVerbose("Upload completed");
        }
    }
}
