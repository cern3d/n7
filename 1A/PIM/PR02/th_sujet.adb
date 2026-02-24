with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with th;

procedure th_sujet is
   package HT_string is
            new th (lenght => 11, T_Cle => Unbounded_String, T_Valeur => Integer, hashcoder => Length);
   use HT_string;

   function Avec_Guillemets (S: Unbounded_String) return String is
	begin
		return '"' & To_String (S) & '"';
	end;


	procedure Afficher (S : in Unbounded_String; N: in Integer) is
	begin
		Put (Avec_Guillemets (S));
		Put (" : ");
		Put (N, 1);
		New_Line;
	end Afficher;

	procedure Afficher is
		new Pour_Chaque_HT (Afficher);


	procedure Afficher_Avec_Guillemets (S : in Unbounded_String) is
	begin
		Put (Avec_Guillemets (S));
	end Afficher_Avec_Guillemets;

	procedure Afficher (N: in Integer) is 
	begin
		Put (N, 1);
	end;

	procedure Afficher_Interne is
		new Afficher_Debug_HT(Afficher_Avec_Guillemets, Afficher);
   
   Hashtable : T_HT;
begin
Initialiser(Hashtable);

    Enregistrer(Hashtable, To_Unbounded_String("un"), 1);
    Enregistrer(Hashtable, To_Unbounded_String("deux"), 2);
    Enregistrer(Hashtable, To_Unbounded_String("trois"), 3);
    Enregistrer(Hashtable, To_Unbounded_String("quatre"), 4);
    Enregistrer(Hashtable, To_Unbounded_String("cinq"), 5);
    Enregistrer(Hashtable, To_Unbounded_String("quatre-vingt-dix-neuf"), 99);
    Enregistrer(Hashtable, To_Unbounded_String("vingt-et-un"), 21);



    Afficher_Interne(Hashtable);
    Detruire(Hashtable);


end th_sujet;