require File.dirname(__FILE__) + '/../../test_helper'

class Admin::SettingsControllerTest < ActionController::TestCase
  
  fixtures :settings
  
  def test_should_get_index
    get :index, {}, as_user(:marcos)
    assert_response :success
  end

  def test_should_update_settings
    put :update, {
          :site_name => "foo",
          :banner_image => "foo.jpg",
          :torrent_tracker => "http://foo.org",
          :use_ssl => true,
          :moderation_email_recipients => "foo@bar.org",
          :moderation_email_from => "site@site.org",
          :use_local_css => true,
          :valid_elements_for_tiny_mce => "a",
          :home_page_feed => "http://feed.org/rss",
          :rake_path => "/usr/sbin/rake"
          
    }, as_user(:marcos)
    assert_redirected_to admin_settings_path
    assert_equal Hyperactive.site_name, "foo"
    assert_equal Hyperactive.site_name, Setting.find_by_key("site_name").value
    assert_equal Hyperactive.banner_image, "foo.jpg"
    assert_equal Hyperactive.banner_image, Setting.find_by_key("banner_image").value
    assert_equal Hyperactive.torrent_tracker, "http://foo.org"
    assert_equal Hyperactive.torrent_tracker, Setting.find_by_key("torrent_tracker").value
    assert_equal Hyperactive.use_ssl, true
    assert_equal Hyperactive.use_ssl, Setting.find_by_key("use_ssl").value
    assert_equal Hyperactive.moderation_email_recipients, "foo@bar.org"
    assert_equal Hyperactive.moderation_email_recipients, Setting.find_by_key("moderation_email_recipients").value
    assert_equal Hyperactive.moderation_email_from, "site@site.org"
    assert_equal Hyperactive.moderation_email_from, Setting.find_by_key("moderation_email_from").value
    assert_equal Hyperactive.use_local_css, true
    assert_equal Hyperactive.use_local_css, Setting.find_by_key("use_local_css").value
    assert_equal Hyperactive.valid_elements_for_tiny_mce, "a"
    assert_equal Hyperactive.valid_elements_for_tiny_mce, Setting.find_by_key("valid_elements_for_tiny_mce").value
    assert_equal Hyperactive.home_page_feed, "http://feed.org/rss"
    assert_equal Hyperactive.home_page_feed, Setting.find_by_key("home_page_feed").value
    assert_equal Hyperactive.rake_path, "/usr/sbin/rake"
    assert_equal Hyperactive.rake_path, Setting.find_by_key("rake_path").value
    assert_equal Hyperactive.show_site_name_in_banner, false
    assert_equal Hyperactive.show_site_name_in_banner, Setting.find_by_key("show_site_name_in_banner").value
  end

end
