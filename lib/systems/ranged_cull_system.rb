class RangedCullSystem < EntitySystem::System

  def update(delta)
    camera = manager.component(CameraComponent, manager.find(:camera)).object
    camera_position = camera.position
    each(RangedCullComponent) do |entity, component|
      spatial = manager.component(SpatialComponent, entity)
      distance = camera_position.dst(Vector3.new(spatial.px, spatial.py, 0))
      if distance > component.range
        manager.destroy(entity)
      end
    end
  end
end
