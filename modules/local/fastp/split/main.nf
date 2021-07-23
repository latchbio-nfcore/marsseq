// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process FASTP_SPLIT {
    tag "$meta.id"
    label 'process_medium'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:"${meta.id}", meta:meta, publish_by_meta:['id']) }

    conda (params.enable_conda ? 'bioconda::fastp=0.20.1' : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container 'https://depot.galaxyproject.org/singularity/fastp:0.20.1--h8b12597_0'
    } else {
        container 'quay.io/biocontainers/fastp:0.20.1--h8b12597_0'
    }

    input:
    tuple val(meta), path(reads)

    output:
    path 'raw_reads/'   , emit: reads
    path '*.log'        , emit: log
    path '*.version.txt', emit: version

    script:
    def software = getSoftwareName(task.process)

    """
    mkdir raw_reads/
    fastp \
        -i ${reads[0]} \\
        -I ${reads[1]} \\
        -o raw_reads/${reads[0]} \\
        -O raw_reads/${reads[1]} \\
        --thread $task.cpus \\
        --disable_quality_filtering \\
        --disable_length_filtering \\
        --disable_adapter_trimming \\
        --disable_trim_poly_g \\
        $options.args \\
        2> ${meta.id}.fastp.log

    echo \$(fastp --version 2>&1) | sed -e "s/fastp //g" > ${software}.version.txt
    """
}