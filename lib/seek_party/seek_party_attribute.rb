module SeekParty
  class SeekPartyAttribute
    attr_accessor :inspected_class,
                  :white_list,
                  :black_list

    def initialize(inspected_class, white_list, black_list)
      @inspected_class = inspected_class
      @white_list = white_list
      @black_list = black_list
    end

    # Compare attributes to params passed
    # If only search is present, query against all params
    # If both search and other attributes match against the
    # params hash, query against them too.
    def discover_attributes
      check_attributes @inspected_class.new
    end

    private

    def check_attributes(another_model)
      return nil if another_model.nil?

      sp_attribute = SPAttribute.new(table_name: get_table_name)

      another_model.attributes.keys.each do |attribute|
        next unless another_model.has_attribute? attribute
        next if black_listed? attribute

        sp_attribute.add_attribute(attribute) if white_listed? attribute
      end

      sp_attribute
    end

    def white_listed?(attribute_name)
      return true if @white_list.nil?

      @white_list.include? attribute_name
    end

    def black_listed?(attribute_name)
      @black_list.include? attribute_name
    end

    def get_table_name
      @inspected_class.table_name.underscore
    end
  end
end