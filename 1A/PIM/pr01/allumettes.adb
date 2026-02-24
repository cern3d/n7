with Ada.Text_IO;          use Ada.Text_IO; 
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO; 
with Alea;


procedure allumettes is

    package Mon_alea is
        new Alea (1,3);
    use Mon_alea;

	mode_de_jeu : Character; --mode de jeu
	nombre_allumettes : integer := 13; --nombre total d’allumettes
	variable_commencer : Character ; --pour demander si l’humain commence ou pas
	commencer : boolean := False; --pour verifier si l’humain commence ou pas
	nb_allu_choix_hum : integer; --nombre d’allumettes choisient par l’humain
	nb_allu_choix_pc : integer; --nombre d’allumettes choisient par le joueur
	valide_hum : boolean := True; --pour verifier si le nombre d’allumettes choisi par l’humain convient
	valide_joueur : boolean := True; --pour -pour verifier si le nombre d’allumettes choisi par le joueur convient
	gagne_hum :boolean := False; --pour verifier si l’humain gagne
	gagne_joueur : boolean := False; --pour verifier si l’humain a perdu
	nombre_max :integer ; --nombre maximal d’allumettes qu’on peut choisir à chaque tour
	naif : boolean := True; --pour choisir un nombre aléatoirement entre 1 et nombre_max

begin
	-- Demander à l’humain quel type de joueur il veut affronter
	Put("Niveau de l'ordinateur (n)aïf, (d)istrait, (r)apide ou (e)xpert ? ");
	Get(mode_de_jeu);
	case mode_de_jeu is
	    when 'r' =>
	        Put("Mon niveau est rapide.");
	    when 'n' =>
	        Put("Mon niveau est naif.");
	    when 'd' =>
	        Put("Mon niveau est distrait.");
	    when others =>
	        Put("Mon niveau est expert.");
    end case;
    Put_line("");
	        

	--Demander si l’humain veut commencer
	Put_line("Est-ce que vous commencez (o/n) ?");
	Get(variable_commencer);
	if variable_commencer = 'o' or variable_commencer = 'O' then
		commencer:=True;
	end if;
	--Afficher les allumettes
	for i in 1..3 loop
		for j in 1..nombre_allumettes loop
			Put("| ");
			if j mod 5 = 1 and then j>1 then
			    Put(" ");
			end if;
		end loop;
			Put_line("");
	end loop;
	
	--Affronter l’humain selon le mode choisi
	while  nombre_allumettes>0 loop

		--Affronter l’humain selon son choix de départ
		if commencer then

			--Déterminer le nombre maximal d’allumettes qu’on peut choisir
			case nombre_allumettes is
				when 1..3=>
					nombre_max := nombre_allumettes;
				when others =>
					nombre_max := 3;
			end case;
			
			--Faire le choix d’allumette pour l’humain
			while  valide_hum loop
				--Demander à l’humain le nombre d’allumette qu’il veut prendre
				Put("Combien d'allumettes prenez-vous ? ");
				Get(nb_allu_choix_hum);
				--Vérifier si le nombre d’allumettes prisent par l’humain convient
				
                if nb_allu_choix_hum<1 then
                        Put("Arbitre : Il faut prendre au moins une allumette.");
                        Put_line("");
                elsif nb_allu_choix_hum>3 then
                        Put("Arbitre : Il est interdit de prendre plus de 3 allumettes.");
                        Put_line("");
                elsif nb_allu_choix_hum>nombre_max and nombre_max=2 then
                    Put("Arbitre : Il reste seulement 2 allumettes.");
                    Put_line("");
                elsif nb_allu_choix_hum>nombre_max and nombre_max=1 then
                    Put("Arbitre : Il reste une seule allumette.");
                    Put_line("");
                else
				    valide_hum := False;
				end if;
			end loop;
			valide_hum := True;
			nombre_allumettes := nombre_allumettes - nb_allu_choix_hum;
            
			--Vérifier si l’humain a perdu
			if nombre_allumettes=0 and not gagne_joueur then
				gagne_hum := True;
			else
			    Put_line("");
				for i in 1..3 loop
					for j in 1..nombre_allumettes loop
						Put("| ");
						if j mod 5 = 1 and then j>1 then
			                Put(" ");
			            end if;
					end loop;
					Put_line("");
				end loop;
			end if;
            --Déterminer le nombre maximal d’allumettes qu’on peut choisir
			case nombre_allumettes is
				when 1..3=>
					nombre_max := nombre_allumettes;
				when others =>
					nombre_max := 3;
			end case;
			--Faire le choix d’allumettes pour le joueur
			while valide_joueur loop

				--Jouer selon le mode choisi
				case mode_de_jeu is
					when 'n' | 'N' =>
						while naif loop
							Get_Random_Number (nb_allu_choix_pc);
							if nb_allu_choix_pc<=nombre_max then
								naif:=False;
							end if;
						end loop;
						naif := True;
					when 'd' | 'D' =>
						Get_Random_Number(nb_allu_choix_pc);
					when 'r' | 'R' =>
						nb_allu_choix_pc := nombre_max;
					when others =>
					    case nombre_allumettes is
					        when 2..4 =>
					            nb_allu_choix_pc:= nombre_allumettes - 1;
					        when 6..8 =>
					            nb_allu_choix_pc:= nombre_allumettes - 5;
					        when 10..12 =>
					            nb_allu_choix_pc:= nombre_allumettes - 9;
					        when 5 | 9 | 13 =>
					            while naif loop
							        while naif loop
								        Get_Random_Number (nb_allu_choix_pc);
								        if nb_allu_choix_pc>nombre_max then
								    	    Get_Random_Number (nb_allu_choix_pc);
								        else
								    	    naif:=False;
								        end if;
							        end loop;
							    end loop;
							    naif := True;
						    when others =>
						        nb_allu_choix_pc:= 1;
					    end case;
					end case;
				--Vérifier si le nombre d’allumettes prisent par le joueur convient
				if nb_allu_choix_pc>nombre_max then
                    Put("Arbitre : Il est interdit de prendre plus de " & Integer'Image(nombre_max) & " allumettes.");
                    Put_line("");
                elsif nb_allu_choix_pc>nombre_max and nombre_max=2 then
                    Put("Arbitre : Il reste seulement 2 allumettes.");
                    Put_line("");
                elsif nb_allu_choix_pc>nombre_max and nombre_max=1 then
                    Put("Arbitre : Il reste une seule allumette.");
                    Put_line("");
                else
				    valide_joueur := False;
				end if;
		    end loop;
			valide_joueur := True;
			if nombre_allumettes>0 then
			    nombre_allumettes := nombre_allumettes - nb_allu_choix_pc;
			    Put ("Je prends" & Integer'Image(nb_allu_choix_pc) & " allumettes.");
            end if;
			--Vérifier si le joueur a perdu
            if nombre_allumettes=0 and not gagne_hum then
				gagne_joueur := True;
			elsif nombre_allumettes>0 then
			Put_line("");
				for i in 1..3 loop
					for j in 1..nombre_allumettes loop
						Put("| ");
						if j mod 5 = 1 and then j>1 then
			                Put(" ");
			            end if;
					end loop;
					Put_line("");
				end loop;
			end if;
        else
			--Déterminer le nombre maximal d’allumettes qu’on peut choisir
			case nombre_allumettes is
				when 1..3=>
					nombre_max := nombre_allumettes;
				when others =>
					nombre_max := 3;
			end case;
			--Faire le choix d’allumettes pour le joueur
			while valide_joueur loop

				--Jouer selon le mode choisi
				case mode_de_jeu is
					when 'n' | 'N' =>
						while naif loop
							Get_Random_Number (nb_allu_choix_pc);
							if nb_allu_choix_pc<=nombre_max then
								naif:=False;
							end if;
						end loop;
						naif := True;
					when 'd' | 'D' =>
						Get_Random_Number(nb_allu_choix_pc);
					when 'r' | 'R' =>
						nb_allu_choix_pc := nombre_max;
					when others =>
						case nombre_allumettes is
					        when 2..4 =>
					            nb_allu_choix_pc:= nombre_allumettes - 1;
					        when 6..8 =>
					            nb_allu_choix_pc:= nombre_allumettes - 5;
					        when 10..12 =>
					            nb_allu_choix_pc:= nombre_allumettes - 9;
					        when 5 | 9 | 13 =>
					            while naif loop
							        while naif loop
								        Get_Random_Number (nb_allu_choix_pc);
								        if nb_allu_choix_pc>nombre_max then
								    	    Get_Random_Number (nb_allu_choix_pc);
								        else
								    	    naif:=False;
								        end if;
							        end loop;
							    end loop;
							    naif := True;
						    when others =>
						        nb_allu_choix_pc:= 1;
					    end case;
			    end case;

				--Vérifier si le nombre d’allumettes prisent par le joueur convient
				if nb_allu_choix_pc>nombre_max then
                    Put("Arbitre : Il est interdit de prendre plus de " & Integer'Image(nombre_max) & " allumettes.");
                    Put_line("");
                elsif nb_allu_choix_pc>nombre_max and nombre_max=2 then
                    Put("Arbitre : Il reste seulement 2 allumettes.");
                    Put_line("");
                elsif nb_allu_choix_pc>nombre_max and nombre_max=1 then
                    Put("Arbitre : Il reste une seule allumette.");
                    Put_line("");
                else
				    valide_joueur := False;
				end if;
			end loop;
			valide_joueur := True;
			nombre_allumettes := nombre_allumettes - nb_allu_choix_pc;
			Put ("Je prends" & Integer'Image(nb_allu_choix_pc) & " allumettes.");
			Put_line("");
			--Vérifier si le joueur a perdu
            if nombre_allumettes=0 and not gagne_hum then
				gagne_joueur := True;
			else
				for i in 1..3 loop
					for j in 1..nombre_allumettes loop
						Put("| ");
						if j mod 5 = 1 and then j>1 then
			                Put(" ");
			            end if;
					end loop;
					Put_line("");
				end loop;
			end if;
            --Déterminer le nombre maximal d’allumettes qu’on peut choisir
			case nombre_allumettes is
				when 1..3=>
					nombre_max := nombre_allumettes;
				when others =>
					nombre_max := 3;
			end case;
			--Faire le choix d’allumette pour l’humain
			while valide_hum and not gagne_joueur loop
				--Demander à l’humain le nombre d’allumette qu’il veut prendre
				Put("Combien d'allumettes prenez-vous ? ");
				Get(nb_allu_choix_hum);

				--Vérifier si le nombre d’allumettes prisent par l’humain convient
                if nb_allu_choix_hum<1 then
                    Put("Arbitre : Il faut prendre au moins une allumette.");
                    Put_line("");
                elsif nb_allu_choix_hum>3 then
                    Put("Arbitre : Il est interdit de prendre plus de 3 allumettes.");
                    Put_line("");       
                elsif nb_allu_choix_hum>nombre_max and nombre_max=2 then
                    Put("Arbitre : Il reste seulement 2 allumettes.");
                    Put_line("");
                elsif nb_allu_choix_hum>nombre_max and nombre_max=1 then
                    Put("Arbitre : Il reste une seule allumette.");
                    Put_line("");
                else
				valide_hum := False;
				end if;
			end loop;
			valide_hum := True;
			if nombre_allumettes>0 then
			    nombre_allumettes := nombre_allumettes - nb_allu_choix_hum;
            end if;
			--Vérifier si l’humain a perdu
			if nombre_allumettes = 0 and not gagne_joueur then
				gagne_hum := True;
			elsif nombre_allumettes>0 then
			Put_line("");
				for i in 1..3 loop
					for j in 1..nombre_allumettes loop
						Put("| ");
					end loop;
					Put_line("");
				end loop;
			end if;
		end if;
	end loop;
		--Annoncer le gagnant
    if  not gagne_hum then
        Put_line("");
		Put("Vous avez gagné.");
	else
	    Put_line("");
		Put("J'ai gagné.");
	end if;
end allumettes;
