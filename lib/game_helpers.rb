module GameHelpers

  def load_asset(filename)
    Gdx.files.internal(RELATIVE_ROOT + "assets/#{filename}")
  end

  def lerp(a, b, m = 0.5)
    (a * (1 - m) + b * m)
  end

  def weighted_average(v, w, n = 40)
    ((v * (n - 1)) + w) / n;
  end
end
