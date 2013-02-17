require 'securerandom'

class EntitySystem::Manager
  UNTAGGED = ''

  attr_reader :factory

  def initialize
    @entities = []
    @factory = EntitySystem::Factory.new(self)
    @ids_to_tags = Hash.new
    @tags_to_ids = Hash.new
    @components = Hash.new
  end

  def create(tag = UNTAGGED)
    entity = SecureRandom.uuid
    @entities << entity
    @ids_to_tags[entity] = tag
    if @tags_to_ids.has_key?(tag)
      @tags_to_ids[tag] << entity
    else
      @tags_to_ids[tag] = [entity]
    end
    entity
  end

  def destroy(entity)
    @components.each_value do |store|
      store.delete(entity)
    end
    @tags_to_ids.each_key do |tag|
      if @tags_to_ids[tag].include?(entity)
        @tags_to_ids[tag].delete(entity)
      end
    end
    @ids_to_tags.delete(entity)
    @entities.delete(entity)
  end

  def attach(entity, component)
    store = component_store(component.class)
    component.entity = entity
    store[entity] = component
  end

  def remove(entity, component)
    store = component_store(component.class)
    component.entity = nil
    store[entity] = nil
  end

  def component(component_class, entity)
    component_store(component_class)[entity]
  end

  def components(component_class)
    component_store(component_class).values
  end

  def entities(component_class)
    component_store(component_class).keys
  end

  def all(tag)
    @tags_to_ids[tag] || []
  end

  def find(tag)
    all(tag).first
  end

  def tag(entity)
    @ids_to_tags[entity]
  end

  def size
    @entities.size
  end

  private

  def component_store(component_class)
    @components[component_class] ||= Hash.new
  end
end
