class SPAttribute
  attr_accessor :attributes, :table_name

  def initialize(attributes: [], table_name: nil)
    @attributes = attributes
    @table_name = table_name
  end

  def add_attribute(attribute)
    @attributes << attribute
  end

  def get_full_column_name(attribute)
    if @attributes.include? attribute
      "#{@table_name}.#{attribute}"
    else
      raise 'Attribute not present in the attribute list.'
    end
  end
end