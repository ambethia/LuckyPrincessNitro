class AnimationSystem < EntitySystem::System

  def update(delta)
    @elapsed ||= 0

    each(AnimatedComponent) do |entity, component|
      render = manager.component(RenderableComponent, entity)
      render.image = component.animation.get_key_frame(@elapsed, component.is_looped)
    end
    @elapsed += delta
  end
end
