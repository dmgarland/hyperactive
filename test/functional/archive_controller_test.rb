require File.dirname(__FILE__) + '/../test_helper'
require 'archive_controller'

class ArchiveControllerTest < ActionController::TestCase

  fixtures :content
  
  def setup
    @controller = ArchiveController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:oldest_date)
    assert_equal 2006, assigns(:oldest_date).year
    assert_equal 2, assigns(:oldest_date).month
  end  
  
  def test_today
    # if these tests are run before 2007, there will be some errors ...
    assert Date.today.year > 2006
  end

  def test_year_index_2006
    get :year_index, :year => '2006'
    assert_response :success
    assert_template 'year_index'
    assert_not_nil assigns(:start_date)
    assert_equal 2006, assigns(:start_date).year
    assert_equal 2, assigns(:start_date).month
    assert_not_nil assigns(:end_date)
    assert_equal 2006, assigns(:end_date).year
    assert_equal 12, assigns(:end_date).month
  end    

  def test_this_year
    get :year_index, :year => Date.today.year.to_s
    assert_response :success
    assert_template 'year_index'
    assert_not_nil assigns(:start_date)
    assert_equal Date.today.year, assigns(:start_date).year
    assert_equal 1, assigns(:start_date).month
    assert_not_nil assigns(:end_date)
    assert_equal Date.today.year, assigns(:end_date).year
    assert_equal Date.today.month, assigns(:end_date).month
  end

  def test_next_year
    next_year = Date.today.year + 1
    get :year_index, :year => next_year.to_s
    assert_redirected_to :action => 'year_index', :year => Date.today.year.to_s
    assert_equal I18n.t('archive.no_future'), flash[:notice]
  end
  
  def test_month_index
    get :month_index, :year => '2006', :month => '2'
    assert_response :success
    assert_template 'month_index'
    assert_not_nil assigns(:start_date)
    assert_equal 2006, assigns(:start_date).year
    assert_equal 2, assigns(:start_date).month
    assert_equal 1, assigns(:start_date).day
    assert_not_nil assigns(:end_date)
    assert_equal 2006, assigns(:end_date).year
    assert_equal 2, assigns(:end_date).month
    assert_equal 28, assigns(:end_date).day
    # should be 5 items ...
    assert_not_nil assigns(:all_content)
    assert_equal 5, assigns(:all_content).count
  end    

  def test_next_month
    next_month = Date.today >> 1
    get :month_index, :year => next_month.year, :month => next_month.month
    assert_redirected_to :action => 'month_index', 
                         :year => Date.today.year.to_s,
                         :month => Date.today.month.to_s
    assert_equal I18n.t('archive.no_future'), flash[:notice]
  end

  def test_this_month
    get :this_month
    assert_redirected_to :action => 'month_index', 
                         :year => Date.today.year.to_s,
                         :month => Date.today.month.to_s
    assert_nil flash[:notice]
  end

  def test_invalid_year
    get :month_index, :year => 'xyz', :month => '1'
    assert_redirected_to :action => 'index'
    assert_equal I18n.t('archive.invalid_date'), flash[:notice]
  end
  
  def test_invalid_month
    get :month_index, :year => '2006', :month => 'abc'
    assert_redirected_to :action => 'index'
    assert_equal I18n.t('archive.invalid_date'), flash[:notice]
  end
  
  # TODO: month_index - featured, promoted, tag, invalid_type
  # tag_index - tag and place_tag
end
