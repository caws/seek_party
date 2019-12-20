module SearchParty
  class SearchPartyEngine
    attr_accessor :search_party_attribute,
                  :search_party_query,
                  :inspected_class

    def initialize(params, inspected_class, white_list: nil, black_list: nil)
      self.search_party_attribute = SearchPartyAttribute.new(inspected_class, white_list, black_list)
      self.search_party_query = SearchPartyQuery.new(params)
      self.inspected_class = inspected_class
    end

    def search
      attributes = search_party_attribute.discover_attributes
      final_query = search_party_query.build_query(attributes)
      run_search(final_query)
    end

    private

    def run_search(final_query)
      inspected_class.where(final_query)
    end
  end
end