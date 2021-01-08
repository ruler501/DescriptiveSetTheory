import topology.basic
import topology.metric_space.basic
import topology.separation

noncomputable theory

open set classical topological_space
open_locale classical

universes u
variables {α : Type u}

def metric_space.to_topological_space {α : Type u} (m : metric_space α) : topological_space α :=
  m.to_uniform_space.to_topological_space

class metrizable_space (α : Type u) [t : topological_space α] : Prop :=
  (metrizable : ∃(m : metric_space α), m.to_topological_space = t)

instance metrizable_space.to_metric_space {α : Type u} [t : topological_space α] : has_coe (metrizable_space α) (metric_space α) :=
  ⟨λ (m : metrizable_space α), classical.some m.metrizable⟩

instance metrizable_space.to_uniform_space {α : Type u} [t : topological_space α] : has_coe (metrizable_space α) (uniform_space α) :=
  ⟨λ (m : metrizable_space α), (classical.some m.metrizable).to_uniform_space⟩

class completely_metrizable_space (α : Type u) [t : topological_space α]: Prop :=
  (to_metrizable_space : @metrizable_space α t)
  (to_complete_space : @complete_space α to_metrizable_space)

class polish_space (α : Type u) [t : topological_space α] : Prop :=
  (to_completely_metrizable : completely_metrizable_space α)
  (to_second_countable : second_countable_topology α)