with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Arbre_Huffman is

   -- Procédure pour désallouer un nœud individuel
   procedure Free is new Ada.Unchecked_Deallocation (Noeud, Noeud_Ptr);

   -- Crée un nouveau nœud
   function Creer_Noeud
     (Symbole       : Character; Frequence : Natural;
      Gauche, Droit : Noeud_Ptr := null) return Noeud_Ptr
   is
   begin
      return
        new Noeud'
          (Symbole => Symbole, Frequence => Frequence, Gauche => Gauche,
           Droit   => Droit);
   end Creer_Noeud;

   -- Accesseur pour le symbole
   function Obtenir_Symbole (N : Noeud) return Character is
   begin
      return N.Symbole;
   end Obtenir_Symbole;

   -- Accesseur pour la fréquence
   function Obtenir_Frequence (N : Noeud) return Natural is
   begin
      return N.Frequence;
   end Obtenir_Frequence;

   -- Accesseur pour le sous-arbre gauche
   function Obtenir_Gauche (N : Noeud) return Noeud_Ptr is
   begin
      return N.Gauche;
   end Obtenir_Gauche;

   -- Accesseur pour le sous-arbre droit
   function Obtenir_Droit (N : Noeud) return Noeud_Ptr is
   begin
      return N.Droit;
   end Obtenir_Droit;

   procedure Affichage_Arbre
     (Arbre         : in Noeud_Ptr; Indice_Droit : in Integer := 0;
      Indice_Gauche : in Integer := 0)
   is
      function Format_Symbole (C : Character) return String is
      begin
         case C is
            when ASCII.LF =>
               return "\n";
            when ' ' =>
               return " ";
            when ASCII.ESC =>
               return "\$";
            when others =>
               return "" & C & "";
         end case;
      end Format_Symbole;
   begin
      if Arbre = null then
         return;
      end if;

      -- Vérifie si le nœud est une feuille
      if Est_Feuille (Arbre.all) then
         Ada.Text_IO.Put ("(");
         Ada.Text_IO.Put (Integer'Image (Arbre.all.Frequence));
         Ada.Text_IO.Put (") ");
         Ada.Text_IO.Put ('"');
         Ada.Text_IO.Put (Format_Symbole (Obtenir_Symbole (Arbre.all)));
         Ada.Text_IO.Put ('"');
         Ada.Text_IO.New_Line;
      else
         -- Affiche le nœud courant
         Ada.Text_IO.Put ("(");
         Ada.Text_IO.Put (Integer'Image (Arbre.all.Frequence));
         Ada.Text_IO.Put (")");
         Ada.Text_IO.New_Line;

         -- Affichage pour le sous-arbre gauche
         for I in 1 .. Indice_Droit loop
            Ada.Text_IO.Put ("  |       ");
         end loop;
         Ada.Text_IO.Put ("  \--0--");
         Affichage_Arbre
           (Obtenir_Gauche (Arbre.all), Indice_Droit + 1, Indice_Gauche + 1);

         -- Affichage pour le sous-arbre droit
         for I in 1 .. Indice_Gauche loop
            Ada.Text_IO.Put ("  |       ");
         end loop;
         Ada.Text_IO.Put ("  \--1--");
         Affichage_Arbre
           (Obtenir_Droit (Arbre.all), Indice_Droit + 1, Indice_Gauche + 1);
      end if;
   end Affichage_Arbre;

   function Est_Feuille (N : in Noeud) return Boolean is
   begin
      return Obtenir_Gauche (N) = null and then Obtenir_Droit (N) = null;
   end Est_Feuille;

   -- Désalloue l'arbre entier récursivement
   procedure Detruire (Arbre : in out Noeud_Ptr) is
   begin
      if Arbre /= null then
         Detruire (Arbre.Gauche);
         Detruire (Arbre.Droit);
         Free (Arbre); -- Utilisation de `Free` pour libérer le nœud courant
         Arbre := null;  -- Bonne pratique pour éviter des accès invalides
      end if;
   end Detruire;

end Arbre_Huffman;
