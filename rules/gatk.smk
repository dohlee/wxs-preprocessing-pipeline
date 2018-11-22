from os.path import join

rule base_recalibrator:
    input:
        # Required input.
        bam = join(config['result_dir']['sample'], '{sample}.duplicates_marked.sorted.bam'),
        reference = config['reference']['fasta'],
        reference_index = config['reference']['fasta'] + '.fai',
        reference_dict = config['reference']['genome'] + '.dict',
        known_sites = [config['resource']['known_variant_sites']],
        known_sites = [config['resource']['known_variant_sites'] + '.tbi'],
    output:
        # Required output.
        join(config['result_dir']['sample'], '{sample}_recalibration.table'),
    threads: config['threads']['gatk']['base_recalibrator']
    resources: RAM=16
    log: 'logs/gatk/base-recalibrator/{sample}.log'
    wrapper: 'http://dohlee-bio.info:9193/gatk/preprocessing/base-recalibrator'

rule apply_bqsr:
    input:
        bam = join(config['result_dir']['sample'], '{sample}.duplicates_marked.sorted.bam'),
        reference = config['reference']['fasta'],
        recalibration_table = join(config['result_dir']['sample'], '{sample}_recalibration.table'),
    output:
        join(config['result_dir']['sample'], '{sample}.duplicates_marked.recalibrated.sorted.bam'),
    params:
        # Optional parameters. Omit if unused.
        java_options = '-Xmx32g'
    threads: config['threads']['gatk']['apply_bqsr']
    resources: RAM = 32
    log: 'logs/gatk/apply-bqsr/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/gatk/preprocessing/apply-bqsr'

rule create_sequence_dictionary:
    input:
        config['reference']['fasta'],
    output:
        config['reference']['fasta'] + '.dict',
    params:
        # Optional parameters. Omit if unused.
        java_options = '-Xmx4g'
    threads: 1
    resources: RAM = 4
    log: 'logs/gatk/create-sequence-dictionary/{reference}.log'
    wrapper:
        'http://dohlee-bio.info:9193/gatk/reference/create_sequence_dictionary'

