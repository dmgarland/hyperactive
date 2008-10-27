# Slugger
require 'iconv'
module Slugger
  
  # Slugger.escape(string) transform the string to URL ready version
  class << self
    def escape(str)
      str = str.gsub(/'+/i, "@") # initial commas to non ASCII char
      str = Iconv.iconv('ascii//translit', 'utf-8', str).to_s # transform UTF-8 chars to the ASCII equivalent or convination (example: ø => o, á => 'a)
      str.gsub!(/'+/i, "") # remove new commas generated in the translit
      str.gsub!(/[\W_]+/, '-') # all non-word chars to dashes (including underscores)
      str.gsub!(/(^( |-)+)|(( |-)+$)/, '')            # remove initial and final espaces or dashes
      str.downcase!
      str
    end
  end
  
  # ActiveRecord extension to get our own error raise when a redirection is found, and rescue it in the controller to perform the redirection
  # See ActionControllerExtension
  module SlugRedirect
    class SlugRedirectFound < ActiveRecord::ActiveRecordError
    end
  end
  
  module ActionControllerExtension
    def self.included(base)
      base.class_eval do
        rescue_from ActiveRecord::SlugRedirectFound, :with => :slugger_redirect
        def slugger_redirect
          redirect_to :id => session[:slug_redirect_to] , :status=>301
        end
        
        # this is the magic function to access session variables from the model.
        ###########################
        # [REGRET NOTE] I know that access to sessions in the models is a bad idea, and probably I need to do it because I don't have a clue,
        # but I really can't find a solution with the same functionallity by the 'proper' way. Any suggestions?
        around_filter :i_dont_have_bloody_clue
          protected
          def i_dont_have_bloody_clue
            klasses = [ActiveRecord::Base, ActiveRecord::Base.class]
            #methods = ["session", "cookies", "params", "request"]
            methods = ["session"]
            methods.each do |shenanigan|
              oops = instance_variable_get(:"@_#{shenanigan}") 
              klasses.each do |klass|
                klass.send(:define_method, shenanigan, proc { oops })
              end
            end
            yield
            methods.each do |shenanigan|      
              klasses.each do |klass|
                klass.send :remove_method, shenanigan
              end
            end
          end
        ###########################
        
      end
    end
  end
  
  module ActiveRecordExtension
    
    def self.included(base)
      base.extend ClassMethods
    end
  
    module ModToParam
      # change the rails to_param function to get the given field as parameter in ActionPack URL generation (for example link_to, url_for etc.)
      def to_param
        send("#{self.class.slug_field}")
      end
    end
    
    # ActiveRecord extension
    module ClassMethods
      attr_accessor :slug_attributes
      attr_accessor :slug_field
      attr_accessor :slug_scope
      attr_accessor :slug_on_update
      
      # new function in our model to use and configure slugs
      def has_slug(attr_names = [], options = {})
        # get the configuration
        self.slug_attributes = Array(attr_names)
        self.slug_field = options[:to] || :slug
        self.slug_scope = options[:scope]
        self.slug_on_update = options[:on_update]
        # create the slug when the validation is passed
        after_validation :create_unique_slug
        # destroy the redirections of a destroyed record
        after_destroy :destroy_redirections
        # change the default to_param function. See ModToParam.
        self.send(:include, Slugger::ActiveRecordExtension::ModToParam) if attr_names != nil
        class << self
          # modify the ActiveRecord find function to find by slug
          def find_with_slug(*args)
            case args.first
            when String
              # if the argument is a string means that we are finding by slug
              records = eval("find_by_"+self.slug_field.to_s+"(args.first)")
              if records.nil?
                if self.slug_on_update == :redirect
                  # if we don't find the record by slug, and we are using redirection, we have to search in the redirection model
                  # since we can have the same slug for different models or different scopes we need to use that conditions
                  redirection = SlugRedirection.find_by_from(args.first, :conditions => "model='"+self.name+"' and scope='"+self.slug_scope.to_s+"'")
                  if !redirection.nil?
                    # if a redirection is found we raise our own error to be rescued from the controller and perform the redirection
                    # we need to indicate to the controller the new slug. I decided use a session variable, although it isn't a good practice
                    ###########
                    # Access to session from a model is very hacky. See #[REGRET NOTE]
                    session[:slug_redirect_to] = redirection.to
                    ###########
                    raise(ActiveRecord::SlugRedirectFound)

                  else
                    # if any record is found, and we are using redirection, we raise an ActiveRecord::RecordNotFound
                    raise ActiveRecord::RecordNotFound, "Couldn't find Post with slug=" + args.first + ' or any asociated redirection'
                  end

                else
                  # if any record is found, and we aren't using redirection, we raise an ActiveRecord::RecordNotFound
                  raise ActiveRecord::RecordNotFound, "Couldn't find Post with slug=" + args.first
                end
              end
              records
            else
              # if the argument is a number means that we are searching by ID from the controller (Model.find(1))
              # so we can use the default find function
              find_without_slug(*args)
            end
          end
          alias_method_chain :find,:slug
        end
      end
    end
  protected
    # function called after the validation of the new record
    def create_unique_slug
      update_to = false
      if !send(self.class.slug_field).to_s.empty? and self.class.slug_on_update == :redirect
        # if we are using redirection and we had a previous slug, create the redirection, filling the 'from' field with the actual slug
        # the field 'to' is created after the creation of the new slug 
        slug_redirection = SlugRedirection.new()
        slug_redirection.from = send(self.class.slug_field)
        slug_redirection.model = self.class.name
        slug_redirection.scope = self.class.slug_scope.to_s
        update_to = true
      end
      if send(self.class.slug_field).to_s.empty? or self.class.slug_on_update == :overwrite or self.class.slug_on_update == :redirect
        # if there isn't a slug, or we are using the overwrite or redirect option we can update the slug field
        # the function create_slug_for escapes the string to be URL ready
        send("#{self.class.slug_field}=", create_slug_for(self.class.slug_attributes))
      end
      
      # create the new slug depending on the configuration ()
      base       = send(self.class.slug_field)
      counter    = 1
      # oh how i wish i could use a hash for conditions
      conditions = ["#{self.class.slug_field} = ?", send(self.class.slug_field)]
      unless new_record?
        # we are updating
        conditions.first << " and id != ?"
        conditions       << id
      end
      if self.class.slug_scope
        # if we are using scope, add the condition
        conditions.first << " and #{self.class.slug_scope} = ?"
        conditions       << send(self.class.slug_scope)
      end
      while self.class.count(:all, :conditions => conditions) > 0
        # if the slug exist, add -# at the end
        conditions[1] = "#{base}-#{counter += 1}"
      end
      # add the created slug to the field
      send("#{self.class.slug_field}=", conditions[1])
      if self.class.slug_on_update == :redirect and update_to == true
        # if we are using redirection, now we have the new slug to finish the new redirect record
        slug_redirection.to = send(self.class.slug_field)
        slug_redirection.save!
        
        #check the existing redirections
        SlugRedirection.find(:all, :conditions => "model = '"+slug_redirection.model+"' and scope = '"+slug_redirection.scope+"' and `to` = '"+slug_redirection.from+"'").each do |record_to_update|
        if record_to_update.from == slug_redirection.to
          # avoid loops in redirections
          record_to_update.destroy
        else
          # update the previous redirections to the new slug
          record_to_update.to = slug_redirection.to
          record_to_update.save!
        end
        end
      end
    end
    # create URL ready version of the fields given values
    def create_slug_for(attr_names)
      attr_names.collect do |attr_name| 
        Slugger.escape(send(attr_name).to_s)
      end.join('-')
    end
    # function called after the record is destroyed, to destroy its redirections as well
    def destroy_redirections
      if self.class.slug_on_update == :redirect
        SlugRedirection.destroy_all "model = '"+self.class.name+"' and scope = '"+self.class.slug_scope.to_s+"' and `to` = '"+send(self.class.slug_field)+"'"
      end
    end
  end
end
