with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Command_Line;      use Ada.Command_Line;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Arbre_Huffman;         use Arbre_Huffman;
with File_Priorite;
with Ada.IO_Exceptions;

procedure Decompresser is

   -- Types et constantes
   type T_Octet is mod 256;

   -- Type pour le tableau de symboles
   type T_Tab_Symboles is array (0 .. 255) of Character;

   -- Type pour gérer la lecture bit par bit
   type T_Bit_Buffer is record
      Octet_Courant : T_Octet;
      Position_Bit  : Integer;
      Stream        : Stream_Access;
      Fin_Fichier   : Boolean;
   end record;

   -- Configuration du mode d'affichage
   Mode_Bavard : Boolean := True;

   -- Initialiser le buffer de bits
   procedure Init_Bit_Buffer (Buffer : out T_Bit_Buffer; S : Stream_Access) is
   begin
      Buffer.Stream       := S;
      Buffer.Position_Bit := 8;  -- Force la lecture d'un nouvel octet
      Buffer.Fin_Fichier  := False;
   end Init_Bit_Buffer;

   -- Lire un bit depuis le buffer
   function Lire_Bit (Buffer : in out T_Bit_Buffer) return Integer is
   begin
      if Buffer.Position_Bit = 8 then
         T_Octet'Read (Buffer.Stream, Buffer.Octet_Courant);
         Buffer.Position_Bit := 0;
      end if;

      declare
         Bit : constant Integer :=
           (if
              (Buffer.Octet_Courant and
               T_Octet (2**(7 - Buffer.Position_Bit))) /=
              0
            then 1
            else 0);
      begin
         Buffer.Position_Bit := Buffer.Position_Bit + 1;
         return Bit;
      end;
   exception
      when Ada.IO_Exceptions.End_Error =>
         Buffer.Fin_Fichier := True;
         return 0;
   end Lire_Bit;

   -- Lire un octet depuis le fichier
   procedure Lire_Octet (S : in Stream_Access; Octet : out T_Octet) is
   begin
      T_Octet'Read (S, Octet);
   end Lire_Octet;

   -- Lire la liste des symboles du fichier compressé
   procedure Lire_Symboles
     (S        : in     Stream_Access; Position_FDF : out Integer;
      Symboles :    out T_Tab_Symboles; Nb_Symboles : out Integer)
   is
      Octet, Dernier_Octet : T_Octet;
   begin
      -- Lire la position du symbole de fin de fichier
      Lire_Octet (S, Octet);
      Position_FDF := Integer (Octet);
      Nb_Symboles  := 0;

      -- Lire les symboles jusqu'à trouver deux octets identiques consécutifs
      if Nb_Symboles = Position_FDF then
         Symboles (Position_FDF) := Character'Val (27);
         Nb_Symboles             := Nb_Symboles + 1;
      end if;

      Lire_Octet (S, Dernier_Octet);
      Symboles (Nb_Symboles) := Character'Val (Dernier_Octet);
      Nb_Symboles            := Nb_Symboles + 1;

      loop
         Lire_Octet (S, Octet);
         exit when Octet = Dernier_Octet;
         if Nb_Symboles = Position_FDF then
            Symboles (Position_FDF) := Character'Val (27);
            Nb_Symboles             := Nb_Symboles + 1;
         end if;
         Symboles (Nb_Symboles) := Character'Val (Octet);
         Nb_Symboles            := Nb_Symboles + 1;
         Dernier_Octet          := Octet;
      end loop;
   end Lire_Symboles;

   -- Reconstruire l'arbre à partir de sa structure binaire
   function Reconstruire_Arbre
     (Buffer        : in out T_Bit_Buffer; Symboles : in T_Tab_Symboles;
      Index_Symbole : in out Integer) return Noeud_Ptr
   is
   begin
      if Lire_Bit (Buffer) = 1 then
         -- C'est une feuille
         declare
            Nouveau_Noeud : constant Noeud_Ptr :=
              Creer_Noeud (Symboles (Index_Symbole), 0);
         begin
            Index_Symbole := Index_Symbole + 1;
            return Nouveau_Noeud;
         end;
      else
         -- C'est un nœud interne
         declare
            Gauche, Droit : Noeud_Ptr;
         begin
            Gauche := Reconstruire_Arbre (Buffer, Symboles, Index_Symbole);
            Droit  := Reconstruire_Arbre (Buffer, Symboles, Index_Symbole);
            return Creer_Noeud (Character'Val (0), 0, Gauche, Droit);
         end;
      end if;
   end Reconstruire_Arbre;

   -- Décompresser le fichier
   procedure Decompresser_Fichier (Nom_Fichier : in String) is
      F_In, F_Out   : Ada.Streams.Stream_IO.File_Type;
      S_In, S_Out   : Stream_Access;
      Symboles      : T_Tab_Symboles;
      Position_FDF  : Integer;
      Nb_Symboles   : Integer;
      Arbre         : Noeud_Ptr;
      Noeud_Courant : Noeud_Ptr;
      Index_Symbole : Integer := 0;
      Buffer        : T_Bit_Buffer;
      Bit           : Integer;
   begin
      if Mode_Bavard then
         Put_Line ("Décompression de " & Nom_Fichier);
      end if;

      -- Vérifier l'extension .hff
      if Nom_Fichier'Length <= 4
        or else Nom_Fichier (Nom_Fichier'Last - 3 .. Nom_Fichier'Last) /=
          ".hff"
      then
         Put_Line ("Le fichier doit avoir l'extension .hff");
         return;
      end if;

      -- Ouvrir les fichiers
      Open (F_In, In_File, Nom_Fichier);
      Create (F_Out, Out_File, Nom_Fichier & ".d");
      S_In  := Stream (F_In);
      S_Out := Stream (F_Out);

      -- Lire la liste des symboles
      Lire_Symboles (S_In, Position_FDF, Symboles, Nb_Symboles);

      -- Initialiser le buffer de bits
      Init_Bit_Buffer (Buffer, S_In);

      -- Reconstruire l'arbre
      Index_Symbole := 0;
      Arbre         := Reconstruire_Arbre (Buffer, Symboles, Index_Symbole);

      if Mode_Bavard then
         Put_Line ("Arbre reconstruit :");
         Affichage_Arbre (Arbre);
      end if;

      Init_Bit_Buffer (Buffer, S_In);

      -- Décompression
      Noeud_Courant := Arbre;
      while not Buffer.Fin_Fichier loop
         Bit := Lire_Bit (Buffer);

         if Bit = 1 then
            Noeud_Courant := Obtenir_Droit (Noeud_Courant.all);
         else
            Noeud_Courant := Obtenir_Gauche (Noeud_Courant.all);
         end if;

         -- Si on arrive sur une feuille
         if Obtenir_Gauche (Noeud_Courant.all) = null
           and then Obtenir_Droit (Noeud_Courant.all) = null
         then
            -- Vérifier si c'est le symbole de fin de fichier
            if Character'Pos (Obtenir_Symbole (Noeud_Courant.all)) =
              Character'Pos (Symboles (Position_FDF))
            then
               exit;
            end if;

            -- Écrire le symbole dans le fichier de sortie
            Character'Write (S_Out, Obtenir_Symbole (Noeud_Courant.all));
            Noeud_Courant := Arbre;
         end if;
      end loop;

      -- Fermer les fichiers et libérer la mémoire
      Close (F_In);
      Close (F_Out);
      Detruire (Arbre);

      if Mode_Bavard then
         Put_Line ("Décompression terminée");
      end if;

   exception
      when others =>
         Put_Line ("Erreur lors de la décompression");
         if Is_Open (F_In) then
            Close (F_In);
         end if;
         if Is_Open (F_Out) then
            Close (F_Out);
         end if;
         if Arbre /= null then
            Detruire (Arbre);
         end if;
         raise;
   end Decompresser_Fichier;

   -- Programme principal
begin
   -- Traiter les options de la ligne de commande
   for I in 1 .. Argument_Count loop
      if Argument (I) = "-s" or Argument (I) = "--silencieux" then
         Mode_Bavard := False;
      elsif Argument (I) = "-b" or Argument (I) = "--bavard" then
         Mode_Bavard := True;
      else
         Decompresser_Fichier (Argument (I));
      end if;
   end loop;

end Decompresser;
