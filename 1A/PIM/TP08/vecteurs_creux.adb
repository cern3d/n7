with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Integer_Text_IO;         use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;           use Ada.Float_Text_IO;
with Ada.Unchecked_Deallocation;

package body Vecteurs_Creux is


	procedure Free is
		new Ada.Unchecked_Deallocation (T_Cellule, T_Vecteur_Creux);


	procedure Initialiser (V : out T_Vecteur_Creux) is
	begin
		V := Null;
	end Initialiser;


	procedure Detruire (V: in out T_Vecteur_Creux) is
	begin
		if not Est_Nul(V) then
            Detruire(V.all.Suivant);
            Free(V);
        else
            Null;
    	end if;
	end Detruire;


	function Est_Nul (V : in T_Vecteur_Creux) return Boolean is
	begin
		return V=Null;
	end Est_Nul;


	function Composante_Recursif (V : in T_Vecteur_Creux ; Indice : in Integer) return Float is
	begin
		if V.all.Indice > Indice then
			return 0.0;
		elsif V.all.Indice = Indice then
			return V.all.Valeur;
		else
			return Composante_Recursif(V.all.Suivant, Indice);
		end if;
	end Composante_Recursif;


	function Composante_Iteratif (V : in T_Vecteur_Creux ; Indice : in Integer) return Float is
	temp : T_Vecteur_Creux;
	begin
		temp := V;
		while temp/= null and then temp.all.Indice/=Indice loop
			if temp.all.Indice = Indice then
				return V.all.Valeur;
			else
				Null;
			end if;
			temp := temp.all.Suivant;
		end loop;
		return 0.0;
	end Composante_Iteratif;


	procedure Modifier (V : in out T_Vecteur_Creux ;
				       Indice : in Integer ;
					   Valeur : in Float ) is
	begin
	    if V=null  then
	        V.all.Indice := Indice;
	        V.all.Valeur := Valeur;
	        V.all.Suivant := null;
		elsif V.all.Indice = Indice then
			V.all.Valeur := Valeur;
		else
			Modifier(V.all.Suivant, Indice, Valeur);
		end if;
	end Modifier;


	function Sont_Egaux_Recursif (V1, V2 : in T_Vecteur_Creux) return Boolean is
	begin
		if V1=null and V2=null then
			return True;
		elsif V1.all.Valeur = V2.all.Valeur and V1.all.Indice=V1.all.Indice then
			return True and Sont_Egaux_Recursif(V1.all.Suivant, V2.all.Suivant);
		else
			return False;
		end if;
	end Sont_Egaux_Recursif;


	function Sont_Egaux_Iteratif (V1, V2 : in T_Vecteur_Creux) return Boolean is
	temp1 : T_Vecteur_Creux;
	temp2 : T_Vecteur_Creux;
	i:Integer;
	begin
		temp1 := V1;
		temp2 := V2;
		while temp1/= null and temp2/= null loop
			if Composante_Iteratif(V1, i) /= Composante_Iteratif(V2, i)  then
				return False;
			else
				Null;
			end if;
			i := i+1;
			temp1:=temp1.all.Suivant;
			temp2:=temp2.all.Suivant;
		end loop;
		return True;
	end Sont_Egaux_Iteratif;


	procedure Additionner (V1 : in out T_Vecteur_Creux; V2 : in T_Vecteur_Creux) is
	V : T_Vecteur_Creux;
	cursor : T_Vecteur_Creux;
	i: Integer;
	begin
		cursor := V;
		while V1/=null or V2/=null loop
			cursor.all.Valeur := Composante_Recursif(V1, i) + Composante_Recursif(V2, i);
			cursor := V.all.Suivant;
			i := i+1;
		end loop;
		V1 := V;
		Free(V);
	end Additionner;


	function Norme2 (V : in T_Vecteur_Creux) return Float is
	Norme : Float;
	temp : T_Vecteur_Creux;
	begin
		Norme := 0.0;
		temp := V;
		while temp/= null loop
			Norme := Norme + (temp.all.Valeur)*(temp.all.Valeur);
			temp := temp.all.Suivant;
		end loop;
		return Norme;
	end Norme2;


	Function Produit_Scalaire (V1, V2: in T_Vecteur_Creux) return Float is
	S : Float;
	temp1: T_Vecteur_Creux;
	temp2:T_Vecteur_Creux;
	begin
		S := 0.0;
		temp1 := V1;
		temp2 := V2;
		while temp1/=null or temp2/=null loop
			S := S + (temp1.all.Valeur)*(temp2.all.Valeur);
			temp1 := temp1.all.Suivant;
			temp2 := temp2.all.Suivant;
		end loop;
		return S;
	end Produit_Scalaire;


	procedure Afficher (V : T_Vecteur_Creux) is
	begin
		if V = Null then
			Put ("--E");
		else
			-- Afficher la composante V.all
			Put ("-->[ ");
			Put (V.all.Indice, 0);
			Put (" | ");
			Put (V.all.Valeur, Fore => 0, Aft => 1, Exp => 0);
			Put (" ]");

			-- Afficher les autres composantes
			Afficher (V.all.Suivant);
		end if;
	end Afficher;


	function Nombre_Composantes_Non_Nulles (V: in T_Vecteur_Creux) return Integer is
	begin
		if V = Null then
			return 0;
		else
			return 1 + Nombre_Composantes_Non_Nulles (V.all.Suivant);
		end if;
	end Nombre_Composantes_Non_Nulles;


end Vecteurs_Creux;
