# Include hook code here

# Load up the cache sweepers when hyperactive starts
Rails.plugins[:hyperactive].code_paths << "app/sweepers"

# Load up the model subfolders when hyperactive starts
Rails.plugins[:hyperactive].code_paths << "app/models/active_rbac"
Rails.plugins[:hyperactive].code_paths << "app/models/collectives"
Rails.plugins[:hyperactive].code_paths << "app/models/content"
Rails.plugins[:hyperactive].code_paths << "app/models/tags"
