/-
Copyright (c) 2014 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jeremy Avigad, Leonardo de Moura, Haitao Zhang

The propositional connectives. See also init.datatypes and init.logic.
-/
open eq.ops

variables {a b c d : Prop}

/- false -/

theorem false.elim {c : Prop} (H : false) : c :=
false.rec c H

/- implies -/

definition imp (a b : Prop) : Prop := a → b

theorem mt (H1 : a → b) (H2 : ¬b) : ¬a :=
assume Ha : a, absurd (H1 Ha) H2

theorem imp_true (a : Prop) : (a → true) ↔ true :=
iff.intro (assume H, trivial) (assume H H1, trivial)

theorem true_imp (a : Prop) : (true → a) ↔ a :=
iff.intro (assume H, H trivial) (assume H H1, H)

theorem imp_false (a : Prop) : (a → false) ↔ ¬ a := iff.rfl

theorem false_imp (a : Prop) : (false → a) ↔ true :=
iff.intro (assume H, trivial) (assume H H1, false.elim H1)

theorem imp_iff_imp (H1 : a ↔ c) (H2 : b ↔ d) : (a → b) ↔ (c → d) :=
iff.intro
  (λHab Hc, iff.elim_left H2 (Hab (iff.elim_right H1 Hc)))
  (λHcd Ha, iff.elim_right H2 (Hcd (iff.elim_left H1 Ha)))

/- not -/

theorem not.elim (H1 : ¬a) (H2 : a) : false := H1 H2

theorem not.intro (H : a → false) : ¬a := H

theorem not_not_intro (Ha : a) : ¬¬a :=
assume Hna : ¬a, absurd Ha Hna

theorem not_imp_not_of_imp {a b : Prop} : (a → b) → ¬b → ¬a :=
assume Pimp Pnb Pa, absurd (Pimp Pa) Pnb

theorem not_not_of_not_implies (H : ¬(a → b)) : ¬¬a :=
assume Hna : ¬a, absurd (assume Ha : a, absurd Ha Hna) H

theorem not_of_not_implies (H : ¬(a → b)) : ¬b :=
assume Hb : b, absurd (assume Ha : a, Hb) H

theorem not_not_em : ¬¬(a ∨ ¬a) :=
assume not_em : ¬(a ∨ ¬a),
have Hnp : ¬a, from
  assume Hp : a, absurd (or.inl Hp) not_em,
absurd (or.inr Hnp) not_em

theorem not_true [rewrite] : ¬ true ↔ false :=
iff.intro (assume H, H trivial) (assume H, false.elim H)

theorem not_false_iff [rewrite] : ¬ false ↔ true :=
iff.intro (assume H, trivial) (assume H H1, H1)

theorem not_iff_not (H : a ↔ b) : ¬a ↔ ¬b :=
iff.intro
  (λHna Hb, Hna (iff.elim_right H Hb))
  (λHnb Ha, Hnb (iff.elim_left  H Ha))


/- and -/

definition not_and_of_not_left (b : Prop) (Hna : ¬a) : ¬(a ∧ b) :=
assume H : a ∧ b, absurd (and.elim_left H) Hna

definition not_and_of_not_right (a : Prop) {b : Prop} (Hnb : ¬b) : ¬(a ∧ b) :=
assume H : a ∧ b, absurd (and.elim_right H) Hnb

theorem and.swap (H : a ∧ b) : b ∧ a :=
and.intro (and.elim_right H) (and.elim_left H)

theorem and_of_and_of_imp_of_imp (H₁ : a ∧ b) (H₂ : a → c) (H₃ : b → d) : c ∧ d :=
and.elim H₁ (assume Ha : a, assume Hb : b, and.intro (H₂ Ha) (H₃ Hb))

theorem and_of_and_of_imp_left (H₁ : a ∧ c) (H : a → b) : b ∧ c :=
and.elim H₁ (assume Ha : a, assume Hc : c, and.intro (H Ha) Hc)

theorem and_of_and_of_imp_right (H₁ : c ∧ a) (H : a → b) : c ∧ b :=
and.elim H₁ (assume Hc : c, assume Ha : a, and.intro Hc (H Ha))

theorem and.comm : a ∧ b ↔ b ∧ a :=
iff.intro (λH, and.swap H) (λH, and.swap H)

theorem and.assoc : (a ∧ b) ∧ c ↔ a ∧ (b ∧ c) :=
iff.intro
  (assume H,
   obtain [Ha Hb] Hc, from H,
   and.intro Ha (and.intro Hb Hc))
  (assume H,
   obtain Ha Hb Hc, from H,
   and.intro (and.intro Ha Hb) Hc)

theorem and_true [rewrite] (a : Prop) : a ∧ true ↔ a :=
iff.intro (assume H, and.left H) (assume H, and.intro H trivial)

theorem true_and [rewrite] (a : Prop) : true ∧ a ↔ a :=
iff.intro (assume H, and.right H) (assume H, and.intro trivial H)

theorem and_false [rewrite] (a : Prop) : a ∧ false ↔ false :=
iff.intro (assume H, and.right H) (assume H, false.elim H)

theorem false_and [rewrite] (a : Prop) : false ∧ a ↔ false :=
iff.intro (assume H, and.left H) (assume H, false.elim H)

theorem and_self [rewrite] (a : Prop) : a ∧ a ↔ a :=
iff.intro (assume H, and.left H) (assume H, and.intro H H)

theorem and_imp_eq (a b c : Prop) : (a ∧ b → c) = (a → b → c) :=
propext
  (iff.intro (λ Pl a b, Pl (and.intro a b))
  (λ Pr Pand, Pr (and.left Pand) (and.right Pand)))

theorem and_iff_right {a b : Prop} (Ha : a) : (a ∧ b) ↔ b :=
iff.intro
  (assume Hab, and.elim_right Hab)
  (assume Hb, and.intro Ha Hb)

theorem and_iff_left {a b : Prop} (Hb : b) : (a ∧ b) ↔ a :=
iff.intro
  (assume Hab, and.elim_left Hab)
  (assume Ha, and.intro Ha Hb)

theorem and_iff_and (H1 : a ↔ c) (H2 : b ↔ d) : (a ∧ b) ↔ (c ∧ d) :=
iff.intro
  (assume Hab, and.intro (iff.elim_left  H1 (and.left Hab)) (iff.elim_left  H2 (and.right Hab)))
  (assume Hcd, and.intro (iff.elim_right H1 (and.left Hcd)) (iff.elim_right H2 (and.right Hcd)))

/- or -/

definition not_or (Hna : ¬a) (Hnb : ¬b) : ¬(a ∨ b) :=
assume H : a ∨ b, or.rec_on H
  (assume Ha, absurd Ha Hna)
  (assume Hb, absurd Hb Hnb)

theorem or_of_or_of_imp_of_imp (H₁ : a ∨ b) (H₂ : a → c) (H₃ : b → d) : c ∨ d :=
or.elim H₁
  (assume Ha : a, or.inl (H₂ Ha))
  (assume Hb : b, or.inr (H₃ Hb))

theorem or_of_or_of_imp_left (H₁ : a ∨ c) (H : a → b) : b ∨ c :=
or.elim H₁
  (assume H₂ : a, or.inl (H H₂))
  (assume H₂ : c, or.inr H₂)

theorem or_of_or_of_imp_right (H₁ : c ∨ a) (H : a → b) : c ∨ b :=
or.elim H₁
  (assume H₂ : c, or.inl H₂)
  (assume H₂ : a, or.inr (H H₂))

theorem or.elim3 (H : a ∨ b ∨ c) (Ha : a → d) (Hb : b → d) (Hc : c → d) : d :=
or.elim H Ha (assume H₂, or.elim H₂ Hb Hc)

theorem or_resolve_right (H₁ : a ∨ b) (H₂ : ¬a) : b :=
or.elim H₁ (assume Ha, absurd Ha H₂) (assume Hb, Hb)

theorem or_resolve_left (H₁ : a ∨ b) (H₂ : ¬b) : a :=
or.elim H₁ (assume Ha, Ha) (assume Hb, absurd Hb H₂)

theorem or.swap (H : a ∨ b) : b ∨ a :=
or.elim H (assume Ha, or.inr Ha) (assume Hb, or.inl Hb)

theorem or.comm : a ∨ b ↔ b ∨ a :=
iff.intro (λH, or.swap H) (λH, or.swap H)

theorem or.assoc : (a ∨ b) ∨ c ↔ a ∨ (b ∨ c) :=
iff.intro
  (assume H, or.elim H
    (assume H₁, or.elim H₁
      (assume Ha, or.inl Ha)
      (assume Hb, or.inr (or.inl Hb)))
    (assume Hc, or.inr (or.inr Hc)))
  (assume H, or.elim H
    (assume Ha, (or.inl (or.inl Ha)))
    (assume H₁, or.elim H₁
      (assume Hb, or.inl (or.inr Hb))
      (assume Hc, or.inr Hc)))

theorem or_true [rewrite] (a : Prop) : a ∨ true ↔ true :=
iff.intro (assume H, trivial) (assume H, or.inr H)

theorem true_or [rewrite] (a : Prop) : true ∨ a ↔ true :=
iff.intro (assume H, trivial) (assume H, or.inl H)

theorem or_false [rewrite] (a : Prop) : a ∨ false ↔ a :=
iff.intro
  (assume H, or.elim H (assume H1 : a, H1) (assume H1 : false, false.elim H1))
  (assume H, or.inl H)

theorem false_or [rewrite] (a : Prop) : false ∨ a ↔ a :=
iff.intro
  (assume H, or.elim H (assume H1 : false, false.elim H1) (assume H1 : a, H1))
  (assume H, or.inr H)

theorem or_self (a : Prop) : a ∨ a ↔ a :=
iff.intro
  (assume H, or.elim H (assume H1, H1) (assume H1, H1))
  (assume H, or.inl H)

theorem or_iff_or (H1 : a ↔ c) (H2 : b ↔ d) : (a ∨ b) ↔ (c ∨ d) :=
iff.intro
  (λHab, or.elim Hab (λHa, or.inl (iff.elim_left  H1 Ha)) (λHb, or.inr (iff.elim_left  H2 Hb)))
  (λHcd, or.elim Hcd (λHc, or.inl (iff.elim_right H1 Hc)) (λHd, or.inr (iff.elim_right H2 Hd)))

/- distributivity -/

theorem and.distrib_left (a b c : Prop) : a ∧ (b ∨ c) ↔ (a ∧ b) ∨ (a ∧ c) :=
iff.intro
  (assume H, or.elim (and.right H)
    (assume Hb : b, or.inl (and.intro (and.left H) Hb))
    (assume Hc : c, or.inr (and.intro (and.left H) Hc)))
  (assume H, or.elim H
    (assume Hab, and.intro (and.left Hab) (or.inl (and.right Hab)))
    (assume Hac, and.intro (and.left Hac) (or.inr (and.right Hac))))

theorem and.distrib_right (a b c : Prop) : (a ∨ b) ∧ c ↔ (a ∧ c) ∨ (b ∧ c) :=
propext (!and.comm) ▸ propext (!and.comm) ▸ propext (!and.comm) ▸ !and.distrib_left

theorem or.distrib_left (a b c : Prop) : a ∨ (b ∧ c) ↔ (a ∨ b) ∧ (a ∨ c) :=
iff.intro
  (assume H, or.elim H
    (assume Ha, and.intro (or.inl Ha) (or.inl Ha))
    (assume Hbc, and.intro (or.inr (and.left Hbc)) (or.inr (and.right Hbc))))
  (assume H, or.elim (and.left H)
    (assume Ha, or.inl Ha)
    (assume Hb, or.elim (and.right H)
      (assume Ha, or.inl Ha)
      (assume Hc, or.inr (and.intro Hb Hc))))

theorem or.distrib_right (a b c : Prop) : (a ∧ b) ∨ c ↔ (a ∨ c) ∧ (b ∨ c) :=
propext (!or.comm) ▸ propext (!or.comm) ▸ propext (!or.comm) ▸ !or.distrib_left

/- iff -/

definition iff.def : (a ↔ b) = ((a → b) ∧ (b → a)) :=
!eq.refl

theorem iff_true [rewrite] (a : Prop) : (a ↔ true) ↔ a :=
iff.intro
  (assume H, iff.mp' H trivial)
  (assume H, iff.intro (assume H1, trivial) (assume H1, H))

theorem true_iff [rewrite] (a : Prop) : (true ↔ a) ↔ a :=
iff.intro
  (assume H, iff.mp H trivial)
  (assume H, iff.intro (assume H1, H) (assume H1, trivial))

theorem iff_false [rewrite] (a : Prop) : (a ↔ false) ↔ ¬ a :=
iff.intro
  (assume H, and.left H)
  (assume H, and.intro H (assume H1, false.elim H1))

theorem false_iff [rewrite] (a : Prop) : (false ↔ a) ↔ ¬ a :=
iff.intro
  (assume H, and.right H)
  (assume H, and.intro (assume H1, false.elim H1) H)

theorem iff_true_of_self (Ha : a) : a ↔ true :=
iff.intro (assume H, trivial) (assume H, Ha)

theorem iff_self [rewrite] (a : Prop) : (a ↔ a) ↔ true :=
iff_true_of_self !iff.refl

theorem forall_iff_forall {A : Type} {P Q : A → Prop} (H : ∀a, (P a ↔ Q a)) : (∀a, P a) ↔ ∀a, Q a :=
iff.intro (λp a, iff.elim_left (H a) (p a)) (λq a, iff.elim_right (H a) (q a))

theorem imp_iff {P : Prop} (Q : Prop) (p : P) : (P → Q) ↔ Q :=
iff.intro (λf, f p) (λq p, q)

theorem iff_iff_iff (H1 : a ↔ c) (H2 : b ↔ d) : (a ↔ b) ↔ (c ↔ d) :=
and_iff_and (imp_iff_imp H1 H2) (imp_iff_imp H2 H1)

/- if-then-else -/

section
  open eq.ops

  variables {A : Type} {c₁ c₂ : Prop}

  definition if_true [rewrite] (t e : A) : (if true then t else e) = t :=
  if_pos trivial

  definition if_false [rewrite] (t e : A) : (if false then t else e) = e :=
  if_neg not_false
end

/- congruences -/

theorem congr_not {a b :  Prop} (H : a ↔ b) : ¬a ↔ ¬b :=
iff.intro
  (assume H₁ : ¬a, assume H₂ : b, H₁ (iff.elim_right H H₂))
  (assume H₁ : ¬b, assume H₂ : a, H₁ (iff.elim_left H H₂))

section
  variables {a₁ b₁ a₂ b₂ : Prop}
  variables (H₁ : a₁ ↔ b₁) (H₂ : a₂ ↔ b₂)

  theorem congr_and : a₁ ∧ a₂ ↔ b₁ ∧ b₂ :=
  iff.intro
    (assume H₃ : a₁ ∧ a₂, and_of_and_of_imp_of_imp H₃ (iff.elim_left H₁) (iff.elim_left H₂))
    (assume H₃ : b₁ ∧ b₂, and_of_and_of_imp_of_imp H₃ (iff.elim_right H₁) (iff.elim_right H₂))

  theorem congr_or : a₁ ∨ a₂ ↔ b₁ ∨ b₂ :=
  iff.intro
    (assume H₃ : a₁ ∨ a₂, or_of_or_of_imp_of_imp H₃ (iff.elim_left H₁) (iff.elim_left H₂))
    (assume H₃ : b₁ ∨ b₂, or_of_or_of_imp_of_imp H₃ (iff.elim_right H₁) (iff.elim_right H₂))

  theorem congr_imp : (a₁ → a₂) ↔ (b₁ → b₂) :=
  iff.intro
    (assume H₃ : a₁ → a₂, assume Hb₁ : b₁, iff.elim_left H₂ (H₃ ((iff.elim_right H₁) Hb₁)))
    (assume H₃ : b₁ → b₂, assume Ha₁ : a₁, iff.elim_right H₂ (H₃ ((iff.elim_left H₁) Ha₁)))

  theorem congr_iff : (a₁ ↔ a₂) ↔ (b₁ ↔ b₂) :=
  iff.intro
    (assume H₃ : a₁ ↔ a₂, iff.trans (iff.symm H₁) (iff.trans H₃ H₂))
    (assume H₃ : b₁ ↔ b₂, iff.trans H₁ (iff.trans H₃ (iff.symm H₂)))
end
