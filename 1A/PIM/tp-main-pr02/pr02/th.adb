with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;


package body th is

   function Calcule(Cle : in T_Cle) return Integer is
   begin
      return (hashcoder(Cle)-1) mod lenght+1;
   end Calcule;


	procedure Initialiser(Sda :  out T_HT) is
	begin
      for i in 1..lenght loop
        Initialiser(Sda(i));
      end loop;
	end Initialiser;


   procedure Detruire (Sda : in out T_HT) is
	begin
   for i in 1..lenght loop
            Detruire(Sda(i));
    end loop;
    end Detruire;



	procedure Afficher_Debug_HT (Sda : in T_HT) is

   procedure Afficher_Debug_SDA is new Afficher_Debug(Afficher_Cle => Afficher_Cle_HT,Afficher_Donnee=>Afficher_Donnee_HT);

    begin
        for i in 1..lenght loop
            Put(Integer'Image(i-1));
            Afficher_Debug_SDA(Sda(i));
            Put_Line("");
         end loop;
    end Afficher_Debug_HT;




	function Est_Vide (Sda : in T_HT) return Boolean is
   S :Boolean;
	begin
      S:= True;
      for i in 1..lenght loop
         S := S and Est_Vide(Sda(i));
      end loop;
		return S;
    end;



	function Taille (Sda : in T_HT) return Integer is
   S : Integer;
	begin
      if Est_Vide(Sda) then
         return 0;
      else
         S := 0;
         for i in 1..lenght loop
            S := S + Taille(Sda(i));
         end loop;
         return S;
      end if;
    end Taille;



	procedure Enregistrer (Sda : in out T_HT ; Cle : in T_Cle ; Valeur : in T_Valeur) is
    begin
	    Enregistrer(Sda(Calcule(Cle)), Cle, Valeur);
    end Enregistrer;



	function Cle_Presente (Sda : in T_HT ; Cle : in T_Cle) return Boolean is
   code : Integer;
    begin
      code := Calcule(Cle);
      return Cle_Presente(Sda(code) , Cle);
    end;



	function La_Valeur (Sda : in T_HT ; Cle : in T_Cle) return T_Valeur is
	code : Integer;
    begin
      code := Calcule(Cle);
      return La_Valeur(Sda(code) , Cle);
    end La_Valeur;



	procedure Supprimer (Sda : in out T_HT ; Cle : in T_Cle) is
   code : Integer;
    begin
      code := Calcule(Cle);
      Supprimer(Sda(code) , Cle);
    end Supprimer;



   procedure Pour_Chaque_HT (Sda : in T_HT) is
      procedure Pour_Chaque_LCA is new Pour_Chaque (Traiter => Traiter_HT);
      begin
        for i in 1..lenght loop
             Pour_Chaque_LCA(Sda(i));
        end loop;
	end Pour_Chaque_HT;



end th;
