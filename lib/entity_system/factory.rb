class EntitySystem::Factory

  def initialize(manager)
    @manager = manager
  end

  def build_entity(type, &block)
    factory = @@factories[type].new
    factory.manager = @manager
    yield factory if block_given?
    factory.construct
  end

  def self.factories
    @@factories ||= {}
  end

  class Base

    attr_accessor :manager

    def self.build(type)
      EntitySystem::Factory.factories[type] = self
      EntitySystem::Factory.class_eval do
        define_method type do |&block|
          build_entity(type, &block)
        end
      end
    end

    def self.using(*attribute_list)
      attribute_list.each do |key|
        attr_accessor key
      end
    end

    # overriden in subclasses
    def construct
    end
  end
end
