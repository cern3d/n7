with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

-- Auteur: 
-- Gérer un stock de matériel informatique.
--
package body Stocks_Materiel is

    procedure Creer (Stock : out T_Stock) is
    begin
        Stock.Liste_Elements is new Liste_Elements;
        Stock.Taille := 0;
    end Creer;


    function Nb_Materiels (Stock: in T_Stock) return Integer is
    begin
        Put(Image'Integer(Stock.Taille));
    end;


    procedure Enregistrer (
            Stock        : in out T_Stock;
            Numero_Serie : in     Integer;
            Nature       : in     T_Nature;
            Annee_Achat  : in     Integer
        ) is
    begin
        
        Stock.Liste_Elements(Stock.Taille + 1).Elements := Numero_Serie;
        Stock.Liste_Elements(Stock.Taille + 1).Elements.Nature := Nature;
        Stock.Liste_Elements(Stock.Taille + 1).Elements.Annee_Achat := Annee_Achat;
        Stock.Taille := Stock.Taille + 1    ;
    end;


end Stocks_Materiel;
