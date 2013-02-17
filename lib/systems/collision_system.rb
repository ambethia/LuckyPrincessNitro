class CollisionSystem < EntitySystem::System
  ENEMY_RADIUS = 8
  PLAYER_RADIUS = 8

  def update(delta)
    each(CollisionComponent) do |entity, component|
      collider_s = manager.component(SpatialComponent, entity)
      next unless collider_s # incase the collider was suddenly removed
      collider_c = Circle.new(collider_s.px, collider_s.py, component.radius)
      player_id = manager.find(:player)
      case manager.tag(component.owner)
      when :player
        # player bullets hitting enemies
        manager.all(:enemy).each do |enemy|
          enemy_s = manager.component(SpatialComponent, enemy)
          enemy_c = Circle.new(enemy_s.px, enemy_s.py, ENEMY_RADIUS)
          if Intersector.overlapCircles(enemy_c, collider_c)
            if manager.tag(entity) == :bullet
              manager.factory.particle do |particle|
                particle.type = :explosion
                particle.px = enemy_s.px
                particle.py = enemy_s.py
              end
              $game.screen.sounds[:enemy_a_death].play(0.6)
              manager.destroy(entity)
              manager.destroy(enemy)
            end
          end
        end
        # player bullets hitting enemy bullets
        manager.all(:bullet).each do |bullet|
          # dont't destroy our own bullets
          next if manager.component(CollisionComponent, bullet).owner == player_id
          bullet_s = manager.component(SpatialComponent, bullet)
          bullet_c = Circle.new(bullet_s.px, bullet_s.py, component.radius)
          if Intersector.overlapCircles(bullet_c, collider_c)
            manager.factory.particle do |particle|
              particle.type = :bullet_destruct
              particle.px = bullet_s.px
              particle.py = bullet_s.py
            end
            $game.screen.sounds[:bullet_destruct].play
            manager.destroy(entity)
            manager.destroy(bullet)
          end
        end
      when :enemy
        # enemy bullets hitting the player
        if player_id
          player_s = manager.component(SpatialComponent, player_id)
          player_c = Circle.new(player_s.px, player_s.py, PLAYER_RADIUS)
          if Intersector.overlapCircles(player_c, collider_c)
            manager.factory.particle do |particle|
              particle.type = :shield_damage # TODO: Shield damage
              particle.attach_to = player_id
              particle.px = player_s.px
              particle.py = player_s.py
            end
            # sustain damage
            manager.component(PlayerComponent, player_id).shields -= 1 unless ENV['INVINCIBLE']
            $game.screen.sounds[:shield_damage].play
            manager.destroy(entity)
          end
        end
      when :item
        # player approaching an item (gem, power up, etc)
        if player_id
          player_s = manager.component(SpatialComponent, player_id)
          player_c = Circle.new(player_s.px, player_s.py, PLAYER_RADIUS)
          if Intersector.overlapCircles(player_c, collider_c)
            d = Vector2.new(player_s.px, player_s.py).dst(collider_s.px, collider_s.py)
            # the gems will gravitate towards the player until they
            # are close enough to be removed
            if d > PLAYER_RADIUS * 1.2
              p = [(component.radius - d).abs / component.radius, 1].min
              tx = lerp(collider_s.px, player_s.px, p)
              ty = lerp(collider_s.py, player_s.py, p)
              collider_s.px += (tx - collider_s.px) * delta * 14
              collider_s.py += (ty - collider_s.py) * delta * 14

              # Spin faster approaching the player
              collider_s.bearing += 15 * d * delta
              collider_s.bearing %= 360
            else
              # collect the gem
              $game.screen.sounds[:pickup_gem].play
              manager.destroy(entity)
            end
          end
        end
      end
    end
  end

  def reset
    each(CollisionComponent) do |entity|
      manager.destroy(entity)
    end
  end
end
