#!/usr/bin/env nextflow
/*
========================================================================================
    nf-core/marsseq
========================================================================================
    Github : https://github.com/nf-core/marsseq
    Website: https://nf-co.re/marsseq
    Slack  : https://nfcore.slack.com/channels/marsseq
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
========================================================================================
    GENOME PARAMETER VALUES
========================================================================================
*/

params.fasta   = WorkflowMain.getGenomeAttribute(params, 'fasta')
params.gtf     = WorkflowMain.getGenomeAttribute(params, 'gtf')
params.aligner = params.release == 1 ? 'hisat2' : 'bowtie2'

/*
========================================================================================
    VALIDATE & PRINT PARAMETER SUMMARY
========================================================================================
*/

WorkflowMain.initialise(workflow, params, log)

/*
========================================================================================
    NAMED WORKFLOW FOR PIPELINE
========================================================================================
*/

//
// WORKFLOW: Run main nf-core/marsseq analysis pipeline
//
workflow NFCORE_MARSSEQ {

    include { MARSSEQ } from './workflows/marsseq'
    MARSSEQ ()

}

/*
========================================================================================
    RUN ALL WORKFLOWS
========================================================================================
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//
workflow {
    NFCORE_MARSSEQ ()
}

/*
========================================================================================
    THE END
========================================================================================
*/
