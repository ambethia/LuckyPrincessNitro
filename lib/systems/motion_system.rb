class MotionSystem < EntitySystem::System

  def update(delta)
    each(MotionComponent) do |entity, component|
      spatial = manager.component(SpatialComponent, entity)
      x_vel = Math.cos(spatial.bearing * Math::PI/180) * spatial.speed
      y_vel = Math.sin(spatial.bearing * Math::PI/180) * spatial.speed
      spatial.px += x_vel * delta
      spatial.py += y_vel * delta
    end
  end
end
