module EnumerateBy::Extensions::Serializer
    # Adds support for automatically converting enumeration attributes to the
    # value represented by them.
    # 
    # == Examples
    # 
    # Suppose the following models are defined:
    # 
    #   class Color < ActiveRecord::Base
    #     enumerate_by :name
    #     
    #     bootstrap(
    #       {:id => 1, :name => 'red'},
    #       {:id => 2, :name => 'blue'},
    #       {:id => 3, :name => 'green'}
    #     )
    #   end
    #   
    #   class Car < ActiveRecord::Base
    #     belongs_to :color
    #   end
    # 
    # Given the above, the enumerator for the car will be automatically
    # used for serialization instead of the foreign key like so:
    # 
    #   car = Car.create(:color => 'red')  # => #<Car id: 1, color_id: 1>
    #   car.to_xml  # => "<car><id type=\"integer\">1</id><color>red</color></car>"
    #   car.to_json # => "{id: 1, color: \"red\"}"
    # 
    # == Conversion options
    # 
    # The actual conversion of enumeration associations can be controlled
    # using the following options:
    # 
    #   car.to_json                           # => "{id: 1, color: \"red\"}"
    #   car.to_json(:enumerations => false)   # => "{id: 1, color_id: 1}"
    #   car.to_json(:only => [:color_id])     # => "{color_id: 1}"
    #   car.to_json(:only => [:color])        # => "{color: \"red\"}"
    #   car.to_json(:include => :color)       # => "{id: 1, color_id: 1, color: {id: 1, name: \"red\"}}"
    # 
    # As can be seen from above, enumeration attributes can either be treated
    # as pseudo-attributes on the record or its actual association.

  def self.included(base) #:nodoc:
    base.class_eval do
      alias_method_chain :serializable_hash, :enumerations
    end
  end
 
  # Automatically converted enumeration attributes to their association
  # names so that they *appear* as attributes
  def serializable_hash_with_enumerations(options = nil)
    attrs = serializable_hash_without_enumerations(options)

    # Adjust the serializable attributes by converting primary keys for
    # enumeration associations to their association name (where possible)
    if options[:enumerations] != false
      new_attrs = {}
      @only_attributes = Array(options[:only]).map(&:to_s)
      @except_attributes = @only_attributes.blank? ? Array(options[:except]).map(&:to_s) : []
      @include_associations = Array(options[:include]).map(&:to_s)

      attrs.each do |attribute,value|
        enumeration_attribute = enumeration_association_for(attribute)
        if enumeration_attribute
          new_attrs[enumeration_attribute] = send(enumeration_attribute).to_s
        else
          new_attrs[attribute] = value
        end
      end

      @only_attributes.each do |attribute|
        new_attrs[attribute] = send(attribute).to_s unless new_attrs.include?(attribute)
      end

      attrs = new_attrs
    end

    attrs
  end
  
  private
  # Should the given attribute be converted to the actual enumeration?
  def convert_to_enumeration?(attribute)
    !@only_attributes.include?(attribute)
  end
  
  # Gets the association name for the given enumeration attribute, if
  # one exists
  def enumeration_association_for(attribute)
    association = enumeration_associations[attribute]
    association if association && convert_to_enumeration?(attribute) && !include_enumeration?(association) && !@except_attributes.include?(association)
  end
  
  # Is the given enumeration attribute being included as a whole record
  # instead of just an individual attribute?
  def include_enumeration?(association)
    @include_associations.include?(association)
  end 

end

ActiveRecord::Base.class_eval do
  include EnumerateBy::Extensions::Serializer
end