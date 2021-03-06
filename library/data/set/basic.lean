/-
Copyright (c) 2014 Jeremy Avigad. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Jeremy Avigad, Leonardo de Moura
-/
import logic
open eq.ops

definition set [reducible] (X : Type) := X → Prop

namespace set

variable {X : Type}

/- membership and subset -/

definition mem [reducible] (x : X) (a : set X) := a x
infix `∈` := mem
notation a ∉ b := ¬ mem a b

theorem setext {a b : set X} (H : ∀x, x ∈ a ↔ x ∈ b) : a = b :=
funext (take x, propext (H x))

definition subset (a b : set X) := ∀⦃x⦄, x ∈ a → x ∈ b
infix `⊆` := subset

theorem subset.refl (a : set X) : a ⊆ a := take x, assume H, H

theorem subset.trans (a b c : set X) (subab : a ⊆ b) (subbc : b ⊆ c) : a ⊆ c :=
take x, assume ax, subbc (subab ax)

theorem subset.antisymm (a b : set X) (h₁ : a ⊆ b) (h₂ : b ⊆ a) : a = b :=
setext (λ x, iff.intro (λ ina, h₁ ina) (λ inb, h₂ inb))

definition strict_subset (a b : set X) := a ⊆ b ∧ a ≠ b
infix `⊂`:50 := strict_subset

theorem strict_subset.irrefl (a : set X) : ¬ a ⊂ a :=
assume h, absurd rfl (and.elim_right h)

/- bounded quantification -/

abbreviation bounded_forall (a : set X) (P : X → Prop) := ∀⦃x⦄, x ∈ a → P x
notation `forallb` binders `∈` a `,` r:(scoped:1 P, P) := bounded_forall a r
notation `∀₀` binders `∈` a `,` r:(scoped:1 P, P) := bounded_forall a r

abbreviation bounded_exists (a : set X) (P : X → Prop) := ∃⦃x⦄, x ∈ a ∧ P x
notation `existsb` binders `∈` a `,` r:(scoped:1 P, P) := bounded_exists a r
notation `∃₀` binders `∈` a `,` r:(scoped:1 P, P) := bounded_exists a r

/- empty set -/

definition empty [reducible] : set X := λx, false
notation `∅` := empty

theorem not_mem_empty (x : X) : ¬ (x ∈ ∅) :=
assume H : x ∈ ∅, H

theorem mem_empty_eq (x : X) : x ∈ ∅ = false := rfl

/- universal set -/

definition univ : set X := λx, true

theorem mem_univ (x : X) : x ∈ univ := trivial

theorem mem_univ_eq (x : X) : x ∈ univ = true := rfl

theorem empty_ne_univ [h : inhabited X] : (empty : set X) ≠ univ :=
assume H : empty = univ,
absurd (mem_univ (inhabited.value h)) (eq.rec_on H (not_mem_empty _))

/- union -/

definition union [reducible] (a b : set X) : set X := λx, x ∈ a ∨ x ∈ b
notation a ∪ b := union a b

theorem mem_union (x : X) (a b : set X) : x ∈ a ∪ b ↔ x ∈ a ∨ x ∈ b := !iff.refl

theorem mem_union_eq (x : X) (a b : set X) : x ∈ a ∪ b = (x ∈ a ∨ x ∈ b) := rfl

theorem union_self (a : set X) : a ∪ a = a :=
setext (take x, !or_self)

theorem union_empty (a : set X) : a ∪ ∅ = a :=
setext (take x, !or_false)

theorem empty_union (a : set X) : ∅ ∪ a = a :=
setext (take x, !false_or)

theorem union.comm (a b : set X) : a ∪ b = b ∪ a :=
setext (take x, or.comm)

theorem union.assoc (a b c : set X) : (a ∪ b) ∪ c = a ∪ (b ∪ c) :=
setext (take x, or.assoc)

/- intersection -/

definition inter [reducible] (a b : set X) : set X := λx, x ∈ a ∧ x ∈ b
notation a ∩ b := inter a b

theorem mem_inter (x : X) (a b : set X) : x ∈ a ∩ b ↔ x ∈ a ∧ x ∈ b := !iff.refl

theorem mem_inter_eq (x : X) (a b : set X) : x ∈ a ∩ b = (x ∈ a ∧ x ∈ b) := rfl

theorem inter_self (a : set X) : a ∩ a = a :=
setext (take x, !and_self)

theorem inter_empty (a : set X) : a ∩ ∅ = ∅ :=
setext (take x, !and_false)

theorem empty_inter (a : set X) : ∅ ∩ a = ∅ :=
setext (take x, !false_and)

theorem inter.comm (a b : set X) : a ∩ b = b ∩ a :=
setext (take x, !and.comm)

theorem inter.assoc (a b c : set X) : (a ∩ b) ∩ c = a ∩ (b ∩ c) :=
setext (take x, !and.assoc)

theorem inter_univ (a : set X) : a ∩ univ = a :=
setext (take x, !and_true)

theorem univ_inter (a : set X) : univ ∩ a = a :=
setext (take x, !true_and)

/- distributivity laws -/

theorem inter.distrib_left (s t u : set X) : s ∩ (t ∪ u) = (s ∩ t) ∪ (s ∩ u) :=
setext (take x, !and.distrib_left)

theorem inter.distrib_right (s t u : set X) : (s ∪ t) ∩ u = (s ∩ u) ∪ (t ∩ u) :=
setext (take x, !and.distrib_right)

theorem union.distrib_left (s t u : set X) : s ∪ (t ∩ u) = (s ∪ t) ∩ (s ∪ u) :=
setext (take x, !or.distrib_left)

theorem union.distrib_right (s t u : set X) : (s ∩ t) ∪ u = (s ∪ u) ∩ (t ∪ u) :=
setext (take x, !or.distrib_right)

/- set-builder notation -/

-- {x : X | P}
definition set_of (P : X → Prop) : set X := P
notation `{` binders `|` r:(scoped:1 P, set_of P) `}` := r

-- {x ∈ s | P}
definition filter (P : X → Prop) (s : set X) : set X := λx, x ∈ s ∧ P x
notation `{` binders ∈ s `|` r:(scoped:1 p, filter p s) `}` := r

-- '{x, y, z}
definition insert (x : X) (a : set X) : set X := {y : X | y = x ∨ y ∈ a}
notation `'{`:max a:(foldr `,` (x b, insert x b) ∅) `}`:0 := a

/- set difference -/

definition diff (s t : set X) : set X := {x ∈ s | x ∉ t}
infix `\`:70 := diff

theorem mem_of_mem_diff {s t : set X} {x : X} (H : x ∈ s \ t) : x ∈ s :=
and.left H

theorem not_mem_of_mem_diff {s t : set X} {x : X} (H : x ∈ s \ t) : x ∉ t :=
and.right H

theorem mem_diff {s t : set X} {x : X} (H1 : x ∈ s) (H2 : x ∉ t) : x ∈ s \ t :=
and.intro H1 H2

theorem mem_diff_iff (s t : set X) (x : X) : x ∈ s \ t ↔ x ∈ s ∧ x ∉ t := !iff.refl

theorem mem_diff_eq (s t : set X) (x : X) : x ∈ s \ t = (x ∈ s ∧ x ∉ t) := rfl

/- large unions -/

section
  variables {I : Type}
  variable a : set I
  variable b : I → set X
  variable C : set (set X)

  definition Inter  : set X := {x : X | ∀i, x ∈ b i}
  definition bInter : set X := {x : X | ∀₀ i ∈ a, x ∈ b i}
  definition sInter : set X := {x : X | ∀₀ c ∈ C, x ∈ c}
  definition Union  : set X := {x : X | ∃i, x ∈ b i}
  definition bUnion : set X := {x : X | ∃₀ i ∈ a, x ∈ b i}
  definition sUnion : set X := {x : X | ∃₀ c ∈ C, x ∈ c}

  -- TODO: need notation for these
end

end set
