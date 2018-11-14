from os.path import join

def is_paired(sample):
    # DEFINE YOUR LOGIC TO DETERMINE WHETHER THE SAMPLE IS
    # PAIRED-ENDED or SINGLE-READ.
    # DON'T FORGET TO REMOVE THE NEXT LINE IF YOU FINISHED IMPLEMENTING.
    raise NotImplementedError('[rules/bwa] Not implemented is_paired function.')
    return True

def get_bwa_mem_input(wildcards):
    d, s = config['raw_data_dir'], wildcards.sample
    if is_paired(s):
        return [join(d, s + f'.read{i}.fastq.gz') for i in [1, 2]]
    else:
        return [join(d, s + '.fastq.gz')]

rule bwa_index:
    input:
        # Required input. Reference genome fasta file.
        config['reference']['fasta']
    output:
        # Required output. BWA-indexed reference genome files.
        config['reference']['basename'] + '.amb',
        config['reference']['basename'] + '.ann',
        config['reference']['basename'] + '.bwt',
        config['reference']['basename'] + '.pac',
        config['reference']['basename'] + '.sa',
    params:
        extra = '',
        # Note that the default algorithm for this wrapper is 'bwtsw'.
        # The other option is 'is', but please be warned that this algorithm doesn't work
        # with genomes longer than 2GB.
        algorithm = 'bwtsw'
    threads: config['threads']['bwa']['index']
    wrapper:
        'http://dohlee-bio.info:9193/bwa/index'

rule bwa_mem:
    input:
        # Required input. Input read file.
        reads = get_bwa_mem_input,
        # You may use any of {genome}.amb, {genome}.ann, {genome}.bwt,
        # {genome}.pac, {genome}.sa just to obligate snakemake to run `bwa index` first.
        reference = config['reference']['basename'] + '.bwt'
    output:
        # BAM output or SAM output is both allowed.
        # Note that BAM output will be automatically detected by its file extension,
        # and SAM output (which is bwa mem default) will be piped through `samtools view`
        # to convert SAM to BAM.
        join(config['result_dir']['sample'], '{sample}.bam')
    params:
        # -M option marks secondary alignments.
        # You may need this if you use GATK downstream.
        extra = r"-M " \
                # Read group annotation. Omit if unused.
                # NOTE: You should check the platform information of the read data!
                r"-R '@RG\tID:{sample}\tSM:{sample}\tPL:ILLUMINA'" \
                # 2i and 2i+1 th read files are paired.
                r"-p "
    threads: config['threads']['bwa']['mem']
    wrapper:
        'http://dohlee-bio.info:9193/bwa/mem'

