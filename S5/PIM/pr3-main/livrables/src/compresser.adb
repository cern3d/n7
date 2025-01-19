with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Arbre_Huffman;         use Arbre_Huffman;
with File_Priorite;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Compresser is

   -- Types et constantes
   type T_Octet is mod 256;
   -- Tableau pour stocker les fréquences des octets
   type T_Tab_Frequence is array (T_Octet) of Natural;

   -- Type pour stocker le code binaire d'un symbole
   type T_Code is record
      Bits     : Unbounded_String;
      Longueur : Natural;
   end record;

   -- Table des codes de Huffman
   type T_Table_Huffman is array (T_Octet) of T_Code;

   -- Configuration du mode d'affichage
   Mode_Bavard : Boolean := True;

   -- Instanciation du module File_Priorite pour les arbres de Huffman
   function Comparer_Arbres (A, B : Noeud_Ptr) return Boolean is
   begin
      return Obtenir_Frequence (A.all) < Obtenir_Frequence (B.all);
   end Comparer_Arbres;

   package File_Huffman is new File_Priorite
     (Element_Type => Noeud_Ptr, Comparer => Comparer_Arbres);
   use File_Huffman;

   -- Calculer les fréquences des octets dans le fichier
   procedure Calculer_Frequences
     (Nom_Fichier : in String; Tab_Freq : out T_Tab_Frequence)
   is
      F     : Ada.Streams.Stream_IO.File_Type;
      S     : Stream_Access;
      Octet : T_Octet;
   begin
      -- Initialiser le tableau
      for I in Tab_Freq'Range loop
         Tab_Freq (I) := 0;
      end loop;

      -- Ouvrir le fichier et compter les occurrences
      Open (F, In_File, Nom_Fichier);
      S := Stream (F);
      while not End_Of_File (F) loop
         T_Octet'Read (S, Octet);
         Tab_Freq (Octet) := Tab_Freq (Octet) + 1;
      end loop;
      Close (F);
   end Calculer_Frequences;

   -- Construire l'arbre de Huffman
   function Construire_Arbre (Tab_Freq : in T_Tab_Frequence) return Noeud_Ptr
   is
      F               : File_Huffman.File;
      F_Temp : File_Huffman.File;  -- File temporaire pour la réorganisation
      N1, N2, Nouveau : Noeud_Ptr;

      -- Fonction locale pour vérifier si un nœud est une feuille
      function Est_Feuille (N : Noeud) return Boolean is
      begin
         return Obtenir_Gauche (N) = null and then Obtenir_Droit (N) = null;
      end Est_Feuille;

   begin
      Initialiser (F);
      Initialiser (F_Temp);

      -- Ajouter les feuilles pour chaque symbole
      for I in Tab_Freq'Range loop
         if Tab_Freq (I) > 0 then
            Ajouter (F, Creer_Noeud (Character'Val (I), Tab_Freq (I)));
         end if;
      end loop;

      -- Ajouter le symbole de fin de fichier
      Ajouter (F, Creer_Noeud (Character'Val (27), 0));

      -- Construire l'arbre
      while not Est_Vide (F) loop
         Retirer (F, N1);
         if Est_Vide (F) then
            return N1;
         end if;

         -- Chercher une feuille de même fréquence
         declare
            Trouve  : Boolean          := False;
            Freq_N1 : constant Integer := Obtenir_Frequence (N1.all);
         begin
            -- Parcourir la file à la recherche d'une feuille de même fréquence
            while not Est_Vide (F) and not Trouve loop
               Retirer (F, N2);

               if Est_Feuille (N2.all)
                 and then Obtenir_Frequence (N2.all) = Freq_N1
                 and then Est_Feuille (N1.all)
               then
                  -- On a trouvé une feuille de même fréquence
                  Trouve := True;
               else
                  -- Sinon, stocker temporairement le nœud
                  Ajouter (F_Temp, N2);
               end if;
            end loop;

            if not Trouve then
               -- Si on n'a pas trouvé de feuille de même fréquence, prendre le premier nœud stocké
               if not Est_Vide (F_Temp) then
                  Retirer (F_Temp, N2);
               end if;
            end if;

            -- Remettre les nœuds temporaires dans la file principale
            while not Est_Vide (F_Temp) loop
               declare
                  Temp : Noeud_Ptr;
               begin
                  Retirer (F_Temp, Temp);
                  Ajouter (F, Temp);
               end;
            end loop;
         end;

         -- Créer le nouveau nœud
         Nouveau :=
           Creer_Noeud
             (Character'Val (0),
              Obtenir_Frequence (N1.all) + Obtenir_Frequence (N2.all), N1, N2);
         Ajouter (F, Nouveau);
      end loop;

      return N1;
   end Construire_Arbre;

   -- Construire la table des codes
   procedure Construire_Table
     (Arbre  : in Noeud_Ptr; Table : out T_Table_Huffman;
      Code   : in Unbounded_String := To_Unbounded_String ("");
      Niveau : in Natural          := 0)
   is
   begin
      if Obtenir_Gauche (Arbre.all) = null and Obtenir_Droit (Arbre.all) = null
      then
         Table (T_Octet'Val (Character'Pos (Obtenir_Symbole (Arbre.all)))) :=
           (Bits => Code, Longueur => Niveau);
      else
         -- Parcourir récursivement
         if Obtenir_Gauche (Arbre.all) /= null then
            Construire_Table
              (Obtenir_Gauche (Arbre.all), Table, Code & '0', Niveau + 1);
         end if;
         if Obtenir_Droit (Arbre.all) /= null then
            Construire_Table
              (Obtenir_Droit (Arbre.all), Table, Code & '1', Niveau + 1);
         end if;
      end if;
   end Construire_Table;

   -- Écrire un octet dans le fichier
   procedure Ecrire_Octet (S : in Stream_Access; Octet : in T_Octet) is
   begin
      T_Octet'Write (S, Octet);
   end Ecrire_Octet;

   -- Écrire l'arbre de Huffman dans le fichier
   -- Collecter et écrire les symboles selon le parcours infixe
   procedure Ecrire_Symboles (S : in Stream_Access; Arbre : in Noeud_Ptr) is
      type T_Liste_Symboles is array (0 .. 255) of T_Octet;
      Liste_Symboles : T_Liste_Symboles;
      Nb_Symboles    : Natural := 0;
      Position_EOF   : T_Octet;

      -- Parcours infixe pour collecter les symboles
      procedure Parcours_Infixe (A : in Noeud_Ptr) is
      begin
         if A /= null then
            if Obtenir_Gauche (A.all) /= null then
               Parcours_Infixe (Obtenir_Gauche (A.all));
            end if;

            -- Si c'est une feuille
            if Obtenir_Gauche (A.all) = null and Obtenir_Droit (A.all) = null
            then
               declare
                  Val_Octet : T_Octet :=
                    T_Octet (Character'Pos (Obtenir_Symbole (A.all)));
               begin
                  if Val_Octet = T_Octet (Character'Pos (ASCII.ESC)) then
                     Position_EOF := T_Octet (Nb_Symboles);
                  else
                     Liste_Symboles (Nb_Symboles) := Val_Octet;
                     Nb_Symboles                  := Nb_Symboles + 1;
                  end if;
               end;
            end if;

            if Obtenir_Droit (A.all) /= null then
               Parcours_Infixe (Obtenir_Droit (A.all));
            end if;
         end if;
      end Parcours_Infixe;

   begin
      -- Collecter les symboles
      Parcours_Infixe (Arbre);

      -- Écrire la position du symbole EOF
      T_Octet'Write (S, Position_EOF);

      -- Écrire tous les symboles collectés
      for I in 0 .. Nb_Symboles - 1 loop
         T_Octet'Write (S, Liste_Symboles (I));
      end loop;

      -- Écrire le dernier symbole une deuxième fois
      if Nb_Symboles > 0 then
         T_Octet'Write (S, Liste_Symboles (Nb_Symboles - 1));
      end if;
   end Ecrire_Symboles;

   -- Écrire la structure de l'arbre sous forme de bits
   procedure Ecrire_Structure_Arbre
     (S : in Stream_Access; Arbre : in Noeud_Ptr; Position : in out Natural;
      Octet_Courant : in out T_Octet)
   is

      -- Procédure pour écrire un bit (0 ou 1)
      procedure Ecrire_Bit (Bit : in Integer) is
      begin
         if Position = 0 then
            Octet_Courant := 0;
         end if;

         if Bit = 1 then
            Octet_Courant := Octet_Courant or T_Octet (2**(7 - Position));
            Put ("1");
         else
            Put ("0");
         end if;
         Position := Position + 1;
         if Position = 8 then
            T_Octet'Write (S, Octet_Courant);
            Octet_Courant := 0;
            Position      := 0;
         end if;
      end Ecrire_Bit;

      -- Procédure récursive pour le parcours infixe
      procedure Parcours_Structure (A : in Noeud_Ptr) is
      begin
         if A = null then
            return;
         end if;

         -- Descendre à gauche
         if Obtenir_Gauche (A.all) /= null then
            Ecrire_Bit (0);  -- 0 pour descendre à gauche
            Parcours_Structure (Obtenir_Gauche (A.all));
         end if;

         -- Traiter le nœud actuel (si c'est une feuille)
         if Obtenir_Gauche (A.all) = null and then Obtenir_Droit (A.all) = null
         then
            Ecrire_Bit (1);  -- 1 pour une feuille
         end if;

         -- Descendre à droite
         if Obtenir_Droit (A.all) /= null then
            Parcours_Structure (Obtenir_Droit (A.all));
         end if;
      end Parcours_Structure;

      procedure Completer_Dernier_Octet is
      begin
         if Position > 0 then
            T_Octet'Write (S, Octet_Courant);
         end if;
      end Completer_Dernier_Octet;

   begin
      if Arbre = null then
         return;
      end if;
      Octet_Courant := 0;
      Position      := 0;
      -- Commencer le parcours
      Parcours_Structure (Arbre);

      Completer_Dernier_Octet;
   end Ecrire_Structure_Arbre;

   procedure Afficher_Table_Huffman (Table : in T_Table_Huffman) is
      function Format_Symbole (C : Character) return String is
      begin
         case C is
            when Character'Val (32) =>
               return "'" & " " & "'";
            when ASCII.LF =>
               return "'" & "\n" & "'";
            when ASCII.ESC =>
               return "'" & "\$" & "'";
            when others =>
               return "'" & C & "'";
         end case;
      end Format_Symbole;
   begin
      for I in T_Octet range 0 .. 255 loop
         if Length (Table (I).Bits) > 0 then
            Put (Format_Symbole (Character'Val (Integer (I))));
            Put (" --> ");
            Put_Line (To_String (Table (I).Bits));
         end if;
      end loop;
   end Afficher_Table_Huffman;

   -- Compresser le fichier
   procedure Compresser_Fichier (Nom_Fichier : in String) is
      Tab_Freq     : T_Tab_Frequence;
      Arbre        : Noeud_Ptr;
      Table        : T_Table_Huffman;
      F_In, F_Out  : Ada.Streams.Stream_IO.File_Type;
      S_In, S_Out  : Stream_Access;
      Octet        : T_Octet;
      Octet_Sortie : T_Octet := 0;
      Position_Bit : Natural := 0;
   begin
      -- Calculer les fréquences
      Calculer_Frequences (Nom_Fichier, Tab_Freq);

      -- Construire l'arbre de Huffman
      Arbre := Construire_Arbre (Tab_Freq);

      -- Construire la table des codes
      Construire_Table (Arbre, Table);

      if Mode_Bavard then
         Put_Line ("Compression de " & Nom_Fichier);
         Affichage_Arbre (Arbre);
         Put_Line ("");
         Afficher_Table_Huffman (Table);
      end if;

      -- Ouvrir les fichiers
      Open (F_In, In_File, Nom_Fichier);
      Create (F_Out, Out_File, Nom_Fichier & ".hff");
      S_In  := Stream (F_In);
      S_Out := Stream (F_Out);

      Ecrire_Symboles (S_Out, Arbre);

      -- Écrire la structure de l'arbre
      declare
         Position        : Natural := 0;
         Octet_Structure : T_Octet := 0;
      begin
         Put_Line ("");
         Ecrire_Structure_Arbre (S_Out, Arbre, Position, Octet_Structure);
         Put_Line ("");
      end;

      -- Compresser le fichier
      while not End_Of_File (F_In) loop
         T_Octet'Read (S_In, Octet);
         -- Écrire le code de l'octet
         for I in 1 .. Length (Table (Octet).Bits) loop
            if Element (Table (Octet).Bits, I) = '1' then
               Octet_Sortie := (Octet_Sortie * 2) or 1;
            else
               Octet_Sortie := (Octet_Sortie * 2) or 0;
            end if;
            Position_Bit := Position_Bit + 1;
            if Position_Bit = 8 then
               Ecrire_Octet (S_Out, Octet_Sortie);
               Octet_Sortie := 0;
               Position_Bit := 0;
            end if;
         end loop;
      end loop;

      -- Écrire le symbole de fin de fichier
      for I in 1 .. Length (Table (Character'Pos (ASCII.ESC)).Bits) loop
         if Element (Table (Character'Pos (ASCII.ESC)).Bits, I) = '1' then
            Octet_Sortie := (Octet_Sortie * 2) or 1;
         else
            Octet_Sortie := (Octet_Sortie * 2) or 0;
         end if;
         Position_Bit := Position_Bit + 1;
         if Position_Bit = 8 then
            Ecrire_Octet (S_Out, Octet_Sortie);
            Octet_Sortie := 0;
            Position_Bit := 0;
         end if;
      end loop;

      -- Écrire le dernier octet s'il est incomplet
      if Position_Bit > 0 then
         Ecrire_Octet (S_Out, Octet_Sortie);
      end if;

      -- Fermer les fichiers et libérer la mémoire
      Close (F_In);
      Close (F_Out);
      Detruire (Arbre);

      if Mode_Bavard then
         Put_Line ("Compression terminée");
      end if;
   end Compresser_Fichier;

   -- Programme principal
begin
   -- Traiter les options de la ligne de commande
   for I in 1 .. Argument_Count loop
      if Argument (I) = "-s" or Argument (I) = "--silencieux" then
         Mode_Bavard := False;
      elsif Argument (I) = "-b" or Argument (I) = "--bavard" then
         Mode_Bavard := True;
      else
         Compresser_Fichier (Argument (I));
      end if;
   end loop;

end Compresser;
