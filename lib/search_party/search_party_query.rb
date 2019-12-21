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
        queries[attribute] << " AND #{cast_according_to_adapter(attribute_deep)} = "\
                                "'#{params[attribute_deep.to_sym].to_s.downcase}'"
      else
        queries[attribute_deep] = "#{cast_according_to_adapter(attribute_deep)} = "\
                                "'#{params[attribute_deep.to_sym].to_s.downcase}'"
      end
    end

    def build_base_queries(attributes)
      attributes.each do |attribute|
        if params[:search].present?
          queries[attribute] = "#{cast_according_to_adapter(attribute)} LIKE "\
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

    def cast_according_to_adapter(column_name)
      if db_sqlite3?
        "LOWER(CAST(#{column_name} AS TEXT))"
      elsif db_postgresql?
        "LOWER(#{column_name}::VARCHAR)"
      else
        raise "SearchParty does not support #{ActiveRecord::Base.connection.class}"
      end
    end

    def db_sqlite3?
      ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::SQLite3Adapter
    end

    def db_postgresql?
      ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
    end
  end
end