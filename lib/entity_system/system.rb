class EntitySystem::System
  include GameHelpers
  attr_reader :manager

  def initialize(manager)
    @manager = manager
    setup
  end

  def each(component_class)
    manager.entities(component_class).each do |entity|
      yield(entity, manager.component(component_class, entity))
    end
  end

  # Optionally overriden in subclasses
  def setup
  end

  # Called in the update block, don't draw in here
  def update(delta)
  end

  # Called in the render block, draw in here
  def render(delta)
  end

  def reset
  end

  def dispose
  end
end
