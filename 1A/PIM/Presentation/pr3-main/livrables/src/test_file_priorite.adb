with Ada.Text_IO; use Ada.Text_IO;
with File_Priorite;

procedure Test_File_Priorite is
   -- Définition d'un type élément avec une valeur entière
   type Element is record
      Valeur : Integer;
   end record;

   -- Fonction de comparaison pour un min-tas (priorité = plus petite valeur)
   function Comparer(Left, Right : Element) return Boolean is
   begin
      return Left.Valeur < Right.Valeur; -- Plus petite valeur est prioritaire
   end Comparer;

   package File_Int is new File_Priorite(Element_Type => Element, Comparer => Comparer);
   use File_Int;

   -- Variables pour tester la file de priorité
   Ma_File : File;
   Elt     : Element;

begin
   -- Initialisation
   Put_Line("Test de la file de priorité");
   Initialiser(Ma_File);

   -- Test : Ajouter des éléments
   Put_Line("Ajout de 5 éléments avec des priorités différentes...");
   Ajouter(Ma_File, (Valeur => 20));
   Ajouter(Ma_File, (Valeur => 15));
   Ajouter(Ma_File, (Valeur => 30));
   Ajouter(Ma_File, (Valeur => 10));
   Ajouter(Ma_File, (Valeur => 25));

   -- Vérification des éléments (Retirer les éléments dans l'ordre des priorités)
   Put_Line("Retrait des éléments dans l'ordre des priorités...");
   while not Est_Vide(Ma_File) loop
      Retirer(Ma_File, Elt);
      Put_Line("Élément retiré : " & Integer'Image(Elt.Valeur));
   end loop;

   -- Test : Vérification de la file vide
   Put_Line("Vérification de la gestion de la file vide...");
   if Est_Vide(Ma_File) then
      Put_Line("La file est vide après avoir retiré tous les éléments.");
   else
      Put_Line("Erreur : La file n'est pas vide.");
   end if;

   -- Test : Redimensionnement
   Put_Line("Test du redimensionnement de la file...");
   for I in 1 .. 20 loop
      Ajouter(Ma_File, (Valeur => I * 5));
   end loop;
   Put_Line("20 éléments ajoutés avec succès après redimensionnement.");

   -- Test : Retrait après redimensionnement
   Put_Line("Retrait des éléments après redimensionnement...");
   while not Est_Vide(Ma_File) loop
      Retirer(Ma_File, Elt);
      Put_Line("Élément retiré : " & Integer'Image(Elt.Valeur));
   end loop;

   -- Test : Retirer d'une file vide (exception attendue)
   Put_Line("Test du retrait d'une file vide...");
   begin
      Retirer(Ma_File, Elt); -- Cela devrait lever une exception
   exception
      when Program_Error =>
         Put_Line("Exception levée correctement pour une file vide.");
      when others =>
         Put_Line("Erreur : Mauvaise exception levée.");
   end;

   Put_Line("Tous les tests sont terminés.");
end Test_File_Priorite;