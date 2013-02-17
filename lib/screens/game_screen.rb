class GameScreen < BaseScreen

  def setup
    @systems = %w[
      Input
      Player
      Enemy
      Camera
      Music
      RangedCull
      Collision
      Spawn
      Motion
      Rotation
      Animation
      Background
      Render
      Particle
    ]
  end

  def debug_text
    player_id = @entity_manager.find(:player)
    if player_id
      player = @entity_manager.component(PlayerComponent, player_id)
      super + ", Shields: #{player.shields}"
    else
      super + ", Player Dead!"
    end
  end
end
