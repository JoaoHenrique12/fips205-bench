import pstats

p = pstats.Stats("profile.prof")
p.strip_dirs().sort_stats('cumulative')

# Print statistics only for functions matching 'sign_message' or 'verify_message'
p.print_stats(r'sign_message_entrypoint|verify_message_entrypoint')
