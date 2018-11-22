rule tabix_index_known_variant_sites:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    input:
        config['resource']['known_variant_sites']
    output:
        config['resource']['known_variant_sites'] + '.tbi'
    params:
        extra = ''
    threads: 1
    logs: 'logs/tabix/tabix_index_known_variant_sites.log'
