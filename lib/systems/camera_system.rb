class CameraSystem < EntitySystem::System
  CAMERA_TRACKING_SPEED = 0.075

  def setup
    entity = manager.create(:camera)
    @spatial = manager.attach(entity, SpatialComponent.new({
      px: $game.width / 2, py: $game.height / 2
    }))
    @camera = manager.attach(entity, CameraComponent.new({
      object: OrthographicCamera.new
    }))

    @camera.object.set_to_ortho(false, $game.width, $game.height)
    @camera.object.position.set(@spatial.px, @spatial.py, 0)
    @viewport = Rectangle.new(0, 0, $game.width, $game.height)
  end

  def update(delta)
    player_id = manager.find(:player)
    if player_id && !$game.did_we_win_yet?
      player = manager.component(SpatialComponent, player_id)
      @speed = player.speed.abs
      @player_x = player.px
      @player_y = player.py
      @x_vector = Math.cos(player.bearing * Math::PI/180)
      @y_vector = Math.sin(player.bearing * Math::PI/180)
    else
      # Keep the camera scrolling in the direction the player was moving when they died
      @player_x += @x_vector * delta * @speed
      @player_y += @y_vector * delta * @speed
      @speed -= @speed * delta * 0.5
      if @speed && @speed < 12
        if $game.did_we_win_yet?
          $game.victory
        else
          $game.game_over
        end
      end
    end

    @x_offset = @player_x + (@x_vector * $game.width * 0.0035 * @speed)
    @y_offset = @player_y + (@y_vector * $game.height * 0.003 * @speed)

    @spatial.px = lerp(@spatial.px, @x_offset, CAMERA_TRACKING_SPEED)
    @spatial.py = lerp(@spatial.py, @y_offset, CAMERA_TRACKING_SPEED)
    @camera.object.position.set(@spatial.px, @spatial.py, 0)
    @camera.object.update
    $game.screen.batch.set_projection_matrix(@camera.object.combined)
  end

  def reset
    @speed = 120
  end
end
