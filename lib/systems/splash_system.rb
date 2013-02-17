class SplashSystem < EntitySystem::System

  def setup
    @image = Texture.new(Gdx.files.internal(RELATIVE_ROOT + "assets/splash.png"))
  end

  def render(delta)
    # For reason I don't want to figure out, this seems to get called
    # still when were transitioning out of the splash screen and we get
    # a "SpriteBatch.begin must be called before draw" error. Whatever.
    if $game.screen.is_a? SplashScreen
      $game.screen.batch.draw(@image, 0, 0)
    end
  end
end
