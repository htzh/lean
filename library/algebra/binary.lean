/-
Copyright (c) 2014 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Leonardo de Moura, Jeremy Avigad

General properties of binary operations.
-/
open eq.ops function

namespace binary
  section
    variable {A : Type}
    variables (op₁ : A → A → A) (inv : A → A) (one : A)

    local notation a * b := op₁ a b
    local notation a ⁻¹  := inv a
    local notation 1     := one

    definition commutative [reducible] := ∀a b, a * b = b * a
    definition associative [reducible] := ∀a b c, (a * b) * c = a * (b * c)
    definition left_identity [reducible] := ∀a, 1 * a = a
    definition right_identity [reducible] := ∀a, a * 1 = a
    definition left_inverse [reducible] := ∀a, a⁻¹ * a = 1
    definition right_inverse [reducible] := ∀a, a * a⁻¹ = 1
    definition left_cancelative [reducible] := ∀a b c, a * b = a * c → b = c
    definition right_cancelative [reducible] := ∀a b c, a * b = c * b → a = c

    definition inv_op_cancel_left [reducible] := ∀a b, a⁻¹ * (a * b) = b
    definition op_inv_cancel_left [reducible] := ∀a b, a * (a⁻¹ * b) = b
    definition inv_op_cancel_right [reducible] := ∀a b, a * b⁻¹ * b =  a
    definition op_inv_cancel_right [reducible] := ∀a b, a * b * b⁻¹ = a

    variable (op₂ : A → A → A)

    local notation a + b := op₂ a b

    definition left_distributive [reducible] := ∀a b c, a * (b + c) = a * b + a * c
    definition right_distributive [reducible] := ∀a b c, (a + b) * c = a * c + b * c

    definition right_commutative [reducible] {B : Type} (f : B → A → B) := ∀ b a₁ a₂, f (f b a₁) a₂ = f (f b a₂) a₁
    definition left_commutative [reducible] {B : Type}  (f : A → B → B) := ∀ a₁ a₂ b, f a₁ (f a₂ b) = f a₂ (f a₁ b)
  end

  section
    variable {A : Type}
    variable {f : A → A → A}
    variable H_comm : commutative f
    variable H_assoc : associative f
    local infixl `*` := f
    theorem left_comm : left_commutative f :=
    take a b c, calc
      a*(b*c) = (a*b)*c  : H_assoc
        ...   = (b*a)*c  : H_comm
        ...   = b*(a*c)  : H_assoc

    theorem right_comm : right_commutative f :=
    take a b c, calc
      (a*b)*c = a*(b*c) : H_assoc
        ...   = a*(c*b) : H_comm
        ...   = (a*c)*b : H_assoc
  end

  section
    variable {A : Type}
    variable {f : A → A → A}
    variable H_assoc : associative f
    local infixl `*` := f
    theorem assoc4helper (a b c d) : (a*b)*(c*d) = a*((b*c)*d) :=
    calc
      (a*b)*(c*d) = a*(b*(c*d)) : H_assoc
              ... = a*((b*c)*d) : H_assoc
  end

  definition right_commutative_compose_right [reducible]
    {A B : Type} (f : A → A → A) (g : B → A) (rcomm : right_commutative f) : right_commutative (compose_right f g) :=
  λ a b₁ b₂, !rcomm

  definition left_commutative_compose_left [reducible]
    {A B : Type} (f : A → A → A) (g : B → A) (lcomm : left_commutative f) : left_commutative (compose_left f g) :=
  λ a b₁ b₂, !lcomm
end binary
