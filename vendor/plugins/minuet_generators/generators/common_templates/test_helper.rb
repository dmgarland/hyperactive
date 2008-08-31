# Load the normal Rails helper. This ensures the environment is loaded.
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Load the schema - if migrations have been performed, this will be up to date.
#load(File.dirname(__FILE__) + "/../db/schema.rb")
#Rake::Task['db:test:prepare']

# Set up the fixtures location manually, we don't want to move them to a
# temporary path using Engines::Testing.set_fixture_path.
Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

# The only drawback to using transactional fixtures is when you actually 
# need to test transactions.  Since your test is bracketed by a transaction,
# any transactions started in your code will be automatically rolled back.
Test::Unit::TestCase.use_transactional_fixtures = false

# Instantiated fixtures are slow, but give you @david where otherwise you
# would need people(:david).  If you don't want to migrate your existing
# test cases which use the @david style and don't mind the speed hit (each
# instantiated fixtures translates to a database query per test method),
# then set this back to true.
Test::Unit::TestCase.use_instantiated_fixtures  = false