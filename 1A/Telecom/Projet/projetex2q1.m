%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETUDE DE L'EGALISATION ZFE SANS BRUIT
% Projet Télécommunications - Chaîne de transmission avec égalisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%% Paramètres généraux
Fe = 24000;       % Fréquence d'échantillonnage
Te = 1/Fe;        % Période d'échantillonnage
Rb = 3000;        % Débit binaire
Ts = 1/Rb;        % Période symbole
Ns = Ts/Te;       % Facteur de suréchantillonnage

% Paramètres du canal multipath
alpha0 = 1;       % Coefficient trajet direct
alpha1 = 0.5;     % Coefficient trajet réfléchi
tau0 = 0;         % Retard trajet direct
tau1 = Ts;        % Retard trajet réfléchi

% Réponses impulsionnelles des filtres
h = ones(1, Ns);  % Filtre d'émission (rectangulaire)
hr = ones(1, Ns); % Filtre de réception (rectangulaire)
hc = zeros(1, 2*Ns); % Réponse impulsionnelle du canal
hc(1) = alpha0;
hc(Ns+1) = alpha1;

%% i. Détermination des coefficients de l'égaliseur ZFE

% Génération d'un Dirac
dirac = [1 zeros(1, 10*Ns)];

% Passage à travers la chaîne de transmission
signal_emis = filter(h, 1, dirac);
signal_canal = conv(signal_emis, hc);
signal_recu = filter(hr, 1, signal_canal);

% Echantillonnage à n0 = Ts
n0 = Ns;
z = signal_recu(n0:Ns:end); % Signal à l'entrée de l'égaliseur

% Construction de la matrice Z pour ZFE (ordre 2)
N = 2; % Ordre de l'égaliseur
Z = toeplitz(z(1:N+1), [z(1) zeros(1,N)]);
Y0 = [1; zeros(N,1)];

% Calcul des coefficients de l'égaliseur
C = inv(Z) * Y0;
disp('Coefficients de l''égaliseur ZFE:');
disp(C');

%% ii. Tracés des réponses en fréquence

% Réponse fréquentielle du canal
Hc = fft(hc, 1024);
Hc = Hc(1:512); % On garde la moitié

% Réponse fréquentielle de l'égaliseur
Heq = fft(C, 1024);
Heq = Heq(1:512);

% Produit des deux
H_total = Hc .* Heq;

% Tracés
f = (0:511)/512 * Fe/2;
figure;
subplot(3,1,1);
plot(f, abs(Hc));
title('Réponse en fréquence du canal');
xlabel('Fréquence (Hz)'); ylabel('Amplitude');

subplot(3,1,2);
plot(f, abs(Heq));
title('Réponse en fréquence de l''égaliseur ZFE');
xlabel('Fréquence (Hz)'); ylabel('Amplitude');

subplot(3,1,3);
plot(f, abs(H_total));
title('Produit des réponses en fréquence');
xlabel('Fréquence (Hz)'); ylabel('Amplitude');

%% iii. Réponses impulsionnelles

% Réponse globale sans égalisation
h_sans_eq = conv(h, hc);
h_sans_eq = conv(h_sans_eq, hr);

% Réponse globale avec égalisation
h_avec_eq = conv(h_sans_eq, C.');

% Tracés
figure;
subplot(2,1,1);
stem(h_sans_eq(1:3*Ns));
title('Réponse impulsionnelle sans égalisation');
xlabel('Échantillons'); ylabel('Amplitude');

subplot(2,1,2);
stem(h_avec_eq(1:3*Ns));
title('Réponse impulsionnelle avec égalisation ZFE');
xlabel('Échantillons'); ylabel('Amplitude');

%% iv. Comparaison des constellations

% Génération de bits aléatoires
bits = randi([0 1], 1, 1000);
symboles = 2*bits - 1;

% Suréchantillonnage
symboles_sur = kron(symboles, [1 zeros(1, Ns-1)]);

% Transmission sans égalisation
signal_emis = filter(h, 1, symboles_sur);
signal_canal = conv(signal_emis, hc);
signal_recu = filter(hr, 1, signal_canal);
z = signal_recu(n0:Ns:end);

% Avec égalisation
y = filter(C, 1, z);

% Tracés des constellations
figure;
subplot(1,2,1);
plot(z(100:end), 'o'); % On ignore les premiers échantillons
title('Constellation sans égalisation');
axis equal; grid on;

subplot(1,2,2);
plot(y(100:end), 'o');
title('Constellation avec égalisation ZFE');
axis equal; grid on;

%% Affichage des résultats
disp(' ');
disp('=== Résultats obtenus ===');
disp(['Coefficients de l''égaliseur ZFE : ' num2str(C')]);
disp('Observation des figures pour :');
disp('1. Les réponses en fréquences');
disp('2. Les réponses impulsionnelles');
disp('3. Les constellations avant/après égalisation');