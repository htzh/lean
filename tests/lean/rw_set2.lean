open nat

constant f : nat → nat
constant g : nat → nat

axiom foo : ∀ x, x > 0 → f x = 0 ∧ g x = 1
axiom bla : ∀ x, g x = f x + 1

attribute foo [rewrite]
attribute bla [rewrite]

print [rewrite]
