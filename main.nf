nextflow.enable.dsl=2
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
include {TestInstall} from './modules/module_1/testInstall.nf'
include {DataPrep; AmpliconSuite} from './modules/module_2/ampliconSuite.nf'
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
params.user = "drainford"
params.data = "/scratch/drainford/skcm_ecdna/test_data/" 
params.outdir = "/scratch/drainford/skcm_ecdna/results/amplicon_suite/"
params.test = false
params.help = false
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
def helpMessage = 
"""
Usage:
nextflow run script.nf --user <User ID> --data <path> --contigs <path> --outdir <path> --test <Boolean>

Options:
--user      HPC user account ID.
--data      Path to the directory containing input BAM files.
--outdir    Path to the directory where AmpliconArchitect with publish the results.
--test      Boolean to run the TestInstall process. Default is false.

--help      Print this help message.
"""

if (params.help) {
    println(helpMessage)
    System.exit(0) // Exit the script after printing the help message
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
test_reads_channel = Channel.fromFilePairs("${params.data}*_{1,2}.fastq.gz")
    .ifEmpty { throw new RuntimeException("No FASTQ files found matching pattern in ${params.data}") }

bams_channel = Channel.fromFilePairs("${params.data}*_{T,N}.bam")
    .ifEmpty { throw new RuntimeException("No BAM files found matching pattern in ${params.data}") }
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
workflow {
    if (params.test) {
        TestInstall(test_reads_channel)
    } 
    else {
        AmpliconSuite(bams_channel)
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
