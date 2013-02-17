class ItemFactory < EntitySystem::Factory::Base
  build :item
  using :type, :x, :y

  RADIUS = {
    gem: 64
  }

  def construct
    entity = manager.create(:item)
    manager.attach(entity, ItemComponent.new({
      type: type,
    }))
    manager.attach(entity, CollisionComponent.new({
      owner: entity,
      radius: RADIUS[type]
    }))
    manager.attach(entity, SpatialComponent.new({
      px: x, py: y, bearing: rand(360), speed: 0
    }))
    manager.attach(entity, RenderableComponent.new)
    manager.attach(entity, RotatedComponent.new({
      mapping: $game.screen.sprites[type]
    }))
  end
end
