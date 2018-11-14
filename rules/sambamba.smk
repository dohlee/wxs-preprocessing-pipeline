from os.path import join

rule sambamba_sort:
    input:
        join(config['result_dir']['sample'], '{sample}.bam')
    output:
        join(config['result_dir']['sample'], '{sample}.sorted.bam')
    threads: config['threads']['sambamba']['sort']
    params:
        extra = '' \
        # Approximate total memory limit for all threads [2GB].
        # '-m INT ' \
        # Directory for storing intermediate files.
        # '--tmpdir=TMPDIR ' \
        # Sort by read name.
        # '-n ' \
        # Compression level for sorted BAM, from 0 to 9.
        # '--compression-leve=COMPRESSION_LEVEL ' \
        # Keep only reads that satisfy FILTER.
        # '--filter=FILTER '
    log: 'logs/sambamba/sort/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/sort'

rule sambamba_index:
    input:
        join(config['result_dir']['sample'], '{sample}.duplicates_marked.recalibrated.sorted.bam')
    output:
        join(config['result_dir']['sample'], '{sample}.duplicates_marked.recalibrated.sorted.bam.bai')
    threads: config['threads']['sambamba']['index']
    log: 'logs/sambamba/sort/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/index'

rule sambamba_markdup:
    input:
        join(config['result_dir']['sample'], '{sample}.sorted.bam')
    output:
        join(config['result_dir']['sample'], '{sample}.duplicates_marked.sorted.bam')
    threads: config['threads']['sambamba']['markdup']
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/markdup'

