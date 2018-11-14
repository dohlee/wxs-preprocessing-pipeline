from os.path import join

# WORKFLOW NOTIFICATIONS.
onstart: shell()
onerror: shell()
onsuccess: shell()

configfile: 'config.yaml'
include: 'rules/bwa.smk'
include: 'rules/sambamba.smk'
include: 'rules/gatk.smk'

wildcard_constraints:
    sample = config['wildcard_constraints']['sample'],
    normal = config['wildcard_constraints']['normal'],
    tumor  = config['wildcard_constraints']['tumor'],

# DEFINE YOUR SAMPLES HERE.
SAMPLES = []

rule all:
    input:
        expand(join(config['result_dir']['sample'], '{sample}.duplicates_marked.recalibrated.sorted.bam'), sample=SAMPLES),
        expand(join(config['result_dir']['sample'], '{sample}.duplicates_marked.recalibrated.sorted.bam.bai'), sample=SAMPLES),
