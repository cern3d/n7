package body File_Priorite is

   procedure Initialiser (F : out File) is
   begin
      F.Elements := new Tableau_Element (1 .. 10); -- Allocation initiale
      F.Taille   := 0;
   end Initialiser;

   procedure Ajouter (F : in out File; Element : Element_Type) is
      Courant : Natural;
   begin
      if F.Taille = F.Elements'Length then
         declare
            Nouvelle_File : constant Tableau_Element_Access :=
              new Tableau_Element (1 .. 2 * F.Elements'Length);
         begin
            for I in 1 .. F.Taille loop
               Nouvelle_File (I) := F.Elements (I);
            end loop;
            F.Elements := Nouvelle_File;
         end;
      end if;

      F.Taille              := F.Taille + 1;
      F.Elements (F.Taille) := Element;

      -- Réajuster la structure de tas (min-heap)
      Courant := F.Taille;
      while Courant > 1 loop
         declare
            Parent : constant Natural := Courant / 2;
         begin
            if Comparer (F.Elements (Courant), F.Elements (Parent)) then
               declare
                  Temp : constant Element_Type := F.Elements (Courant);
               begin
                  F.Elements (Courant) := F.Elements (Parent);
                  F.Elements (Parent)  := Temp;
               end;
               Courant := Parent;
            else
               exit;
            end if;
         end;
      end loop;
   end Ajouter;

   procedure Retirer (F : in out File; Element : out Element_Type) is
      Courant, Enfant : Natural;
   begin
      if F.Taille = 0 then
         raise Program_Error with "File vide";
      end if;

      Element        := F.Elements (1);
      F.Elements (1) := F.Elements (F.Taille);
      F.Taille       := F.Taille - 1;

      -- Réajuster la structure de tas (min-heap)
      Courant := 1;
      while Courant * 2 <= F.Taille loop
         Enfant := Courant * 2;
         if Enfant < F.Taille and
           Comparer (F.Elements (Enfant + 1), F.Elements (Enfant))
         then
            Enfant := Enfant + 1;
         end if;

         if Comparer (F.Elements (Enfant), F.Elements (Courant)) then
            declare
               Temp : constant Element_Type := F.Elements (Courant);
            begin
               F.Elements (Courant) := F.Elements (Enfant);
               F.Elements (Enfant)  := Temp;
            end;
            Courant := Enfant;
         else
            exit;
         end if;
      end loop;
   end Retirer;

   function Est_Vide (F : File) return Boolean is
   begin
      return F.Taille = 0;
   end Est_Vide;

end File_Priorite;
