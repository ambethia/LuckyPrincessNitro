class PlayerFactory < EntitySystem::Factory::Base
  INITIAL_SHIELDS = 6

  build :player
  using :px, :py, :animations

  def construct
    entity = manager.create(:player)
    manager.attach(entity, PlayerComponent.new({
      shields: INITIAL_SHIELDS
    }))
    manager.attach(entity, MotionComponent.new)
    manager.attach(entity, SpatialComponent.new({
      px: px, py: py, bearing: 0, speed: 0
    }))
    manager.attach(entity, AnimatedComponent.new({
      is_looped: true
    }))
    manager.attach(entity, RenderableComponent.new)
    manager.attach(entity, RotatedComponent.new({
      mapping: $game.screen.sprites[:player],
      is_animated: true
    }))
    entity
  end
end
