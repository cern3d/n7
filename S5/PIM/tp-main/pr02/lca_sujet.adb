with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;

procedure LCA_sujet is
	package LCA_String_Integer is
		new LCA (T_Cle => Unbounded_String, T_Valeur => Integer);
	use LCA_String_Integer;


    procedure Afficher_Cle_Valeur (Cle : in Unbounded_String ; Valeur : in Integer) is
    begin
        Put("-->[");
        Put ('"' & To_String (Cle) & '"');
        Put (" : ");
        Put(Valeur,0);
        Put ("]");
    end Afficher_Cle_Valeur;


    procedure Afficher is
            new Pour_Chaque(Afficher_Cle_Valeur);
    LCA : T_LCA;

begin

    Initialiser(LCA);
    Enregistrer(LCA, To_Unbounded_String("un"), 1);
    Enregistrer(LCA,  To_Unbounded_String("deux") , 2);
    Enregistrer(LCA,  To_Unbounded_String("2") , 2);
    Afficher(LCA);
    Put("--E");
    
    Detruire(LCA);

end LCA_sujet;
