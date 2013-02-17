class InterfaceSystem < EntitySystem::System
  RADAR_RANGE = 320 # game width
  RADAR_SCALE = 0.1 # 10%

  def render(delta)
    @elapsed ||= 0
    case $game.screen
    when GameScreen
      draw_shields
      draw_radar
      draw_gems_collected
      draw_debug if DEBUG
    end
    @elapsed += delta
  end

  def draw_shields
    player_id = manager.find(:player)
    if player_id
      player = manager.component(PlayerComponent, player_id)
      ox, oy = 8, $game.height - 16
      player.shields.times do |i|
        x = 8 + (ox * i)
        @batch.draw($game.screen.sprites[:player_shield], x, oy)
      end
    end
  end

  def draw_radar
    @batch.draw($game.screen.sprites[:radar],
      @radar_center_x - 32, @radar_center_y - 32)

    player_id = manager.find(:player)
    if player_id

      player_s = manager.component(SpatialComponent, player_id)
      player_v = Vector2.new(player_s.px, player_s.py)
      manager.entities(EnemyComponent).each_with_index do |enemy_id, i|
        enemy_s = manager.component(SpatialComponent, enemy_id)
        enemy_v = Vector2.new(enemy_s.px, enemy_s.py)
        if player_v.dst(enemy_v) < RADAR_RANGE
          vector = enemy_v.sub(player_v).mul(RADAR_SCALE)
          @batch.draw(
            @enemy_radar.get_key_frame(@elapsed + i, true),
            @radar_center_x + vector.x - 1.5,
            @radar_center_y + vector.y - 1.5
          )
        end
      end

      # Find the closest gem
      closest_gem_id = manager.components(ItemComponent).select { |i|
        i.type == :gem
      }.sort_by { |i|
        item_s = manager.component(SpatialComponent, i.entity)
        item_v = Vector2.new(item_s.px, item_s.py)
        player_v.dst(item_v)
      }.map(&:entity).first

      manager.entities(ItemComponent).each_with_index do |item_id, i|
        item_s = manager.component(SpatialComponent, item_id)
        item_v = Vector2.new(item_s.px, item_s.py)

        # if in range draw on radar, else draw the closest along the border
        distance = player_v.dst(item_v)

        if distance < RADAR_RANGE
          vector = item_v.sub(player_v).mul(RADAR_SCALE)
          @batch.draw(
            $game.screen.sprites[:gem_radar],
            @radar_center_x + vector.x - 1.5,
            @radar_center_y + vector.y - 1.5
          )
        else
          next unless item_id == closest_gem_id
          angle = item_v.sub(player_v).angle
          @batch.draw(
            $game.screen.sprites[:gem_radar],
            @radar_center_x + (30 * MathUtils.cos_deg(angle)) - 1.5,
            @radar_center_y + (30 * MathUtils.sin_deg(angle)) - 1.5
          )
          # write text for distance to nearest gem
          @font.draw(@batch, (distance/10).round.to_s, $game.width - 24, 12)
        end
      end
    end
  end

  def draw_gems_collected
    remaining = manager.components(ItemComponent).select { |i| i.type == :gem }.size
    collected = SpawnSystem::NUM_GEMS - remaining
    text = "#{collected}/#{SpawnSystem::NUM_GEMS}"
    @font.draw(@batch, text, $game.width - 26, $game.height - 6)
  end

  def draw_debug
    @font.draw(@batch, $game.screen.debug_text, 8, 16)
  end

  def setup
    @batch = $game.screen.batch
    [:player_shield, :radar, :gem_radar].each do |sprite|
      $game.screen.sprites[sprite] = $game.screen.atlas.create_sprite(sprite.to_s)
    end

    @enemy_radar = Animation.new(0.1, *[
      $game.screen.atlas.create_sprite("enemy_radar", 1),
      $game.screen.atlas.create_sprite("enemy_radar", 2),
      $game.screen.atlas.create_sprite("enemy_radar", 3)
    ])

    @radar_center_x = $game.width - (64/2) - 8
    @radar_center_y = (64/2) + 8

    @font = BitmapFont.new(load_asset("04b03.fnt"), load_asset("04b03.png"), false)
  end
end
