class RenderSystem < EntitySystem::System

  def render(delta)
    each(RenderableComponent) do |entity, component|
      image = component.image
      spatial = manager.component(SpatialComponent, entity)
      x = spatial.px - image.width/2
      y = spatial.py - image.height/2

      sprite_batch.draw(image, x, y)
    end
  end

  def sprite_batch
    @sprite_batch ||= $game.screen.batch
  end
end
