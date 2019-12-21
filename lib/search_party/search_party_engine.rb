module SearchParty
  class SearchPartyEngine
    attr_accessor :search_party_attribute,
                  :search_party_query,
                  :inspected_class

    def initialize(inspected_class, params: params, white_list: nil, black_list: nil, scopes: {})
      @search_party_attribute = SearchPartyAttribute.new(inspected_class, white_list, black_list)
      @search_party_query = SearchPartyQuery.new(params)
      @inspected_class = inspected_class
      @scopes = scopes
    end

    def search
      attributes = search_party_attribute.discover_attributes
      final_query = search_party_query.build_query(attributes)
      run_search(final_query)
    end

    private

    def run_search(final_query)
      # If scopes were passed, iterate trough\ them.
      setup_scopes if @scopes

      # Execute final query (alongside any scopes that have been passed)
      @inspected_class.where(final_query)
    end

    def setup_scopes
      # Iterate trough the scopes that may have been
      # passed. PS: This is more of a luxury than anything
      # else, as the returned object from run_search is an
      # ActiveRecord_Relation object that would accept
      # method chaining
      @scopes.each do |key, value|
        @inspected_class = @inspected_class.method(key).call(value)
      end
    end
  end
end