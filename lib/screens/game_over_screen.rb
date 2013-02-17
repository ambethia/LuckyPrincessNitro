class GameOverScreen < BaseScreen

  def setup
    @systems = %w[
      Input
      GameOver
    ]
  end
end
