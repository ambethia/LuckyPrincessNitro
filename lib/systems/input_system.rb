class InputSystem < EntitySystem::System

  def update(delta)
    if Gdx.input.is_key_pressed(Input::Keys::Q)
      Gdx.app.exit
    elsif Gdx.input.is_key_pressed(Input::Keys::F)
      $game.toggle_fullscreen
    end

    case $game.screen
    when SplashScreen
      if Gdx.input.is_key_pressed(Input::Keys::SPACE)
        $game.game_begin
      end
    when GameScreen
      player_id = manager.find(:player)
      if player_id
        player = manager.component(PlayerComponent, player_id)
        player.is_turning_right = Gdx.input.is_key_pressed(Input::Keys::RIGHT)
        player.is_turning_left = Gdx.input.is_key_pressed(Input::Keys::LEFT)
        player.is_firing = (Gdx.input.is_key_pressed(Input::Keys::SPACE) || Gdx.input.is_key_pressed(Input::Keys::UP))
      end
    when GameOverScreen, VictoryScreen
      if Gdx.input.is_key_pressed(Input::Keys::SPACE)
        $game.game_begin
      end
      if Gdx.input.is_key_pressed(Input::Keys::ESCAPE)
        $game.game_menu
      end
    when TestScreen
    end
  end
end
