# Include hook code here

# Load up the cache sweepers when hyperactive starts
Rails.plugins[:hyperactive].code_paths << "app/sweepers"