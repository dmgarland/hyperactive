module ContentControllerTest
    
  def test_index
    get :index
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
  
  # There is one fixture with a promoted event.
  def test_list_promoted
    get :list_promoted
    assert_response :success
    assert_template 'list_promoted'
    assert_not_nil assigns(:content)
    assert_equal 2, assigns(:content).size
  end

  def test_a_show
    get :show, {:id => @first_id}
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:content)
    assert assigns(:content).valid?
    assert_match(/Report or administer this #{class_name}/, @response.body, "Unhidden content should show hiding controls even if user not logged in.")
  end
  
  def test_a_show_as_admin
    get :show, {:id => @first_id}, as_user(:marcos)
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:content)
    assert assigns(:content).valid?
    assert_match(/Report or administer this #{class_name}/, @response.body, "Unhidden content should show hiding controls.")
  end  
  
  def test_a_show_hidden
    get :show, {:id => @hidden_id}
    #assert_match(/Unhide this #{class_name}/, @response.body)
    assert_match(/This #{class_name} has been hidden/, @response.body)
  end
  
  def test_a_show_hidden_as_admin
    get :show, {:id => @hidden_id}, as_user(:marcos)
    #assert_match(/This #{class_name} has been hidden/, @response.body)
    assert_match(/Unhide this #{class_name}/, @response.body)
  end  

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:content)
  end
  
  def test_create
    num_content = model_class.count
    post :create, :content => {
                              :title => "Test content",
                              :date => 3.hours.from_now,
                              :body => "This is a test",
                              :summary => "A summary",
                              :published_by => "Yoss", 
                              :place => "London", 
                              :collective_ids => [collectives(:indy_london).id]
                            }, 
                  #:photo => {:foo_photo => {:title => "test", :file => upload("test/fixtures/fight_test.wmv.jpg")}},         
                  #:video => {:foo_video => {:title => "test", :file => upload("test/fixtures/fight_test.wmv")}},                                   
                  :tags => "blah, foo bar",
                  :place_tags => "london, brixton"
                  
    content = model_class.find_by_title("Test content")
    assert_equal "Test content", content.title
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
    assert assigns(:content).collectives.include?(collectives(:indy_london))
  end  
  
  def test_moderation_status_retained_when_specifically_set_at_creation
    num_content = model_class.count
    post :create, :content => {
                              :title => "Test content2",
                              :date => 3.hours.from_now,
                              :body => "This is a test",
                              :summary => "A summary",
                              :moderation_status => "promoted",
                              :published_by => "Yoss", 
                              :place => "London" 
                            }, 
                  :tags => "blah, foo bar",
                  :place_tags => ""
                  
    content = model_class.find_by_title("Test content2")
    assert_match("foo", content.tag_list)
    assert_match("bar", content.tag_list)
    assert_match("blah", content.tag_list)
    assert_no_match(/,/, content.tag_list)
    if model_class == Event
      assert content.taggings.map(&:event_date).include?(content.date)
    end
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_equal num_content + 1, model_class.count
    assert_equal "promoted", content.moderation_status    
  end
  
  def test_edit_does_not_work_for_anonymous
    get :edit, :id => @first_id
    assert_security_error
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
    assert_security_error
  end
  
  def test_update_works_for_content_owner
    post :update, {:id => @first_id, :title => "Updated title", :tags => "", :place_tags => ""}, as_user(:registered_user)
    assert_redirected_to :action => "show"   
  end

  def test_update_works_for_content_collective_member
    post :update, {:id => @first_id, :title => "Updated title", :tags => "", :place_tags => ""}, as_user(:registered_user_2)
    assert_redirected_to :action => "show"   
  end
  
  def test_update_does_not_work_for_non_collective_member
    post :update, {:id => @first_id, :title => "Updated title", :tags => "", :place_tags => ""}, as_user(:hider_user)
    assert_security_error 
  end
  
  def test_update_works_for_admin
    post :update, {:id => @first_id, :title => "Updated title", :tags => "", :place_tags => ""}, as_user(:marcos)
    assert_redirected_to :action => "show"      
  end  
  
  def test_update_associates_content_with_collective
    post :update, {:id => @first_id, :content => {:title => "Updated title", :collective_ids=>[collectives(:indy_london).id]}, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert_redirected_to :action => "show"   
    assert assigns(:content).title = "Updated title"
    assert assigns(:content).collectives.include?(collectives(:indy_london)), "This content should be associated with the Indy London collective."
    
    post :update, {:id => @first_id, :content => {:title => "Updated title2", :collective_ids=>[]}, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert_redirected_to :action => "show"   
    assert assigns(:content).title = "Updated title2"
    assert !assigns(:content).collectives.include?(collectives(:indy_london)), "This content shouldn't be in any collective."    
  end
  
  def test_admin_controls
    get :admin_controls, {:id => 1}, {:rbac_user_id => users(:marcos).id } 
    assert_response :success
    assert_template '_admin_controls'
  end  
    
  def test_admin_controls_by_anonymous_should_return_report_controls
    get :admin_controls, {:id => 1}
    assert_response :success
    assert_template '_report_this_controls'
  end    
  
  private
  
  def class_name
    model_class.to_s.humanize.downcase
  end
  
end