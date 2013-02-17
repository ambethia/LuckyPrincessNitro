class GameOverSystem < EntitySystem::System

  def setup
    @image = Texture.new(Gdx.files.internal(RELATIVE_ROOT + "assets/game_over.png"))
  end

  def render(delta)
    if $game.screen.is_a? GameOverScreen
      $game.screen.batch.draw(@image, 0, 0)
    end
  end
end
