# FriendlyId is a Rails plugin which lets you use text-based ids in addition
# to numeric ones.
module FriendlyId

  # This error is raised when it's not possible to generate a unique slug.
  SlugGenerationError = Class.new StandardError

  module ClassMethods

    # Default options for friendly_id.
    DEFAULT_FRIENDLY_ID_OPTIONS = {:method => nil, :use_slug => false, :max_length => 255, :reserved => [], :strip_diacritics => false}.freeze
    VALID_FRIENDLY_ID_KEYS = [:use_slug, :max_length, :reserved, :strip_diacritics].freeze

    # Set up an ActiveRecord model to use a friendly_id.
    #
    # The column argument can be one of your model's columns, or a method
    # you use to generate the slug.
    #
    # Options:
    # * <tt>:use_slug</tt> - Defaults to false. Use slugs when you want to use a non-unique text field for friendly ids.
    # * <tt>:max_length</tt> - Defaults to 255. The maximum allowed length for a slug.
    # * <tt>:strip_diacritics</tt> - Defaults to false. If true, it will remove accents, umlauts, etc. from western characters. You must have the unicode gem installed for this to work.
    # * <tt>:reseved</tt> - Array of words that are reserved and can't be used as slugs. If such a word is used, it will be treated the same as if that slug was already taken (numeric extension will be appended). Defaults to [].
    def has_friendly_id(column, options = {})
      options.assert_valid_keys VALID_FRIENDLY_ID_KEYS
      options = DEFAULT_FRIENDLY_ID_OPTIONS.merge(options).merge(:column => column)
      write_inheritable_attribute :friendly_id_options, options
      class_inheritable_reader :friendly_id_options

      if options[:use_slug]
        has_many :slugs, :order => 'id DESC', :as => :sluggable, :dependent => :destroy
        extend SluggableClassMethods
        include SluggableInstanceMethods
        before_save :set_slug
      else
        extend NonSluggableClassMethods
        include NonSluggableInstanceMethods
      end
    end

  end

  module NonSluggableClassMethods

    def self.extended(base)
      class << base
        alias_method_chain :find_one, :friendly
        alias_method_chain :find_some, :friendly
      end
    end

    # Finds the record using only the friendly id. If it can't be found
    # using the friendly id, then it returns false. If you pass in any
    # argument other than an instance of String or Array, then it also
    # returns false.
    # def find_using_friendly_id()
    #   return false unless slug_text.kind_of?(String)
    #   finder = "find_by_#{self.friendly_id_options[:column].to_s}".to_sym
    #   record = send(finder, slug_text)
    #   record.send(:found_using_friendly_id=, true) if record
    #   return record
    # end
    def find_one_with_friendly(id, options)
      if id.is_a?(String) and result = send("find_by_#{ friendly_id_options[:column] }", id, options)
        result.found_using_friendly_id = true
      else
        result = find_one_without_friendly id, options
      end

      result
    end
    def find_some_with_friendly(ids_and_names, options)
      results_by_name = with_scope :find => options do
        find :all, :conditions => ["#{ quoted_table_name }.#{ friendly_id_options[:column] } IN (?)", ids_and_names]
      end

      names = results_by_name.map { |r| r[ friendly_id_options[:column] ] }
      ids   = ids_and_names - names

      results_by_id = with_scope :find => options do
        find :all, :conditions => ["#{ quoted_table_name }.#{ primary_key } IN (?)", ids]
      end unless ids.empty?

      results = results_by_name + ( results_by_id || [] )

      expected_size = options[:offset] ? ids_and_names.size - options[:offset] : ids_and_names.size
      expected_size = options[:limit] if options[:limit] && expected_size > options[:limit]

      raise ActiveRecord::RecordNotFound, "Couldn't find all #{ name.pluralize } with IDs (#{ ids_and_names * ', ' }) AND #{ sanitize_sql options[:conditions] } (found #{ results.size } results, but was looking for #{ expected_size })" if results.size != expected_size

      results_by_name.each { |r| r.found_using_friendly_id = true }
      results
    end

  end

  module NonSluggableInstanceMethods

    attr :found_using_friendly_id

    # Was the record found using one of its friendly ids?
    def found_using_friendly_id?
      @found_using_friendly_id
    end

    # Was the record found using its numeric id?
    def found_using_numeric_id?
      !@found_using_friendly_id
    end
    alias has_better_id? found_using_numeric_id?

    # Returns the friendly_id.
    def friendly_id
      send friendly_id_options[:column]
    end

    alias best_id friendly_id

    # Returns the friendly id, or if none is available, the numeric id.
    def to_param
      friendly_id || id
    end

    def found_using_friendly_id=(value)
      @found_using_friendly_id = value
    end

  end

  module SluggableClassMethods

    def self.extended(base)
      class << base
        alias_method_chain :find_one, :friendly
        alias_method_chain :find_some, :friendly
      end
    end

    # Finds the record using only the friendly id. If it can't be found
    # using the friendly id, then it returns false. If you pass in any
    # argument other than an instance of String or Array, then it also
    # returns false. When given as an array will try to find any of the
    # records and return those that can be found.
    def find_one_with_friendly(id_or_name, options)
      conditions = Slug.with_name id_or_name

      result = with_scope :find => {:joins => :slugs, :conditions => conditions} do
        find_every(options).first
      end

      if result
        result.init_finder_slug result.slugs.find_by_name(id_or_name)
      else
        result = find_one_without_friendly id_or_name, options
      end

      result
    end
    def find_some_with_friendly(ids_and_names, options)
      slugs = Slug.find_all_by_names_and_sluggable_type ids_and_names, base_class.name

      # seperate ids and slug names
      names = slugs.map { |s| s[:name] }
      ids   = ids_and_names - names

      # search in slugs and own table
      results = []
      results += with_scope(:find => {:joins => :slugs, :conditions => Slug.with_names(names)}) { find_every options } unless names.empty?
      results += with_scope(:find => {:conditions => ["#{ quoted_table_name }.#{ primary_key } IN (?)", ids]}) { find_every options } unless ids.empty?

      # calculate expected size, taken from active_record/base.rb
      expected_size = options[:offset] ? ids_and_names.size - options[:offset] : ids_and_names.size
      expected_size = options[:limit] if options[:limit] && expected_size > options[:limit]

      raise ActiveRecord::RecordNotFound, "Couldn't find all #{ name.pluralize } with IDs (#{ ids_and_names * ', ' }) AND #{ sanitize_sql options[:conditions] } (found #{ results.size } results, but was looking for #{ expected_size })" if results.size != expected_size

      # assign finder slugs
      slugs.each do |slug|
        result = results.find { |r| r.id == slug.sluggable_id } and
        result.init_finder_slug slug
      end

      results
    end
  end

  module SluggableInstanceMethods

    attr :finder_slug

    # Was the record found using one of its friendly ids?
    def found_using_friendly_id?
      !!@finder_slug
    end

    # Was the record found using its numeric id?
    def found_using_numeric_id?
      !found_using_friendly_id?
    end

    # Was the record found using an old friendly id?
    def found_using_outdated_friendly_id?
      @finder_slug.id != slug.id
    end

    # Was the record found using an old friendly id, or its numeric id?
    def has_better_id?
      slug and found_using_numeric_id? || found_using_outdated_friendly_id?
    end

    # Returns the friendly id.
    def friendly_id
      slug.name
    end
    alias best_id friendly_id

    # Returns the most recent slug, which is used to determine the friendly
    # id.
    def slug(reload = false)
      @most_recent_slug = nil if reload
      @most_recent_slug ||= slugs.first
    end

    # Returns the friendly id, or if none is available, the numeric id.
    def to_param
      slug ? slug.name : id
    end

    # Generate the text for the friendly id, ensuring no duplication.
    def generate_friendly_id
      slug_text = truncated_friendly_id_base
      count = Slug.count_matches slug_text, self.class.name, :all, :conditions => "sluggable_id <> #{ id.to_i }"
      count += 1 if self.class.friendly_id_options[:reserved].include?(slug_text)
      count == 0 ? slug_text : generate_friendly_id_with_extension(slug_text, count)
    end

    # Set the slug using the generated friendly id.
    def set_slug
      if self.class.friendly_id_options[:use_slug]
        @most_recent_slug = nil
        slug_text = generate_friendly_id

        if slugs.empty? || slugs.first.name != slug_text
          previous_slug = slugs.find_by_name slug_text
          previous_slug.destroy if previous_slug

          slugs.build :name => slug_text
        end
      end
    end

    # Get the string used as the basis of the friendly id. If you set the
    # option to remove diacritics from the friendly id's then they will be
    # removed.
    def friendly_id_base
      base = send friendly_id_options[:column]
      if base.blank?
        raise SlugGenerationError.new('The method or column used as the base of friendly_id\'s slug text returned a blank value')
      elsif self.friendly_id_options[:strip_diacritics]
        Slug::normalize(Slug::strip_diacritics(base))
      else
        Slug::normalize(base)
      end
    end

    # Sets the slug that was used to find the record. This can be used to
    # determine whether the record was found using the most recent friendly
    # id.
    def init_finder_slug(finder_slug)
      raise RuntimeError, 'Slug already introduced' if @finder_slug
      @finder_slug = finder_slug
      @finder_slug.sluggable = self
    end

    private
    NUM_CHARS_RESERVED_FOR_FRIENDLY_ID_EXTENSION = 2
    def truncated_friendly_id_base
      max_length = friendly_id_options[:max_length]
      slug_text = friendly_id_base[0, max_length - NUM_CHARS_RESERVED_FOR_FRIENDLY_ID_EXTENSION]
    end

    # Reserve a few spaces at the end of the slug for the counter extension.
    # This is to avoid generating slugs longer than the maxlength when an
    # extension is added.
    POSSIBILITIES = 10 ** NUM_CHARS_RESERVED_FOR_FRIENDLY_ID_EXTENSION - 1
    def generate_friendly_id_with_extension(slug_text, count)
      count <= POSSIBILITIES or
      raise FriendlyId::SlugGenerationError.new("slug text #{slug_text} goes over limit for similarly named slugs")

      slug_text = "#{ truncated_friendly_id_base }-#{ count + 1 }"

      count = Slug.count_matches slug_text, self.class.name, :all, :conditions => "sluggable_id <> #{ id.to_i }"
      count > 0 ? "#{ truncated_friendly_id_base }-#{ count + 1 }" : slug_text
    end
  end

end
