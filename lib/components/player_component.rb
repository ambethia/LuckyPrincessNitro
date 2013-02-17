class PlayerComponent < EntitySystem::Component
  provides :shields, :is_turning_left, :is_turning_right, :is_firing
end
