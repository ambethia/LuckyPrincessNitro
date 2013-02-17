require_relative 'test_helper'

require 'game_helpers'
require 'entity_system'

class Position < EntitySystem::Component
  provides :x, :y
end

class Locator < EntitySystem::System

  def process(delta)
    each(Position) do |entity, component|
      component.x += (1 * delta)
      component.y += (1 * delta)
    end
  end
end

class WidgetFactory < EntitySystem::Factory::Base
  build :widget
  using :x, :y

  def construct
    entity = manager.create(:widget)
    manager.attach(entity, Position.new(x: 0, y: 0))
    entity
  end
end

class EntitySystem::ManagerTest < Test::Unit::TestCase

  def setup
    @manager = EntitySystem::Manager.new
  end

  def test_create_entity_returns_a_uuid
    entity = @manager.create
    assert_match /^[0-9a-f\-]{36}$/, entity
  end

  def test_create_tagged_entity
    entity = @manager.create(:player)
    assert_equal entity, @manager.find(:player)
  end

  def test_create_entities_with_same_tag
    entities = [@manager.create(:enemy), @manager.create(:enemy)]
    assert @manager.all(:enemy).include?(entities[0])
    assert @manager.all(:enemy).include?(entities[1])
  end
end

class EntitySystem::ComponentTest < Test::Unit::TestCase

  def setup
    @component = Position.new(x: 1, y: 2)
  end

  def test_component_gains_attribute_readers
    assert_equal 1, @component.x
  end

  def test_component_gains_attribute_setter
    @component.y = 42
    assert_equal 42, @component.y
  end
end

class EntitySystem::ComponentTest < Test::Unit::TestCase

  def setup
    @component = Position.new(x: 1, y: 2)
  end

  def test_component_gains_attribute_readers
    assert_equal 1, @component.x
  end

  def test_component_gains_attribute_setter
    @component.y = 42
    assert_equal 42, @component.y
  end
end

class EntitySystem::SystemTest < Test::Unit::TestCase

  def setup
    @manager = EntitySystem::Manager.new
    @component = Position.new(x: 1, y: 2)
    entity = @manager.create
    @manager.attach(entity, @component)
    @system = Locator.new(@manager)
  end

  def test_system_changes_component
    @system.process(1)
    assert_equal 2, @component.x
  end
end

class EntitySystem::FactoryTest < Test::Unit::TestCase

  def setup
    @manager = EntitySystem::Manager.new
  end

  def test_factory_attaches_component
    @manager.factory.widget do |widget|
      widget.x = 0
      widget.y = 0
    end
    component = @manager.component(Position, @manager.find(:widget))
    assert_equal 0, component.x
  end
end
