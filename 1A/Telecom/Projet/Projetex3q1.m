%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETUDE EGALISATION MMSE - PARTIE SANS BRUIT
% Implantation de la chaîne avec égalisation MMSE
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
L = 1000;         % Longueur séquence d'apprentissage

%% 2. Détermination des coefficients MMSE (a)

% Génération de la séquence d'apprentissage
symboles_app = 2*randi([0 1], 1, L) - 1; % BPSK

% Suréchantillonnage
symboles_sur_app = kron(symboles_app, [1 zeros(1, Ns-1)]);

% Transmission sans bruit
signal_emis_app = filter(h, 1, symboles_sur_app);
signal_canal_app = conv(signal_emis_app, hc);
signal_recu_app = filter(hr, 1, signal_canal_app);

% Echantillonnage
z_app = signal_recu_app(n0:Ns:end);

% Construction des matrices pour MMSE
Z = zeros(L-N, N+1);
for i = 1:L-N
    Z(i,:) = z_app(i:i+N);
end

A = symboles_app(N+1:L)';

% Calcul des coefficients MMSE
Rzz = Z'*Z/(L-N);
Rza = Z'*A/(L-N);
C_MMSE = inv(Rzz) * Rza;

disp('Coefficients de l''égaliseur MMSE:');
disp(C_MMSE');

%% 3. Analyse fréquentielle (b)

% Réponse fréquentielle du canal
Hc = fft(hc, 1024);
Hc = Hc(1:512);

% Réponse fréquentielle de l'égaliseur
Heq = fft(C_MMSE, 1024);
Heq = Heq(1:512);

% Produit des deux
H_total = Hc .* Heq;

% Tracés
f = (0:511)/512 * Fe/2;
figure('Name','Réponses en fréquence');
subplot(3,1,1);
plot(f, abs(Hc));
title('Réponse en fréquence du canal');
xlabel('Fréquence (Hz)'); ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(f, abs(Heq));
title('Réponse en fréquence de l''égaliseur MMSE');
xlabel('Fréquence (Hz)'); ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(f, abs(H_total));
title('Produit des réponses en fréquence');
xlabel('Fréquence (Hz)'); ylabel('Amplitude');
grid on;

%% 4. Réponses impulsionnelles (c)

% Réponse globale sans égalisation
h_sans_eq = conv(h, hc);
h_sans_eq = conv(h_sans_eq, hr);

% Réponse globale avec égalisation
h_avec_eq = conv(h_sans_eq, C_MMSE');

% Tracés
figure('Name','Réponses impulsionnelles');
subplot(2,1,1);
stem(h_sans_eq(1:3*Ns));
title('Réponse impulsionnelle sans égalisation');
xlabel('Échantillons'); ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(h_avec_eq(1:3*Ns));
title('Réponse impulsionnelle avec égalisation MMSE');
xlabel('Échantillons'); ylabel('Amplitude');
grid on;

%% 5. Comparaison des constellations (d)

% Génération de bits aléatoires
bits = randi([0 1], 1, 1000);
symboles = 2*bits - 1;

% Suréchantillonnage
symboles_sur = kron(symboles, [1 zeros(1, Ns-1)]);

% Transmission sans bruit
signal_emis = filter(h, 1, symboles_sur);
signal_canal = conv(signal_emis, hc);
signal_recu = filter(hr, 1, signal_canal);

% Echantillonnage
z = signal_recu(n0:Ns:end);

% Egalisation MMSE
y = filter(C_MMSE, 1, z);

% Tracé des constellations
figure('Name','Constellations sans bruit');
subplot(1,2,1);
plot(z(N+1:end-N-1), 'o');
title('Constellation sans égalisation');
axis equal; grid on;

subplot(1,2,2);
plot(y(N+1:end-N-1), 'o');
title('Constellation avec égalisation MMSE');
axis equal; grid on;

disp('=== Analyse MMSE sans bruit terminée ===');