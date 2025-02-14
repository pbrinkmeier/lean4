constant f : Nat → Nat
constant g : Nat → Nat

namespace Foo

@[scoped simp] axiom ax1 (x : Nat) : f (g x) = x
@[scoped simp] axiom ax2 (x : Nat) : g (g x) = g x

end Foo

theorem ex1 : f (g (g (g x))) = x := by
  simp -- does not use ax1 and ax2
  simp [Foo.ax1, Foo.ax2]

theorem ex2 : f (g (g (g x))) = x :=
  have h₁ : f (g (g (g x))) = f (g x) by simp; /- try again with `Foo` scoped lemmas -/ open Foo in simp
  have h₂ : f (g x) = x               by simp; open Foo in simp
  Eq.trans h₁ h₂
  -- open Foo in simp -- works

theorem ex3 : f (g (g (g x))) = x := by
  simp
  simp [Foo.ax1, Foo.ax2]

open Foo in
theorem ex4 : f (g (g (g x))) = x := by
  simp

theorem ex5 : f (g (g (g x))) = x ∧ f (g x) = x := by
  apply And.intro
  { simp; open Foo in simp }
  { simp; open Foo in simp }
