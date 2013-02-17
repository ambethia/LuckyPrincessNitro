class MusicSystem < EntitySystem::System

  def setup
    @music = Gdx.audio.new_music(load_asset("theme_01.ogg"))
    @music.looping = true
  end

  def update(delta)
    @elapsed ||= 0
    if @elapsed > 3 && !@music.is_playing
      @music.play
    end
    @elapsed += delta
  end

  def dispose
    @music.dispose
  end
end
