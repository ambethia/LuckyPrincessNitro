class VictorySystem < EntitySystem::System

  def setup
    @image = Texture.new(Gdx.files.internal(RELATIVE_ROOT + "assets/victory.png"))
  end

  def render(delta)
    if $game.screen.is_a? VictoryScreen
      $game.screen.batch.draw(@image, 0, 0)
    end
  end
end
