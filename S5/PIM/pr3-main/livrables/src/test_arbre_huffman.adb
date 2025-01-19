with Ada.Text_IO;   use Ada.Text_IO;
with Arbre_Huffman; use Arbre_Huffman;

procedure Test_Arbre_Huffman is
   -- Variables
   Arbre : Noeud_Ptr := null;  -- Pointeur vers la racine de l'arbre
   Gauchee : Noeud_Ptr;
   Droitt : Noeud_Ptr;
begin
   -- Étape 1 : Création d'un arbre simple
   Put_Line ("=== TEST : Création d'un arbre ===");
   
   Gauchee := Creer_Noeud (Symbole => 'B',  Frequence =>5);
   Droitt := Creer_Noeud (Symbole =>'C',  Frequence =>15);
   Arbre  := Creer_Noeud ('A',  10, Droit => Droitt, Gauche => Gauchee);

   -- Étape 2 : Accès aux nœuds et affichage de l'arbre
   Put_Line ("=== TEST : Accès et affichage de l'arbre ===");
   Affichage_Arbre (Arbre);

   -- Étape 3 : Désallocation de l'arbre
   Put_Line ("=== TEST : Désallocation de l'arbre ===");
   Detruire (Arbre);

   -- Vérification que l'arbre a bien été désalloué
   if Arbre = null then
      Put_Line ("Arbre désalloué avec succès !");
   else
      Put_Line ("Échec de la désallocation de l'arbre !");
   end if;

end Test_Arbre_Huffman;
