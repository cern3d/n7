generic
   type Element_Type is private;
   with function Comparer (Left, Right : Element_Type) return Boolean;
package File_Priorite is
   type File is private;

   procedure Initialiser (F : out File);
   procedure Ajouter (F : in out File; Element : Element_Type);
   procedure Retirer (F : in out File; Element : out Element_Type);
   function Est_Vide (F : File) return Boolean;

private
   type Tableau_Element is array (Natural range <>) of Element_Type;
   type Tableau_Element_Access is access Tableau_Element; -- Type d'accès nommé
   type File is record
      Elements : Tableau_Element_Access;
      Taille   : Natural := 0;
   end record;
end File_Priorite;
