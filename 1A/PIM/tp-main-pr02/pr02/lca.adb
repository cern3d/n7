with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);


	procedure Initialiser(Sda: out T_LCA) is
	begin
        Sda :=null;
	end Initialiser;


    procedure Detruire (Sda : in out T_LCA) is
	begin
	if not Est_Vide(Sda) then
            Detruire(Sda.all.Suivant);
            Free(sda);
        else
            Null;
    end if;
    end Detruire;



	procedure Afficher_Debug (Sda : in T_LCA) is
    begin
        null;
             if Est_Vide(Sda) then
                 Put ("--E");
               else

                   Put ("-->[ ");
                   Afficher_Cle(Sda.all.Cle);
                   Put (" | ");
                   Afficher_Donnee(Sda.all.Valeur);
                   Put (" ] ");
                  Afficher_debug (Sda.all.Suivant);
              end if;
    end Afficher_Debug;




	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		return Sda=null;
    end;



	function Taille (Sda : in T_LCA) return Integer is
	begin
        if Est_Vide(Sda) then
            return 0;
        else
            return 1+Taille(Sda.all.Suivant);
        end if;
    end Taille;



	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Valeur : in T_Valeur) is
    copie : T_LCA;
    begin
	    if Sda = Null then
	        copie := new T_Cellule;
		    copie.all.Cle := Cle;
		    copie.all.Valeur := Valeur;
		    Initialiser(copie.all.Suivant);
		    Sda := copie;
		else
		    if Sda.all.Cle = Cle then
	            Sda.all.Valeur := Valeur;
		    else
		        Enregistrer(Sda.all.Suivant, Cle , Valeur);
		    end if;
		end if;
    end Enregistrer;



	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
	begin
		if Est_Vide(Sda) then
		    return FALSE;
		elsif Sda.all.Cle = Cle then
		    return TRUE;
		else
            return Cle_Presente (Sda.all.Suivant , Cle);
       end if;
    end;



	function La_Valeur (Sda : in T_LCA ; Cle : in T_Cle) return T_Valeur is
	begin
           if Est_Vide(Sda) then
              raise Cle_Absente_Exception;

           elsif Sda.all.cle=cle then
              return Sda.all.valeur;
           else
              return La_Valeur(Sda.all.suivant,Cle);
           end if;
    end La_Valeur;



	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
        temp : T_LCA;
    begin

        if Est_Vide(Sda) then
              raise Cle_Absente_Exception;
        elsif Sda.all.Cle = Cle  then
            temp := Sda;
            Sda := Sda.all.Suivant;
            Free (temp);
        else
            Supprimer (Sda.all.Suivant, Cle);
        end if;
    end Supprimer;



   procedure Pour_Chaque (Sda : in T_LCA) is
    copie : T_LCA;
    begin
       copie := Sda;
        while not Est_Vide(copie) loop
            begin
                Traiter(copie.all.Cle,copie.all.Valeur);
            exception
                when others =>
                    null;
            end;
            copie := copie.all.Suivant;
            end loop;
	end Pour_Chaque;



end LCA;
