import measure_theory.borel_space
import set_theory.cardinal_ordinal
import set_theory.ordinal
import topology.basic
import topology.G_delta
noncomputable theory

open set classical topological_space
open_locale classical
section
universes u w
variables {α : Type u} {ι : Sort w} [t : topological_space α]
include t

def is_sigma_0_ξ : Π (ξ : ordinal), (1 ≤ ξ ∧ ξ < (cardinal.aleph 1).ord) → set α → Prop
| ξ := λ h s,
  if heo: ξ = 1 then is_open s
  else ∃ (T : set (set α)),
    (∀ (t : set α),
      t ∈ T → ∃ (ξₙ : ordinal) (hₙ : 1 ≤ ξₙ ∧ ξₙ < ξ),
        have hdec : ξₙ < ξ := hₙ.2,
        have hrec : 1 ≤ ξₙ ∧ (ξₙ < (cardinal.aleph 1).ord),
          { split, exact hₙ.1, exact (lt_trans hₙ.2 h.2) },
        is_sigma_0_ξ ξₙ hrec tᶜ
    ) ∧ T.countable ∧ (s = ⋃₀ T)

using_well_founded { dec_tac := `[assumption] }

def is_pi_0_ξ (ξ : ordinal) (h : 1 ≤ ξ ∧ ξ < (cardinal.aleph 1).ord) (s : set α) : Prop :=
  is_sigma_0_ξ ξ h s

def is_delta_0_ξ (ξ : ordinal) (h : 1 ≤ ξ ∧ ξ < (cardinal.aleph 1).ord) (s : set α) : Prop :=
    is_sigma_0_ξ ξ h s ∧ is_pi_0_ξ ξ h s

end