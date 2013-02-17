ROOT_DIR = File.expand_path('../..', __FILE__)
$: << ROOT_DIR + '/lib'
$: << ROOT_DIR + '/lib/screens'
$: << ROOT_DIR + '/lib/components'
$: << ROOT_DIR + '/lib/factories'
$: << ROOT_DIR + '/lib/systems'
$: << ROOT_DIR + '/vendor'

DEBUG = !$0['<']

RELATIVE_ROOT = DEBUG ? '' : 'lucky_princess_nitro/'

require 'java'
require 'gdx-backend-lwjgl-natives.jar'
require 'gdx-backend-lwjgl.jar'
require 'gdx-natives.jar'
require 'gdx.jar'

java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration
java_import com.badlogic.gdx.graphics.Texture
java_import com.badlogic.gdx.graphics.OrthographicCamera
java_import com.badlogic.gdx.graphics.g2d.Animation
java_import com.badlogic.gdx.graphics.g2d.BitmapFont
java_import com.badlogic.gdx.graphics.g2d.ParticleEffect
java_import com.badlogic.gdx.graphics.g2d.Sprite
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch
java_import com.badlogic.gdx.graphics.g2d.TextureAtlas
java_import com.badlogic.gdx.graphics.g2d.TextureRegion
java_import com.badlogic.gdx.graphics.glutils.FrameBuffer
java_import com.badlogic.gdx.graphics.glutils.ShaderProgram
java_import com.badlogic.gdx.graphics.GL20
java_import com.badlogic.gdx.graphics.Pixmap
java_import com.badlogic.gdx.math.Circle
java_import com.badlogic.gdx.math.Intersector
java_import com.badlogic.gdx.math.MathUtils
java_import com.badlogic.gdx.math.Rectangle
java_import com.badlogic.gdx.math.Vector2
java_import com.badlogic.gdx.math.Vector3
java_import com.badlogic.gdx.scenes.scene2d.InputListener
java_import com.badlogic.gdx.ApplicationListener
java_import com.badlogic.gdx.Game
java_import com.badlogic.gdx.Gdx
java_import com.badlogic.gdx.Input
java_import com.badlogic.gdx.Screen

if DEBUG
  require ROOT_DIR + '/tools/gdx-tools.jar'
  java_import com.badlogic.gdx.tools.imagepacker.TexturePacker2
  TexturePacker2.process("#{ROOT_DIR}/assets/source/images", "#{ROOT_DIR}/assets", "sprites");
end

require 'lucky_princess_nitro'

unless $0 == "irb"
  config = LwjglApplicationConfiguration.new
  config.title = "Lucky Princess Nitro"
  config.useGL20 = true
  config.width = LuckyPrincessNitro::VIRTUAL_WIDTH * LuckyPrincessNitro::DEFAULT_SCALE
  config.height = LuckyPrincessNitro::VIRTUAL_HEIGHT * LuckyPrincessNitro::DEFAULT_SCALE

  $game = LuckyPrincessNitro.new
  LwjglApplication.new($game, config)
  while $game.is_running; sleep(1); end
end
