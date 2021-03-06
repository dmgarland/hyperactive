module ContentControllerTest
  include ::ActionView
  include ::ActionView::Helpers
  include ::ActionView::Helpers::UrlHelper

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:content)
    assert_equal 6, assigns(:content).size
  end

  def test_index_iphone
    get :index, {:format => "iphone"}
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:content)
    assert_equal 6, assigns(:content).size
  end

  def test_archives
    get :archives
    assert_response :success
    assert_template 'archives'
    assert_not_nil assigns(:content)
    assert_equal 6, assigns(:content).size
  end

  def test_archives_iphone
    get :archives, {:format => "iphone"}
    assert_response :success
    assert_template 'archives'
    assert_not_nil assigns(:content)
    assert_equal 6, assigns(:content).size
  end

  def test_list_promoted
    get :promoted
    assert_response :success
    assert_template 'promoted'
    assert_not_nil assigns(:content)
    assert_equal 2, assigns(:content).size,
      "There should be 2 promoted #{model_class.to_s.downcase.pluralize} in the fixtures."
  end

  def test_list_promoted_iphone
    get :promoted, {:format => "iphone"}
    assert_response :success
    assert_template 'promoted'
    assert_not_nil assigns(:content)
    assert_equal 2, assigns(:content).size,
      "There should be 2 promoted #{model_class.to_s.downcase.pluralize} in the fixtures."
  end

  def test_a_show
    get :show, {:id => @first_id}
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:content)
    assert assigns(:content).valid?
    assert_match(/#{I18n.t('shared.content.admin_controls.report_or_administer', :class_name => class_name)}/, @response.body, "Unhidden content should show hiding controls even if user not logged in.")
  end

  def test_a_show_iphone
    get :show, {:id => @first_id, :format => "iphone"}
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:content)
    assert assigns(:content).valid?
  end

  def test_a_show_as_admin
    get :show, {:id => @first_id}, as_user(:marcos)
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:content)
    assert assigns(:content).valid?
    assert_match(/#{I18n.t('shared.content.admin_controls.report_or_administer', :class_name => class_name)}/, @response.body, "Unhidden content should show hiding controls.")
  end

  def test_a_show_hidden
    get :show, {:id => @hidden_id}
    #assert_match(/Unhide this #{class_name}/, @response.body)
    assert_match(/#{I18n.t('shared.content.hidden_notice', :class_name => class_name, :editorial_guidelines => link_to("editorial guidelines", "/pages/editorial-guidelines"))}/, @response.body)
  end

  def test_a_show_hidden_as_admin
    get :show, {:id => @hidden_id}, as_user(:marcos)
    #assert_match(/This #{class_name} has been hidden/, @response.body)
    assert_match(/#{I18n.t('shared.content.admin_controls.unhide_this', :class_name => class_name)}/, @response.body)
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:content)
  end

  def test_new_iphone
    get :new, :format => "iphone"
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:content)
  end

  def test_create
    num_content = model_class.count
    post :create, params_for_valid_content

    content = model_class.find_by_title("Test content2")
    assert_equal "Test content2", content.title
    assert_match("foo", content.tag_list)
    assert_match("bar", content.tag_list)
    assert_match("london", content.place_tag_list)
    assert_match("brixton", content.place_tag_list)
    assert_no_match(/,/, content.tag_list)
    assert_no_match(/,/, content.place_tag_list)
    if model_class == Event
      assert content.taggings.map(&:event_date).include?(content.date)
    end
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_equal num_content + 1, model_class.count
    assert_equal "published", content.moderation_status
    assert assigns(:content).collective == collectives(:indy_london)
  end

  def test_create_with_open_street_map_info
    num_content = model_class.count
    lat = 51.4615
    lng = -0.1149
    zoom = 17
    post :create, params_for_valid_content.merge(:open_street_map_info => {:lat => lat, :lng => lng, :zoom => zoom})

    content = model_class.find_by_title("Test content2")
    assert_equal "Test content2", content.title
    assert_match("foo", content.tag_list)
    assert_match("bar", content.tag_list)
    assert_match("london", content.place_tag_list)
    assert_match("brixton", content.place_tag_list)
    assert_no_match(/,/, content.tag_list)
    assert_no_match(/,/, content.place_tag_list)
    if model_class == Event
      assert content.taggings.map(&:event_date).include?(content.date)
    end
    assert_response :redirect
    assert_equal num_content + 1, model_class.count
    assert_equal "published", content.moderation_status
    assert content.collective == collectives(:indy_london)
    assert_equal content.open_street_map_info.lat, lat
    assert_equal content.open_street_map_info.lng, lng
    assert_equal content.open_street_map_info.zoom, zoom
  end

  def test_create_without_open_street_map_info
    post :create, params_for_valid_content, as_user(:marcos)
    assert assigns(:content)
    assert_nil assigns(:content).open_street_map_info
  end

  def test_create_for_user_with_auto_promote_does_auto_promote
    post :create, params_for_valid_content, as_user(:registered_user_3)
    assert assigns(:content).moderation_status == "promoted"
  end

  def test_create_for_user_without_auto_promote_is_published
    post :create, params_for_valid_content, as_user(:registered_user_2)
    assert assigns(:content).moderation_status == "published"
  end

  def test_moderation_status_cant_be_set_to_featured_without_feature_permission
    post :create, params_for_valid_content
    assert_equal assigns(:content).moderation_status, "published"
  end

  def test_moderation_status_cant_be_set_to_promoted_without_promoted_permission
    post :create, params_for_valid_content
    assert_equal assigns(:content).moderation_status, "published"
  end

  def test_moderation_status_cant_be_set_to_hidden_without_hidden_permission
    post :create, params_for_valid_content
    assert_equal assigns(:content).moderation_status, "published"
  end

  def test_moderation_status_can_be_set_to_featured_with_feature_permission
    content_hash = params_for_valid_content
    content_hash[:content][:moderation_status] = "featured"
    post :create, content_hash, as_user(:marcos)
    assert_equal "featured", assigns(:content).moderation_status, "featured content should be featured."
  end

  def test_moderation_status_can_be_set_to_published_with_hide_permission
    content = Content.find(@first_id)
    content.moderation_status = "hidden"
    content.save!
    put :update, {:id => @first_id, :content => {:moderation_status => "published"},:tags => "", :place_tags => ""}, as_user(:marcos)
    assert_equal assigns(:content).moderation_status, "published"
  end

  def test_moderation_status_cannot_be_set_to_published_without_hide_permission
    content = Content.find(@first_id)
    content.moderation_status = "hidden"
    content.save!
    put :update, {:id => @first_id, :content => {:moderation_status => "published"},:tags => "", :place_tags => ""}, as_user(:registered_user)
    assert_equal assigns(:content).moderation_status, "hidden"
  end

  def test_moderation_status_can_be_updated_with_feature_permission
    put :update, {:id => @first_id, :content => {:moderation_status => "featured"},:tags => "", :place_tags => ""}, as_user(:marcos)
    assert_equal assigns(:content).moderation_status, "featured"
  end

  def test_moderation_status_cannot_be_updated_without_feature_permission
    original_status = Content.find(@first_id).moderation_status
    put :update, {:id => @first_id, :content => {:moderation_status => "featured"},:tags => "", :place_tags => ""}, as_user(:registered_user)
    assert_equal original_status, assigns(:content).moderation_status
  end

  def test_moderation_status_can_be_updated_with_promote_permission
    put :update, {:id => @first_id, :content => {:moderation_status => "promoted"},:tags => "", :place_tags => ""}, as_user(:marcos)
    assert_equal assigns(:content).moderation_status, "promoted"
    content = Content.find(@first_id)
    assert_equal content.moderation_status, "promoted"
  end

  def test_moderation_status_cannot_be_updated_without_promote_permission
    content = Content.find(@first_id)
    content.moderation_status = "published"
    content.save!
    put :update, {:id => @first_id, :content => {:moderation_status => "promoted"},:tags => "", :place_tags => ""}, as_user(:registered_user)
    assert_equal "published", assigns(:content).moderation_status
  end

  def test_updating_open_street_map_info
    lat = 51.4615
    lng = -0.1149
    zoom = 17
    put :update, {:id => @first_id, :open_street_map_info => {:lat => lat, :lng => lng, :zoom => zoom}, :content => {:moderation_status => "published"}, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert assigns(:content)
    assert_equal assigns(:content).open_street_map_info.lat, lat
    assert_equal assigns(:content).open_street_map_info.lng, lng
    assert_equal assigns(:content).open_street_map_info.zoom, zoom
  end

  def test_deleting_open_street_map_info
    put :update, {:id => @first_id, :content => {:moderation_status => "published"}, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert assigns(:content)
    assert_nil assigns(:content).open_street_map_info
  end

  def test_edit_does_not_work_for_anonymous
    get :edit, :id => @first_id
    assert_login_necessary
  end

  def test_edit_works_for_content_owner
    get :edit, {:id => @first_id}, as_user(:registered_user)
    assert_response :success
  end

  def test_edit_works_for_content_collective_member
    get :edit, {:id => @first_id}, as_user(:registered_user_2)
    assert_response :success
  end

  def test_edit_does_not_work_for_non_collective_member
    get :edit, {:id => @first_id}, as_user(:hider_user)
    assert_security_error
  end

  def test_edit_works_for_admin
    get :edit, {:id => @first_id}, as_user(:marcos)
    assert_response :success
  end

  def test_update_does_not_work_for_anonymous
    put :update, {:id => @first_id, :title => "Updated title"}
    assert_login_necessary
  end

  def test_update_works_for_content_owner
    post :update, {:id => @first_id, :content => {:title => "Updated title"}, :tags => "", :place_tags => ""}, as_user(:registered_user)
    assert_redirected_to :action => "show"
  end

  def test_update_works_for_content_collective_member
    post :update, {:id => @first_id, :content => {:title => "Updated title"}, :tags => "", :place_tags => ""}, as_user(:registered_user_2)
    assert_redirected_to :action => "show"
  end

  def test_update_does_not_work_for_non_collective_member
    post :update, {:id => @first_id, :content => {:title => "Updated title"}, :tags => "", :place_tags => ""}, as_user(:hider_user)
    assert_security_error
  end

  def test_update_works_for_admin
    post :update, {:id => @first_id, :content => {:title => "Updated title"}, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert_redirected_to :action => "show"
  end

  def test_update_associates_content_with_collective
    post :update, {:id => @first_id, :content => {:title => "Updated title", :collective_id => collectives(:indy_london).id}, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert_redirected_to :action => "show"
    assert assigns(:content).title = "Updated title"
    assert assigns(:content).collective == collectives(:indy_london), "This content should be associated with the Indy London collective."

    post :update, {:id => @first_id, :content => {:title => "Updated title2", :collective_id => "" }, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert_redirected_to :action => "show"
    assert assigns(:content).title = "Updated title2"
    assert assigns(:content).collective.nil?, "This content shouldn't be in any collective."
  end

  def test_admin_controls
    get :admin_controls, {:id => @first_id}, {:rbac_user_id => users(:marcos).id }
    assert_response :success
    assert_template '_admin_controls'
  end

  def test_admin_controls_by_collective_member_should_return_admin_controls
    get :admin_controls, {:id => @first_id}, {:rbac_user_id => users(:registered_user_2).id }
    assert_response :success
    assert_template '_admin_controls'
  end

  def test_admin_controls_by_anonymous_should_return_report_controls
    get :admin_controls, {:id => @first_id}
    assert_response :success
    assert_template '_report_this_controls'
  end

  def test_comment_form_works
    get :show_comment_form, {:id => @first_id}
    assert_response :success
    assert assigns(:content)
    assert assigns(:comment)
  end

  def test_create_comment_works
    original_length = Content.find(@first_id).comments.length
    post :create_comment, :id => @first_id, :comment => {:title => "foo comment", :body => "blah blah blah talking some shit", :published_by => "noam chomsky"}
    assert_redirected_to :action => :show, :id => @first_id
    assert_equal "Your comment has been added.", flash[:notice]
    assert_equal original_length + 1, assigns(:content).comments.length
  end

  def test_create_comment_does_not_work_on_hidden_content
    original_length = Content.find(@hidden_id).comments.length
    post :create_comment, :id => @hidden_id, :comment => {:title => "foo comment", :body => "blah blah blah talking some shit", :published_by => "noam chomsky"}
    assert_redirected_to :action => :show, :id => @hidden_id
    assert_equal "Comments are not allowed for this #{assigns(:content).class.to_s.downcase.humanize}", flash[:notice]
    assert_equal original_length, assigns(:content).comments.length
  end

  private

  def class_name
    case model_class.to_s.humanize.downcase
      when 'article'
        (I18n.t 'content.class_names.article').downcase
      when 'event'
        (I18n.t 'content.class_names.event').downcase
      when 'video'
        (I18n.t 'content.class_names.video').downcase
      when 'comment'
        (I18n.t 'content.class_name.comment').downcase
    end
  end

  def params_for_valid_content
    {:content => {
                          :title => "Test content2",
                          :date => 3.hours.from_now,
                          :body => "This is a test",
                          :summary => "A summary",
                          :published_by => "Yoss",
                          :place => "London",
                          :collective_id => collectives(:indy_london).id
                        },
                  :link =>{"1245612794"=>{"title"=>"tttitle", "url"=>"http://bowie.com", "description"=>"asdfadsf"}},
                  :tags => "blah, foo bar",
                  :place_tags => "london brixton"}
  end

end

