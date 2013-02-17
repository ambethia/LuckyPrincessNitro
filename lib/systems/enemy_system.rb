class EnemySystem < EntitySystem::System
  RATE_OF_FIRE = 0.33
  MIN_FIRE_DISTANCE = 120
  MAX_FIRE_DISTANCE = 180

  def update(delta)
    each(EnemyComponent) do |entity, component|
      enemy = manager.component(SpatialComponent, entity)
      camera = manager.component(SpatialComponent, manager.find(:camera))

      player_id = manager.find(:player)

      if player_id && !$game.did_we_win_yet?
        player_s = manager.component(SpatialComponent, player_id)
        player_c = manager.component(PlayerComponent, manager.find(:player))

        distance_to_player = Vector2.new(player_s.px, player_s.py).dst(enemy.px, enemy.py)

        # rotate around the player, but not if they are holding steady
        if player_c.is_turning_left
          increment = rand(5)
          component.data[:t_angle] -= (increment * delta) % 360
        elsif player_c.is_turning_right
          increment = rand(5)
          component.data[:t_angle] += (increment * delta) % 360
        end
        component.data[:c_angle] = weighted_average(component.data[:c_angle], component.data[:t_angle])

        ellipse_w, ellipse_h = 50, 50
        delta_x = player_s.px - enemy.px
        delta_y = player_s.py - enemy.py
        target_x = player_s.px - (delta_x * 0.25)
        target_y = player_s.py - (delta_y * 0.25)
        enemy_x = target_x + (Math.cos(component.data[:c_angle]) * ellipse_w)
        enemy_y = target_y + (Math.sin(component.data[:c_angle]) * ellipse_h)

        enemy.px = weighted_average(enemy.px, enemy_x, 20)
        enemy.py = weighted_average(enemy.py, enemy_y, 20)

        # face player
        angle = (Math.atan2(delta_y , delta_x) * 180 / Math::PI) % 360
        enemy.bearing = angle

        if component.data[:elapsed_since_last_shot] > RATE_OF_FIRE &&
          distance_to_player > MIN_FIRE_DISTANCE
          component.data[:elapsed_since_last_shot] = 0
          manager.factory.bullet do |bullet|
            bullet.owner = entity
            bullet.type = "enemy_#{component.type}".to_sym
            bullet.px = enemy.px
            bullet.py = enemy.py
            bullet.bearing = enemy.bearing
          end
          $game.screen.sounds["enemy_#{component.type}_bullet".to_sym].play
        else
          component.data[:elapsed_since_last_shot] += delta
        end
      else
        # Fly away if the player is dead
        enemy.speed = 100
        manager.attach(entity, MotionComponent.new)
      end
    end
  end

  def setup
    atlas = $game.screen.atlas
    $game.screen.sprites[:enemy_a] = {
        0 => atlas.create_sprite("enemy_a", 1),
       45 => atlas.create_sprite("enemy_a", 2),
       90 => atlas.create_sprite("enemy_a", 3),
      135 => atlas.create_sprite("enemy_a", 4),
      180 => atlas.create_sprite("enemy_a", 5),
      225 => atlas.create_sprite("enemy_a", 6),
      270 => atlas.create_sprite("enemy_a", 7),
      315 => atlas.create_sprite("enemy_a", 8)
    }
    $game.screen.sprites[:enemy_a_bullets] = {
        0 => atlas.create_sprite("bullet_1", 1),
       45 => atlas.create_sprite("bullet_1", 2),
       90 => atlas.create_sprite("bullet_1", 3),
      135 => atlas.create_sprite("bullet_1", 4),
      180 => atlas.create_sprite("bullet_1", 5),
      225 => atlas.create_sprite("bullet_1", 6),
      270 => atlas.create_sprite("bullet_1", 7),
      315 => atlas.create_sprite("bullet_1", 8)
    }

    [:enemy_a_spawn, :enemy_a_bullet, :enemy_a_death].each do |sound|
      $game.screen.sounds[sound] = Gdx.audio.new_sound(load_asset("#{sound}.ogg"))
    end
  end

  def reset
    each(EnemyComponent) do |entity|
      manager.destroy(entity)
    end
  end
end

