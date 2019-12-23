module SeekParty
  class SeekPartyEngine
    attr_accessor :seek_party_attribute,
                  :seek_party_query,
                  :inspected_class

    def initialize(inspected_class,
                   params: {},
                   white_list: nil,
                   black_list: nil,
                   scopes: {})
      @seek_party_attribute = SeekPartyAttribute.new(inspected_class,
                                                     white_list,
                                                     black_list)
      @seek_party_query = SeekPartyQueryBuilder.new(params)
      @inspected_class = inspected_class
      @scopes = scopes
    end

    def search
      spa_attribute = seek_party_attribute.discover_attributes
      final_query = seek_party_query.build_query(spa_attribute)
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