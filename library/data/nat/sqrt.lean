/-
Copyright (c) 2015 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Leonardo de Moura

Very simple (sqrt n) function that returns s s.t.
    s*s ≤ n ≤ s*s + s + s
-/
import data.nat.order data.nat.sub

namespace nat
open decidable

-- This is the simplest possible function that just performs a linear search
definition sqrt_aux : nat → nat → nat
| 0        n := 0
| (succ s) n := if (succ s)*(succ s) ≤ n then succ s else sqrt_aux s n

theorem sqrt_aux_succ_of_pos {s n} : (succ s)*(succ s) ≤ n → sqrt_aux (succ s) n = (succ s) :=
assume h, if_pos h

theorem sqrt_aux_succ_of_neg {s n} : ¬ (succ s)*(succ s) ≤ n → sqrt_aux (succ s) n = sqrt_aux s n :=
assume h, if_neg h

theorem sqrt_aux_of_le : ∀ {s n : nat}, s * s ≤ n → sqrt_aux s n = s
| 0        n h := rfl
| (succ s) n h := by rewrite [sqrt_aux_succ_of_pos h]

definition sqrt (n : nat) : nat :=
sqrt_aux n n

theorem sqrt_aux_lower : ∀ {s n : nat}, s ≤ n → sqrt_aux s n * sqrt_aux s n ≤ n
| 0        n h := h
| (succ s) n h := by_cases
  (λ h₁ : (succ s)*(succ s) ≤ n,   by rewrite [sqrt_aux_succ_of_pos h₁]; exact h₁)
  (λ h₂ : ¬ (succ s)*(succ s) ≤ n,
     assert aux : s ≤ n, from le_of_succ_le h,
     by rewrite [sqrt_aux_succ_of_neg h₂]; exact (sqrt_aux_lower aux))

theorem sqrt_lower (n : nat) : sqrt n * sqrt n ≤ n :=
sqrt_aux_lower (le.refl n)

theorem sqrt_aux_upper : ∀ {s n : nat}, n ≤ s*s + s + s → n ≤ sqrt_aux s n * sqrt_aux s n + sqrt_aux s n + sqrt_aux s n
| 0         n   h := h
| (succ s)  n   h := by_cases
  (λ h₁ : (succ s)*(succ s) ≤ n,
    by rewrite [sqrt_aux_succ_of_pos h₁]; exact h)
  (λ h₂ : ¬ (succ s)*(succ s) ≤ n,
    assert h₃ : n < (succ s) * (succ s), from lt_of_not_ge h₂,
    assert h₄ : n ≤ s * s + s + s, by rewrite [succ_mul_succ_eq at h₃]; exact le_of_lt_succ h₃,
    by rewrite [sqrt_aux_succ_of_neg h₂]; exact (sqrt_aux_upper h₄))

theorem sqrt_upper (n : nat) : n ≤ sqrt n * sqrt n + sqrt n + sqrt n :=
have aux : n ≤ n*n + n + n, from le_add_of_le_right (le_add_of_le_left (le.refl n)),
sqrt_aux_upper aux

private theorem le_squared : ∀ (n : nat), n ≤ n*n
| 0        := !le.refl
| (succ n) :=
  have   aux₁ : 1 ≤ succ n, from succ_le_succ !zero_le,
  assert aux₂ : 1 * succ n ≤ succ n * succ n, from mul_le_mul aux₁ !le.refl,
  by rewrite [one_mul at aux₂]; exact aux₂

theorem sqrt_aux_offset_eq {n k : nat} (h₁ : k ≤ n + n) : ∀ {s}, s ≥ n → sqrt_aux s (n*n + k) = n
| 0        h₂ :=
  assert neqz : n = 0, from eq_zero_of_le_zero h₂,
  by rewrite neqz
| (succ s) h₂ := by_cases
  (λ hl : (succ s)*(succ s) ≤ n*n + k,
     have   l₁ : n*n + k ≤ n*n + n + n,       from by rewrite [add.assoc]; exact (add_le_add_left h₁ (n*n)),
     assert l₂ : n*n + k < n*n + n + n + 1,   from lt_succ_of_le l₁,
     have   l₃ : n*n + k < (succ n)*(succ n), by rewrite [-succ_mul_succ_eq at l₂]; exact l₂,
     assert l₄ : (succ s)*(succ s) < (succ n)*(succ n), from lt_of_le_of_lt hl l₃,
     have   ng : ¬ succ s > (succ n), from
       assume g : succ s > succ n,
         have g₁ : (succ s)*(succ s) > (succ n)*(succ n), from mul_lt_mul_of_le_of_le g g,
         absurd (lt.trans g₁ l₄) !lt.irrefl,
     have sslesn  : succ s ≤ succ n, from le_of_not_gt ng,
     have ssnesn  : succ s ≠ succ n, from
       assume sseqsn : succ s = succ n,
         by rewrite [sseqsn at l₄]; exact (absurd l₄ !lt.irrefl),
     have   sslen : s < n, from lt_of_succ_lt_succ (lt_of_le_and_ne sslesn ssnesn),
     assert sseqn : succ s = n, from le.antisymm sslen h₂,
     by rewrite [sqrt_aux_succ_of_pos hl]; exact sseqn)
  (λ hg : ¬ (succ s)*(succ s) ≤ n*n + k,
    or.elim (eq_or_lt_of_le h₂)
     (λ neqss : n = succ s,
        have p : n*n ≤ n*n + k, from !le_add_right,
        have n : ¬ n*n ≤ n*n + k, by rewrite [-neqss at hg]; exact hg,
        absurd p n)
     (λ sgen : succ s > n,
        by rewrite [sqrt_aux_succ_of_neg hg]; exact (sqrt_aux_offset_eq (le_of_lt_succ sgen))))

theorem sqrt_offset_eq {n k : nat} : k ≤ n + n → sqrt (n*n + k) = n :=
assume h,
have h₁ : n ≤ n*n + k, from le.trans !le_squared !le_add_right,
sqrt_aux_offset_eq h h₁

theorem sqrt_eq (n : nat) : sqrt (n*n) = n :=
sqrt_offset_eq !zero_le

theorem mul_square_cancel {a b : nat} : a*a = b*b → a = b :=
assume h,
assert aux : sqrt (a*a) = sqrt (b*b), by rewrite h,
by rewrite [*sqrt_eq at aux]; exact aux
end nat
