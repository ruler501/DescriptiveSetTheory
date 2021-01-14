import set_theory.ordinal
import tactic.linarith

open set classical

universes u

variables {α : Type u} {m : ℕ} {n : ℕ}

def lift_value (is : fin m) (h : m ≤ n) : fin n := 
  let i := is.val in
  let hi : i < m := is.property in
  ⟨i, gt_of_ge_of_gt h hi⟩ 


-- instance nat_to_subtype : has_coe ℕ Type := ⟨λ (n : ℕ), {m // m < n}⟩
notation A `^` n := n.to_type → A

def finite_sequence (α : Type u) (n : ℕ) := fin n → α
def infinite_sequence (α : Type*) := ℕ → α

notation A `^<ℕ` := Σ(n : ℕ), finite_sequence A n
notation A `^ℕ` := infinite_sequence A

namespace finite_sequence

def length (s : α^<ℕ) : ℕ := s.fst

def initial_segment (s : finite_sequence α n) (h : m ≤ n) : finite_sequence α m :=
  λ i, s (lift_value i h)

def initial_segment_of (s : finite_sequence α m) (t : finite_sequence α n) : Prop :=
  if h : m ≤ n then s = t.initial_segment h
  else false

def extension_of (t : finite_sequence α n) (s : finite_sequence α m) : Prop :=
  initial_segment_of s t

def compatible (s : finite_sequence α m) (t : finite_sequence α n) : Prop := 
  initial_segment_of s t ∨ extension_of s t

notation s `⊥` t := ¬(compatible s t)

def concat (s : finite_sequence α m) (t : finite_sequence α n) : finite_sequence α (m + n) :=
  λ is, let i := is.val in let hi := is.property in 
  if h : i < m then s ⟨i, h⟩
  else
    have h2 : i - m < n, { 
      simp at h,
      have h4 := (@nat.sub_lt_right_iff_lt_add i n m h).2,
      apply h4,
      rwa nat.add_comm n m,
    },
    t ⟨i - m, h2⟩

theorem initial_segment_of_concat (s : finite_sequence α m) (t : finite_sequence α n)
    : s.initial_segment_of (s.concat t) := begin
  unfold initial_segment_of, unfold initial_segment, unfold lift_value, simp,
  apply funext, intro is, unfold concat, simp, split_ifs, refl,
  have x := h is.property, exfalso, exact x,  
end

end finite_sequence

namespace infinite_sequence

def initial_segment (s : α^ℕ) (m : ℕ) : finite_sequence α m := λ is, s is

def initial_segment_of (s : finite_sequence α m) (t : α^ℕ) : Prop :=
  s = initial_segment t m

def concat (s : finite_sequence α m) (t : α^ℕ) : α^ℕ :=
  λ i, if h : i < m then s ⟨i, h⟩
    else t (i - m)

theorem initial_segment_of_concat (s : finite_sequence α m) (t : α^ℕ)
    : initial_segment_of s (concat s t) := begin
  unfold initial_segment_of, unfold initial_segment, apply funext, intro is,
  unfold concat, split_ifs, simp, exfalso, exact h is.property,
end

def concat_sequence : ℕ → ((α^<ℕ)^ℕ) → α
| i := λ (sᵢ : (α^<ℕ)^ℕ), let ⟨m, s₀⟩ := sᵢ 0 in
  if h : i < m then s₀ ⟨i, h⟩
  else concat_sequence  (i - m) (λ j, sᵢ j + 1)

end infinite_sequence