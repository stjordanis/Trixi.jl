
function max_dt(u::AbstractArray{<:Any,4}, t, mesh::TreeMesh{2},
                constant_speed::Val{false}, equations, dg::DG, cache)
  # to avoid a division by zero if the speed vanishes everywhere,
  # e.g. for steady-state linear advection
  max_scaled_speed = nextfloat(zero(t))

  # FIXME: This should be implemented properly using another callback
  #        or something else, cf.
  #        https://github.com/trixi-framework/Trixi.jl/issues/257
  if equations isa AbstractIdealGlmMhdEquations
    equations.c_h = zero(equations.c_h)
  end

  for element in eachelement(dg, cache)
    max_λ1 = max_λ2 = zero(max_scaled_speed)
    for j in eachnode(dg), i in eachnode(dg)
      u_node = get_node_vars(u, equations, dg, i, j, element)
      λ1, λ2 = max_abs_speeds(u_node, equations)
      max_λ1 = max(max_λ1, λ1)
      max_λ2 = max(max_λ2, λ2)
    end
    inv_jacobian = cache.elements.inverse_jacobian[element]
    max_scaled_speed = max(max_scaled_speed, inv_jacobian * (max_λ1 + max_λ2))
  end

  return 2 / (nnodes(dg) * max_scaled_speed)
end


function max_dt(u::AbstractArray{<:Any,4}, t, mesh::TreeMesh{2},
                constant_speed::Val{true}, equations, dg::DG, cache)
  # to avoid a division by zero if the speed vanishes everywhere,
  # e.g. for steady-state linear advection
  max_scaled_speed = nextfloat(zero(t))

  for element in eachelement(dg, cache)
    max_λ1, max_λ2 = max_abs_speeds(equations)
    inv_jacobian = cache.elements.inverse_jacobian[element]
    max_scaled_speed = max(max_scaled_speed, inv_jacobian * (max_λ1 + max_λ2))
  end

  return 2 / (nnodes(dg) * max_scaled_speed)
end
