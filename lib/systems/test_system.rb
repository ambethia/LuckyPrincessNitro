class TestSystem < EntitySystem::System

  def setup
    @effect = ParticleEffect.new
    @effect.load(load_asset("explosion.particle"), load_asset(""))
  end

  def update(delta)
    if !@has_run
      @has_run = true
      @effect.emitters.each(&:start)
    end

    if Gdx.input.is_key_pressed(Input::Keys::SPACE)
      @has_run = false
    end

    @effect.set_position($game.width/2, $game.height/2)
  end

  def render(delta)
    @effect.draw($game.screen.batch, delta)
  end
end
