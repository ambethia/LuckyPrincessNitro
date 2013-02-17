class RotationSystem < EntitySystem::System

  def update(delta)
    each(RotatedComponent) do |entity, component|
      spatial = manager.component(SpatialComponent, entity)
      render = manager.component(RenderableComponent, entity)
      angle = nearest_increment(spatial.bearing)

      if component.is_animated
        animated_component = manager.component(AnimatedComponent, entity)
        animated_component.animation = component.mapping[angle]
      else
        render.image = component.mapping[angle]
      end
    end
  end

  def nearest_increment(angle, inc = 45)
    ((angle.round + inc / 2) / inc * inc) % 360
  end
end
