require "#{File.dirname(__FILE__)}/../test_helper"

# TODO: it would be rather nice to get this stuff working, as the integration 
# tests allow us to do caching tests (using the newly-included cache-test plugin).
# However, the upload method for file_column testing is exploding here).
# I'll leave this in and come back to it when I have a mind to wrestle with 
# something irritating.
#
class VideoPublishingTest < ActionController::IntegrationTest
#  fixtures :content
#
#  def test_create
#    num_content = Video.count
#    
#    post '/videos/create', :content => {
#                              :title => "Test content",
#                              :file => upload("test/fixtures/fight_test.wmv"),
#                              :summary => "This is a test",
#                              :published_by => "Yoss", 
#                              :place => "London" 
#                            }
#    
#    assert_response :redirect
#    follow_redirect!
#    content = Video.find_by_title("Test content")
#    assert_equal "Test content", content.title
#    assert_match("foo", content.tag_list)
#    assert_match("bar", content.tag_list)
#    assert_match("london", content.place_tag_list)
#    assert_match("brixton", content.place_tag_list)
#    assert_no_match(/,/, content.tag_list) 
#    assert_no_match(/,/, content.place_tag_list)
#    assert_response :redirect
#    assert_redirected_to :action => 'show'
#    assert_equal num_content + 1, model_class.count
#    assert_equal "published", content.moderation_status    
#  end   
end
