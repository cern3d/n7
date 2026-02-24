with LCA;


generic
   lenght : Integer;
   Type T_Cle is private;
   type T_Valeur is private;
   with function hashcoder(Cle: in T_Cle) return Integer;


package th is
   type T_HT is limited private;
   
   procedure Initialiser(Sda: out T_HT);

	procedure Detruire (Sda: in out T_HT);


	function Est_Vide (Sda : in T_HT) return Boolean;

 
	function Taille (Sda: in T_HT) return Integer with
		Post => Taille'Result >= 0;


	procedure Enregistrer (Sda : in out T_HT ; Cle : in T_Cle ; Valeur : in T_Valeur);

	procedure Supprimer (Sda : in out T_HT ; Cle : in T_Cle) with
		Post =>  Taille (Sda) = Taille (Sda)'Old - 1 
			and not Cle_Presente (Sda, Cle);         



	function Cle_Presente (Sda : in T_HT ; Cle : in T_Cle) return Boolean;


	function La_Valeur (Sda : in T_HT ; Cle : in T_Cle) return T_Valeur;



	generic
		with procedure Traiter_HT (Cle : in T_Cle; Valeur: in T_Valeur);
	procedure Pour_Chaque_HT (Sda : in T_HT);


	generic
		with procedure Afficher_Cle_HT (Cle : in T_Cle);
		with procedure Afficher_Donnee_HT (Valeur : in T_Valeur);
	procedure Afficher_Debug_HT (Sda : in T_HT);


private
   package LCA_HT is
            new LCA (T_Cle => T_Cle, T_Valeur => T_Valeur);
   use LCA_HT;
   type T_HT is array(1..lenght) of T_LCA;
end th;
