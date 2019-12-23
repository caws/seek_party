module SeekParty
  class SeekPartyQueryBuilder

    attr_accessor :params,
                  :sp_query

    def initialize(params)
      @params = params
      @sp_query = SPQuery.new(params: params)
    end

    def build_query(sp_attributes)
      return unless params

      build_base_queries(sp_attributes)

      @sp_query.build_final_query
    end

    private

    def build_subquery_string(attribute, attribute_deep)
      if params[:search].present?
        @sp_query.add_attribute_query(attribute, " AND #{build_equals_query(attribute_deep)}")
      else
        @sp_query.set_attribute_query(attribute_deep, build_equals_query(attribute_deep))
      end
    end

    def build_base_queries(spattribute)
      spattribute.attributes.each do |attribute|
        if params[:search].present?
          full_column_name = spattribute.get_full_column_name(attribute)
          cast_column_name = cast_according_to_adapter(full_column_name)
          @sp_query.set_attribute_query(attribute, "#{cast_column_name} LIKE "\
                                                 "'%#{params[:search].downcase}%'")
        end

        # If there are other params being used other than :search
        # it means a where clause is needed.
        # TODO: Figure out a way to work with date intervals, too.
        spattribute.attributes.each do |attribute_deep|
          next unless params[attribute_deep.to_sym]

          build_subquery_string(attribute, attribute_deep)
        end
      end
    end

    def cast_according_to_adapter(column_name)
      if db_sqlite3?
        "LOWER(CAST(#{column_name} AS TEXT))"
      elsif db_postgresql?
        "LOWER(#{column_name}::VARCHAR)"
      else
        raise "SeekParty does not support #{ActiveRecord::Base.connection.class}."
      end
    end

    def build_equals_query(attribute)
      "#{cast_according_to_adapter(attribute)} = "\
      "'#{@params[attribute.to_sym].to_s.downcase}'"
    end

    def db_sqlite3?
      ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::SQLite3Adapter
    rescue StandardError
      false
    end

    def db_postgresql?
      ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
    rescue StandardError
      false
    end
  end
end