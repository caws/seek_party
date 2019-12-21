module SearchParty
  class SearchPartyQuery

    attr_accessor :params,
                  :queries

    def initialize(params)
      self.params = params
      self.queries = ({})
    end

    def build_query(attributes)
      return unless params

      build_base_queries(attributes)
      build_final_query
    end

    private

    def build_subquery_string(attribute, attribute_deep)
      if params[:search].present?
        queries[attribute] << " AND LOWER(#{attribute_deep}::VARCHAR) = "\
                                "'#{params[attribute_deep.to_sym].to_s.downcase}'"
      else
        queries[attribute_deep] = "LOWER(#{attribute_deep}::VARCHAR) = "\
                                "'#{params[attribute_deep.to_sym].to_s.downcase}'"
      end
    end

    def build_base_queries(attributes)
      attributes.each do |attribute|
        if params[:search].present?
          queries[attribute] = "LOWER(#{attribute}::VARCHAR) LIKE "\
                             "'%#{params[:search].downcase}%'"
        end

        # If there are other params being used other than :search
        # it means a where clause is needed.
        # TODO: Figure out a way to work with date intervals, too.
        attributes.each do |attribute_deep|
          next unless params[attribute_deep.to_sym]

          build_subquery_string(attribute, attribute_deep)
        end
      end
    end

    def build_final_query
      final_query = ''
      queries.each do |_key, value|
        next unless value

        final_query << if value == queries[queries.keys.first]
                         value
                       else
                         params[:search].present? ? " OR #{value}" : " AND #{value}"
                       end
      end

      final_query
    end
  end
end