class EntitySystem::Component

  attr_accessor :entity

  def self.provides(*attribute_list)
    attribute_list.each do |key|
      attr_accessor key
    end
  end

  def initialize(attributes = {})
    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end
