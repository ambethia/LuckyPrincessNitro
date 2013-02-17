require 'game_helpers'
require 'entity_system'

%w[screens components factories systems].each do |dir|
  Dir[ROOT_DIR + "/lib/#{dir}/*.rb"].each do |file|
    require File.basename(file)
  end
end

class LuckyPrincessNitro < Game
  VIRTUAL_WIDTH = 320
  VIRTUAL_HEIGHT = 200
  DEFAULT_SCALE = 3

  include ApplicationListener

  attr_reader :is_running,
    :game_screen,
    :splash_screen,
    :game_over_screen,
    :victory_screen,
    :test_screen

  def initialize
    @is_running = true
  end

  def create
    ShaderProgram.pedantic = false
    @game_screen = GameScreen.new
    @splash_screen = SplashScreen.new
    @game_over_screen = GameOverScreen.new
    @victory_screen = VictoryScreen.new
    @test_screen = TestScreen.new

    if ENV['SCREEN']
      # for test modes
      set_screen send("#{ENV['SCREEN']}_screen")
    else
      toggle_fullscreen
      set_screen splash_screen
    end
  end

  def dispose
    @is_running = false
  end

  def toggle_fullscreen
    mode = Gdx.graphics.get_desktop_display_mode
    if Gdx.graphics.is_fullscreen
      Gdx.graphics.set_display_mode(width * DEFAULT_SCALE, height * DEFAULT_SCALE, false)
    else
      Gdx.graphics.set_display_mode(mode.width, mode.height, true)
    end
  end

  def game_over
    set_screen(game_over_screen)
  end

  def game_begin
    set_screen(game_screen)
  end

  def game_menu
    set_screen(splash_screen)
  end

  def victory
    set_screen(victory_screen)
  end

  def did_we_win_yet?
    screen.entity_manager.components(ItemComponent).select { |i|
      i.type == :gem
    }.size == 0
  end

  def width
    VIRTUAL_WIDTH
  end

  def height
    VIRTUAL_HEIGHT
  end
end

