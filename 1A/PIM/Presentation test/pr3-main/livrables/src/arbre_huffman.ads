package Arbre_Huffman is

   type Noeud is private;
   type Noeud_Ptr is access all Noeud;

   -- Crée un nœud avec un symbole, une fréquence et des enfants
   function Creer_Noeud
     (Symbole       : Character; Frequence : Natural;
      Gauche, Droit : Noeud_Ptr := null) return Noeud_Ptr;

   -- Accesseurs pour les champs d'un nœud
   function Obtenir_Symbole (N : Noeud) return Character;
   function Obtenir_Frequence (N : Noeud) return Natural;
   function Obtenir_Gauche (N : Noeud) return Noeud_Ptr;
   function Obtenir_Droit (N : Noeud) return Noeud_Ptr;

   -- Désalloue un arbre entier (détruit tous les nœuds récursivement)
   procedure Detruire (Arbre : in out Noeud_Ptr);

   function Est_Feuille (N : in Noeud) return Boolean;

   procedure Affichage_Arbre
     (Arbre         : in Noeud_Ptr; Indice_Droit : in Integer := 0;
      Indice_Gauche : in Integer := 0);

private
   -- Structure interne du nœud
   type Noeud is record
      Symbole   : Character;
      Frequence : Natural;
      Gauche    : Noeud_Ptr := null;
      Droit     : Noeud_Ptr := null;
   end record;
end Arbre_Huffman;
