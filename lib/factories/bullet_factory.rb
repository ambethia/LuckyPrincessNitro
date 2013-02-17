class BulletFactory < EntitySystem::Factory::Base
  SPEED = {
    player: 240,
    enemy_a: 300
  }
  RADIUS = 8
  CULL_RANGE = 400

  build :bullet
  using :px, :py, :bearing, :type, :owner

  def construct
    bullet = manager.create(:bullet)
    manager.attach(bullet, SpatialComponent.new({
      px: px, py: py,
      bearing: bearing, speed: SPEED[type]
    }))
    manager.attach(bullet, CollisionComponent.new({
      owner: owner,
      radius: RADIUS
    }))
    manager.attach(bullet, MotionComponent.new)
    manager.attach(bullet, RenderableComponent.new)
    manager.attach(bullet, RangedCullComponent.new({
      range: CULL_RANGE
    }))
    manager.attach(bullet, RotatedComponent.new({
      mapping: bullet_sprites
    }))
    bullet
  end

  private

  def bullet_sprites
    $game.screen.sprites["#{type}_bullets".to_sym]
  end
end
