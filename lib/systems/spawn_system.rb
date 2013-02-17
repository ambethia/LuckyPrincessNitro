class SpawnSystem < EntitySystem::System
  SPAWN_TIME = 1
  MAX_ENEMIES = 5
  GEM_AREA = 4096
  NUM_GEMS = 12

  def update(delta)
    @elapsed ||= 0
    @elapsed += delta

    @active_enemy_count = manager.all(:enemy).size

    if @active_enemy_count < MAX_ENEMIES
      if @elapsed > SPAWN_TIME
        spawn_enemy
        @elapsed = 0
      end
    else
      @elapsed = 0
    end
  end

  def setup
    atlas = $game.screen.atlas
    $game.screen.sprites[:gem] = {
        0 => atlas.create_sprite("gem", 1),
       45 => atlas.create_sprite("gem", 2),
       90 => atlas.create_sprite("gem", 3),
      135 => atlas.create_sprite("gem", 4),
      180 => atlas.create_sprite("gem", 5),
      225 => atlas.create_sprite("gem", 6),
      270 => atlas.create_sprite("gem", 7),
      315 => atlas.create_sprite("gem", 8)
    }

    reset
  end

  def reset
    spawn_player($game.width / 2, $game.height / 2)
    NUM_GEMS.times do
      spawn_gem(
        rand(GEM_AREA) - GEM_AREA/2,
        rand(GEM_AREA) - GEM_AREA/2
      )
    end
  end

  private

  def spawn_player(x, y)
    manager.factory.player do |player|
      player.px = x
      player.py = y
    end
    $game.screen.sounds[:player_spawn].play(2.0)
  end

  def spawn_enemy
    manager.factory.enemy do |enemy|
      enemy.type = :a
    end
    $game.screen.sounds[:enemy_a_spawn].play
  end

  def spawn_gem(x, y)
    manager.factory.item do |item|
      item.type = :gem
      item.x = x
      item.y = y
    end
  end
end
