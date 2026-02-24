%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETUDE EGALISATION MMSE AVEC BRUIT - COMPARAISON TEB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%% 1. Paramètres généraux
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

% Paramètres pour l'égaliseur MMSE
N = 5;            % Ordre de l'égaliseur
n0 = Ns;          % Instant d'échantillonnage
L_train = 10000;   % Longueur séquence d'apprentissage

%% 2. Calcul des coefficients MMSE avec bruit
EbN0_train = 15;  % Eb/N0 pour l'apprentissage (dB)
EbN0_train_lin = 10^(EbN0_train/10);
sigma2_train = 1/(2*EbN0_train_lin);

% Génération de la séquence d'apprentissage
symboles_app = 2*randi([0 1], 1, L_train) - 1;

% Transmission avec bruit
symboles_sur_app = kron(symboles_app, [1 zeros(1, Ns-1)]);
signal_emis_app = filter(h, 1, symboles_sur_app);
signal_canal_app = conv(signal_emis_app, hc);
bruit_app = sqrt(sigma2_train)*randn(size(signal_canal_app));
signal_recu_app = filter(hr, 1, signal_canal_app + bruit_app);

% Echantillonnage
z_app = signal_recu_app(n0:Ns:end);

% Construction des matrices pour MMSE
Z = zeros(L_train-N, N+1);
for i = 1:L_train-N
    Z(i,:) = z_app(i:i+N);
end
A = symboles_app(N+1:L_train)';

% Calcul des coefficients MMSE
Rzz = Z'*Z/(L_train-N);
Rza = Z'*A/(L_train-N);
C_MMSE = Rzz \ Rza; % Régularisation

%% 3. Simulation avec bruit pour comparaison TEB
EbN0_dB = 0:7;    % Plage de Eb/N0 (dB)
nb_bits = 10000;      % Nombre de bits par point
nb_essais = 10;       % Nombre de répétitions

TEB_sans_eq = zeros(size(EbN0_dB));
TEB_avec_eq = zeros(size(EbN0_dB));

for i = 1:length(EbN0_dB)
    EbN0_lin = 10^(EbN0_dB(i)/10);
    sigma2 = 1/(2*EbN0_lin);
    
    erreurs_sans_eq = 0;
    erreurs_avec_eq = 0;
    
    for essai = 1:nb_essais
        %% Génération des bits
        bits = randi([0 1], 1, nb_bits);
        symboles = 2*bits - 1;
        
        %% Transmission
        signal_sur = kron(symboles, [1 zeros(1, Ns-1)]);
        signal_emis = filter(h, 1, signal_sur);
        signal_canal = conv(signal_emis, hc);
        bruit = sqrt(sigma2)*randn(size(signal_canal));
        signal_recu = filter(hr, 1, signal_canal + bruit);
        
        %% Echantillonnage
        z = signal_recu(n0:Ns:end);
        
        %% Sans égalisation
        decisions_sans = sign(z(N+1:end-N-1));
        erreurs_sans_eq = erreurs_sans_eq + sum(decisions_sans ~= symboles(N+1:end-N));
        
        %% Avec égalisation MMSE
        y = filter(C_MMSE, 1, z);
        decisions_avec = sign(y(N+1:end-N-1));
        erreurs_avec_eq = erreurs_avec_eq + sum(decisions_avec ~= symboles(N+1:end-N));
    end
    
    TEB_sans_eq(i) = erreurs_sans_eq/(nb_bits*nb_essais);
    TEB_avec_eq(i) = erreurs_avec_eq/(nb_bits*nb_essais);
    
    fprintf('Eb/N0 = %d dB - TEB sans: %.2e, avec: %.2e\n', ...
            EbN0_dB(i), TEB_sans_eq(i), TEB_avec_eq(i));
end

%% 4. Tracé des résultats
figure;
semilogy(EbN0_dB, TEB_sans_eq, 'b-o', 'LineWidth', 2);
hold on;
semilogy(EbN0_dB, TEB_avec_eq, 'r-s', 'LineWidth', 2);


grid on;
xlabel('E_b/N_0 (dB)');
ylabel('TEB');
legend('Sans égalisation', 'Avec égalisation MMSE');
title('Comparaison des TEB avec/sans égalisation MMSE');

%% 5. Affichage des coefficients
disp('Coefficients de l''égaliseur MMSE:');
disp(C_MMSE');