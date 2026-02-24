%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TP2 de Traitement Numérique du Signal
%                   SCIENCES DU NUMERIQUE 1A
%                       Février 2025 
%                        Prénom Nom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETRES GENERAUX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fe = 10000;             % Fréquence d'échantillonnage en Hz
Te = 1/Fe;              % Période d'échantillonnage en secondes
N = 100;                % Nombre d'échantillons
f1 = 1000;              % Fréquence du premier cosinus en Hz
f2 = 3000;              % Fréquence du deuxième cosinus en Hz
A = 1;                  % Amplitude des cosinus

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATION DU SIGNAL A FILTRER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Définition de l'échelle temporelle
temps = (0:N-1)*Te;

% Génération des deux cosinus
cos1 = A*cos(2*pi*f1*temps);
cos2 = A*cos(2*pi*f2*temps);

% Somme des deux cosinus
signal = cos1 + cos2;

% Tracé du signal dans le domaine temporel
figure
plot(temps, signal)
grid
xlabel('Temps (s)')
ylabel('Amplitude')
title('Signal somme de deux cosinus (1000 Hz et 3000 Hz)')

% Tracé de la représentation fréquentielle (TFD)
X = fft(signal);
echelle_frequentielle = (0:N-1)*(Fe/N);
figure
plot(echelle_frequentielle, abs(X))
grid
xlabel('Fréquence (Hz)')
ylabel('|TFD|')
title('Représentation fréquentielle du signal')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SYNTHESE DU FILTRE PASSE-BAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Définition des ordres du filtre
ordre1 = 11;            % Ordre du premier filtre
ordre2 = 61;            % Ordre du deuxième filtre

% Fréquence de coupure du filtre passe-bas (en Hz)
fc = 1500;              % Fréquence de coupure choisie pour conserver f1 = 1000 Hz

% Réponse impulsionnelle du filtre passe-bas (fenêtre rectangulaire)
h1 = 2*fc/Fe * sinc(2*fc/Fe * (-(ordre1-1)/2:(ordre1-1)/2));  % Filtre d'ordre 11
h2 = 2*fc/Fe * sinc(2*fc/Fe * (-(ordre2-1)/2:(ordre2-1)/2));  % Filtre d'ordre 61

% Tracé des réponses impulsionnelles superposées
figure
stem((- (ordre1-1)/2:(ordre1-1)/2), h1, 'b', 'LineWidth', 1.5)
hold on
stem((- (ordre2-1)/2:(ordre2-1)/2), h2, 'r', 'LineWidth', 1.5)
grid
title('Réponses impulsionnelles des filtres passe-bas')
xlabel('Échantillons')
ylabel('Amplitude')
legend('Ordre 11', 'Ordre 61')

% Calcul des réponses en fréquence des filtres
H1 = fft(h1, 1024);     % TFD du filtre d'ordre 11
H2 = fft(h2, 1024);     % TFD du filtre d'ordre 61
echelle_frequentielle_filtre = (0:1023)*(Fe/1024);

% Tracé des réponses en fréquence superposées
figure
plot(echelle_frequentielle_filtre, abs(H1), 'b', 'LineWidth', 1.5)
hold on
plot(echelle_frequentielle_filtre, abs(H2), 'r', 'LineWidth', 1.5)
grid
xlabel('Fréquence (Hz)')
ylabel('|H(f)|')
title('Réponses en fréquence des filtres passe-bas')
legend('Ordre 11', 'Ordre 61')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REALISATION DU FILTRAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtrage du signal avec les deux filtres
signal_filtre1 = filter(h1, 1, signal);  % Filtrage avec le filtre d'ordre 11
signal_filtre2 = filter(h2, 1, signal);  % Filtrage avec le filtre d'ordre 61

% Tracé des signaux filtrés
figure
plot(temps, signal_filtre1, 'b', 'LineWidth', 1.5)
hold on
plot(temps, signal_filtre2, 'r', 'LineWidth', 1.5)
grid
title('Signaux filtrés avec les filtres passe-bas')
xlabel('Temps (s)')
ylabel('Amplitude')
legend('Ordre 11', 'Ordre 61')

% Tracé des représentations fréquentielles des signaux filtrés
X_filtre1 = fft(signal_filtre1);
X_filtre2 = fft(signal_filtre2);

figure
plot(echelle_frequentielle, abs(X_filtre1), 'b', 'LineWidth', 1.5)
hold on
plot(echelle_frequentielle, abs(X_filtre2), 'r', 'LineWidth', 1.5)
grid
xlabel('Fréquence (Hz)')
ylabel('|TFD|')
title('Représentation fréquentielle des signaux filtrés')
legend('Filtre ordre 11', 'Filtre ordre 61')

