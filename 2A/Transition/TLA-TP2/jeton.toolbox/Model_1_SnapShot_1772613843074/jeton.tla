---------------- MODULE jeton ----------------
\* Time-stamp: <09 oct 2024 11:55 Philippe Queinnec>

(* Algorithme d'exclusion mutuelle à base de jeton. *)

EXTENDS Naturals, FiniteSets, Sequences

CONSTANT N

ASSUME N \in Nat /\ N > 1

Processus == 0..N-1

Hungry == "H"
Thinking == "T"
Eating == "E"

VARIABLES
  etat,
  jeton,
  canal

TypeOK ==
   [] (/\ etat \in [ Processus -> {Hungry,Thinking,Eating} ]
       /\ jeton \in [Processus -> BOOLEAN]
       /\ canal \in [Processus -> Seq (BOOLEAN)] )
       
JetonExiste == [] (\E i \in Processus : jeton[i])
  
JetonUnique == [] (\A i,j \in Processus :(jeton[i] /\ jeton[j]) => i = j)

CanalUnique == [] (\A i,j \in Processus :(Len(canal[i]) > 0 /\ Len(canal[j]) > 0) => i = j)

PasDeDuplication == [] (\A i \in Processus : jeton[i] => Len(canal[(i-1)%N]) = 0)

ExclMutuelle == [] (\A i,j \in Processus : (etat[i]= Eating /\ etat[j]= Eating) => i = j)

VivaciteIndividuelle == (\A i \in Processus : (etat[i]= Hungry) ~> (etat[i]= Eating))

VivaciteGlobale == (\E i \in Processus : (etat[i]= Hungry))~>( \E j \in Processus : (etat[j]= Eating))

JetonVaPartout == (\A i \in Processus : <>(jeton[i]))

Sanity ==
  [] (\A i \in Processus : etat[i] = Eating => jeton[i])

----------------------------------------------------------------

Init ==
 /\ etat = [ i \in Processus |-> Thinking ]
 /\ \E i \in Processus :
        jeton = [ j \in Processus |-> j=i ]
 /\ canal = [ i \in Processus |-> <<>> ]

demander(i) ==
  /\ etat[i] = Thinking
  /\ etat' = [ etat EXCEPT ![i] = Hungry ]
  /\ UNCHANGED jeton

entrer(i) ==
  /\ etat[i] = Hungry
  /\ jeton[i]
  /\ etat' = [ etat EXCEPT ![i] = Eating ]
  /\ UNCHANGED jeton

sortir(i) ==
  /\ etat[i] = Eating
  /\ etat' = [ etat EXCEPT ![i] = Thinking ]
  /\ UNCHANGED jeton

bouger(i) ==
  /\ jeton[i]
  /\ etat[i] # Eating
  /\ jeton' = [ jeton EXCEPT ![i] = FALSE , ![(i+1)%N] = TRUE ]
  /\ UNCHANGED etat

envoyer(i) ==
  /\ jeton[i]
  /\ etat[i] # Eating
  /\ canal[i] = << >>
  /\ jeton' = [jeton EXCEPT ![i] = FALSE]
  /\ canal' = [canal EXCEPT ![i] = Append(@, TRUE)]
  /\ UNCHANGED etat
  
recevoir(i) ==
  /\ Len(canal[(i-1)%N]) > 0
  /\ jeton[i] = FALSE
  /\ jeton' = [jeton EXCEPT ![i] = TRUE]
  /\ canal' = [canal EXCEPT ![(i-1)%N] = Tail(@)]
  /\ UNCHANGED etat
  
Next ==
 \E i \in Processus :
    \/ demander(i)
    \/ entrer(i)
    \/ sortir(i)
    \/ recevoir(i)
    \/ envoyer(i)

Fairness == \A i \in Processus :
              /\ WF_<<etat,jeton>> (sortir(i))
              /\ WF_<<etat,jeton>> (bouger(i))
              /\ SF_<<etat,jeton>> (entrer(i))

Spec ==
 /\ Init
 /\ [] [ Next ]_<<etat,jeton>>
 /\ Fairness

================
