

module ActsAsFerret
  module ClassMethods
    #alias :find_all_by_contents :find_by_contents 
    def paginate_search(query, options = {})
      page, per_page, total = wp_parse_options(options)
      pager = WillPaginate::Collection.new(page, per_page, total)
      options.merge!(:offset => pager.offset, :limit => per_page)
      result = find_by_contents(query, options)
      returning WillPaginate::Collection.new(page, per_page, result.total_hits) do |pager|
        pager.replace result
      end
    end
 
  end
end

