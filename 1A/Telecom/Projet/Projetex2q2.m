%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETUDE DE L'EGALISATION ZFE AVEC BRUIT
% Chaîne de transmission BPSK avec canal multipath et égalisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%% 1. Paramètres de simulation
Fe = 24000;       % Fréquence d'échantillonnage (Hz)
Rb = 3000;        % Débit binaire (bits/s)
Ts = 1/Rb;        % Période symbole (s)
Te = 1/Fe;        % Période d'échantillonnage (s)
Ns = round(Ts/Te); % Facteur de suréchantillonnage

% Paramètres du canal multipath
alpha0 = 1;       % Coefficient trajet direct
alpha1 = 0.5;     % Coefficient trajet réfléchi
tau0 = 0;         % Retard trajet direct (s)
tau1 = Ts;        % Retard trajet réfléchi (s)

% Filtres d'émission et réception (rectangulaires)
h = ones(1, Ns);  
hr = ones(1, Ns);

% Réponse impulsionnelle du canal
hc = zeros(1, 2*Ns);
hc(1) = alpha0;
hc(Ns+1) = alpha1;

% Paramètres pour l'égaliseur ZFE
N = 2;            % Ordre de l'égaliseur
n0 = Ns;          % Instant d'échantillonnage

%% 2. Calcul des coefficients de l'égaliseur ZFE (sans bruit)
dirac = [1 zeros(1, 10*Ns)]; % Impulsion de Dirac

% Passage à travers la chaîne
signal_emis = filter(h, 1, dirac);
signal_canal = conv(signal_emis, hc);
signal_recu = filter(hr, 1, signal_canal);

% Signal à l'entrée de l'égaliseur
z = signal_recu(n0:Ns:end);

% Calcul des coefficients ZFE
Z = toeplitz(z(1:N+1), [z(1) zeros(1,N)]);
Y0 = [1; zeros(N,1)];
C = inv(Z) * Y0;

disp('Coefficients de l''égaliseur ZFE:');
disp(C');

%% 3. Simulation avec bruit
EbN0_dB = 0:7;           % Plage de Eb/N0 à étudier
nb_bits = 10000;         % Nombre de bits par essai
nb_essais = 10;          % Nombre d'essais pour moyenne

% Initialisation des résultats
TEB_sans_eq = zeros(size(EbN0_dB));
TEB_avec_eq = zeros(size(EbN0_dB));

for i = 1:length(EbN0_dB)
    % Calcul de la puissance du bruit
    EbN0 = 10^(EbN0_dB(i)/10);
    sigma2 = 1/(2*EbN0); % Energie symbole normalisée à 1
    
    nb_erreurs_sans_eq = 0;
    nb_erreurs_avec_eq = 0;
    
    for essai = 1:nb_essais
        %% Génération des bits et modulation BPSK
        bits = randi([0 1], 1, nb_bits);
        symboles = 2*bits - 1;
        
        %% Suréchantillonnage
        symboles_sur = kron(symboles, [1 zeros(1, Ns-1)]);
        
        %% Filtrage d'émission
        signal_emis = filter(h, 1, symboles_sur);
        
        %% Canal multipath + bruit
        signal_canal = conv(signal_emis, hc);
        bruit = sqrt(sigma2) * randn(size(signal_canal));
        signal_recu = filter(hr, 1, signal_canal + bruit);
        
        %% Echantillonnage
        z = signal_recu(n0:Ns:end);
        
        %% Détection sans égalisation
        decisions_sans_eq = sign(z(3:end-2)); % On ignore les bords
        nb_erreurs_sans_eq = nb_erreurs_sans_eq + sum(decisions_sans_eq ~= symboles(N+1:end-N+1));
        
        %% Egalisation ZFE
        y = filter(C, 1, z);
        
        % Détection avec égalisation (on ignore le début et la fin)
        decisions_avec_eq = sign(y(N+1:end-N-1));
        nb_erreurs_avec_eq = nb_erreurs_avec_eq + sum(decisions_avec_eq ~= symboles(N+1:end-N));
    end
    
    %% Calcul des TEB
    TEB_sans_eq(i) = nb_erreurs_sans_eq / (nb_bits*nb_essais);
    TEB_avec_eq(i) = nb_erreurs_avec_eq / (nb_bits*nb_essais);
end

%% 4. Tracé des résultats
figure;
semilogy(EbN0_dB, TEB_sans_eq, 'b-o', 'LineWidth', 2);
hold on;
semilogy(EbN0_dB, TEB_avec_eq, 'r-s', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('TEB');
legend('Sans égalisation', 'Avec égalisation ZFE');
title('Performances avec bruit');

%% 5. Visualisation des constellations (pour Eb/N0 = 6 dB)
EbN0_dB_test = 6;
EbN0_test = 10^(EbN0_dB_test/10);
sigma2_test = 1/(2*EbN0_test);

% Génération des bits
bits_test = randi([0 1], 1, 1000);
symboles_test = 2*bits_test - 1;

% Transmission avec bruit
symboles_sur_test = kron(symboles_test, [1 zeros(1, Ns-1)]);
signal_emis_test = filter(h, 1, symboles_sur_test);
signal_canal_test = conv(signal_emis_test, hc);
bruit_test = sqrt(sigma2_test) * randn(size(signal_canal_test));
signal_recu_test = filter(hr, 1, signal_canal_test + bruit_test);
z_test = signal_recu_test(n0:Ns:end);

% Egalisation
y_test = filter(C, 1, z_test);

% Tracé des constellations
figure;
subplot(1,2,1);
plot(z_test(100:end), 'o');
title(['Constellation sans égalisation (E_b/N_0 = ' num2str(EbN0_dB_test) 'dB)']);
axis equal; grid on;

subplot(1,2,2);
plot(y_test(100:end), 'o');
title(['Constellation avec égalisation (E_b/N_0 = ' num2str(EbN0_dB_test) 'dB)']);
axis equal; grid on;

disp('=== Simulation terminée ===');