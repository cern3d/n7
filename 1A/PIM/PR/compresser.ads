package LCA is

	type T_Cle is limited private;
   
	type T_Valeur is limited private;

	type T_LCA is limited private;

	procedure Initialiser(Sda: out T_LCA) with
		Post => Est_Vide (Sda);


	procedure Detruire (Sda : in out T_LCA);


	function Est_Vide (Sda : in T_LCA) return Boolean;

 
	function Taille (Sda : in T_LCA) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Sda);


	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Valeur : in T_Valeur) with
		Post => Cle_Presente (Sda, Cle) and (La_Valeur (Sda, Cle) = Valeur)
				and (not (Cle_Presente (Sda, Cle)'Old) or Taille (Sda) = Taille (Sda)'Old)
				and (Cle_Presente (Sda, Cle)'Old or Taille (Sda) = Taille (Sda)'Old + 1);

	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) with
		Post =>  Taille (Sda) = Taille (Sda)'Old - 1 
			and not Cle_Presente (Sda, Cle);         



	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean;


	function La_Valeur (Sda : in T_LCA ; Cle : in T_Cle) return T_Valeur;

   function Fusioner_Traiter ( Sdaun : in T_LCA, Sdadeux : in T_LCA) return T_LCA;

   function Fusioner is new Pour_Chaque(Fusioner_Traiter);

	generic
		with procedure Traiter (Cle : in T_Cle; Valeur: in T_Valeur);
	procedure Pour_Chaque (Sda : in T_LCA);


	generic
		with procedure Afficher_Cle (Cle : in T_Cle);
		with procedure Afficher_Donnee (Valeur : in T_Valeur);
	procedure Afficher_Debug (Sda : in T_LCA);


private
   
   type T_Valeur is new Integer;
   type T_Cle is new Character;
   type T_Noeud;
	type T_LCA is access T_Noued;
	type T_Noeud is 
	    record
	        Cle : T_Cle;
	        Valeur : T_Valeur;
	        Fils_G : T_LCA;
	        Fils_D : T_LCA;
	    end record;

	        

end LCA;