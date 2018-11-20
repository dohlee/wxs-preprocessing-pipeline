rule samtools_faidx:
    input:
        config['reference']['fasta'],
    output:
        config['reference']['fasta'] + '.fai',
    wrapper:
        'http://dohlee-bio.info:9193/samtools/faidx'

