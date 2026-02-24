Require Import Naturelle.
Section Session1_2019_Logique_Exercice_2.

Variable A B : Prop.

Theorem Exercice_2_Naturelle : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
  intro H.
  E_ou (~A) (B).
  Hyp H.
  intro HbarA.
  I_ou_g.
  Hyp HbarA.
  intro HB.
  E_ou (A) (~A).
  TE.
  intro HA.
  I_ou_d.
  I_et.
  Hyp HA.
  Hyp HB.
  intro HbarA.
  I_ou_g.
  Hyp HbarA.
Qed.

Theorem Exercice_2_Coq : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
  intro H.
  elim H.
  intro HbarA.
  left.
  exact HbarA.
  intro HB.
  cut (A/\~A).
  intro H2.
  destruct H2 as (HA,HbarA).
  right.
  split.
  exact HA.
  exact HB.
  
Qed.

End Session1_2019_Logique_Exercice_2.

