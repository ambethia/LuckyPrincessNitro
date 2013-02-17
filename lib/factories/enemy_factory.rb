class EnemyFactory < EntitySystem::Factory::Base
  build :enemy
  using :type

  def construct
    entity = manager.create(:enemy)
    camera = manager.component(SpatialComponent, manager.find(:camera))
    entry_angle = rand(360)
    manager.attach(entity, EnemyComponent.new({
      type: type,
      data: {
        c_angle: entry_angle,
        t_angle: entry_angle,
        elapsed_since_last_shot: 0,
      }
    }))
    manager.attach(entity, SpatialComponent.new({
      px: camera.px + (Math.cos(entry_angle) * ($game.width * 1.2)),
      py: camera.py + (Math.sin(entry_angle) * ($game.height * 1.2)),
      bearing: 0, speed: 0
    }))
    manager.attach(entity, RenderableComponent.new)
    manager.attach(entity, RotatedComponent.new({
      mapping: $game.screen.sprites["enemy_#{type}".to_sym]
    }))
  end
end
