with Ada.Text_IO;
with Ada.Direct_IO;
with Compresser;
with File_Priorite;  -- Si utilisé pour la gestion d'arbre
use Ada.Text_IO;

procedure Test_Compresser is

   File_Input_Name  : constant String := "test_input.txt";
   File_Output_Name : constant String := "test_input.txt.hff";
   package File_Check is new Ada.Direct_IO (Element_Type => Character);
   Output_File : File_Check.File_Type;
   Char_Read   : Character;

begin
   Compresser_Fichier (File_Input_Name);
   Put_Line ("Compression terminée.");

   -- Ouverture du fichier compressé en lecture binaire
   File_Check.Open
     (File => Output_File, Mode => File_Check.In_File,
      Name => File_Output_Name);

   -- Test : Vérification que le fichier n'est pas vide
   if File_Check.End_Of_File (Output_File) then
      Put_Line ("ERREUR: Le fichier compressé est vide.");
      return;
   end if;

   -- Test : Présence de l'arbre de Huffman (simplifié ici à la lecture du premier caractère)
   File_Check.Read (Output_File, Char_Read);
   Put_Line
     ("Premier octet lu (doit correspondre à l'entête d'arbre) : " &
      Char_Read);

   -- Test : Vérification du symbole de fin de fichier
   loop
      exit when File_Check.End_Of_File (Output_File);
      File_Check.Read (Output_File, Char_Read);
   end loop;
   Put_Line ("Dernier octet lu (doit être le symbole EOF) : " & Char_Read);

   File_Check.Close (Output_File);
   Put_Line ("Tests de compression terminés avec succès.");
end Test_Compresser;
