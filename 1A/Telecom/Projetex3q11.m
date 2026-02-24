clear; close all; clc;

%% Paramètres
Fe = 24000;      % Fréquence d'échantillonnage
Rb = 3000;       % Débit binaire
Te = 1/Fe;
Ts = 1/Rb;
Ns = Ts/Te;      % Nb d'échantillons par symbole
N = 5;           % Ordre de l’égaliseur MMSE

%% Séquence d'apprentissage
nb_bits = 1000;
bits = randi([0 1], 1, nb_bits);
symbols = 2*bits - 1;   % BPSK : 0 -> -1 ; 1 -> +1

%% Suréchantillonnage
dirac_seq = kron(symbols, [1 zeros(1,Ns-1)]);

%% Filtre de mise en forme (porte)
h = ones(1,Ns);

%% Canal multitrajet (sans bruit)
hc = zeros(1, 2*Ns + 1);
hc(1) = 1;
hc(Ns+1) = 0.5;

%% Chaîne de transmission
xe = conv(dirac_seq, h);           % Émission
xe_canal = conv(xe, hc);           % Canal
z = conv(xe_canal, h);             % Réception
z = z(ceil(length(hc)/2):end);     % Décalage dû au canal

%% Échantillonnage en sortie
t0 = Ns;                           % Décalage initial
z_sampled = z(t0:Ns:end);          % Échantillons au rythme symbole

%% Construction des vecteurs Z(m)
M = length(z_sampled) - N;
Z = zeros(N+1, M);   % Chaque colonne est un vecteur Z(m)
a = symbols(N+1:end);  % symboles utiles alignés

for m = 1:M
    Z(:,m) = z_sampled(m+N:-1:m);
end
%% Estimation MMSE
Rzz = (Z * Z.') / M;
Rza = (Z * a.') / M;
C_mmse = Rzz \ Rza;    % Résolution de l'équation MMSE

%% Affichage
disp('Coefficients de l’égaliseur MMSE :');
disp(C_mmse);
%% (b) Réponses en fréquence
% Réponse impulsionnelle globale (canal = h * hc * h)
g = conv(h, conv(hc, h));
G = fftshift(fft(g, 1024));
f = linspace(-Fe/2, Fe/2, 1024);

% Réponse en fréquence de l’égaliseur MMSE
heg = zeros(1, length(g));        % ZFE appliqué après la chaîne
heg(1:length(C_mmse)) = C_mmse.';
H_eq = fftshift(fft(heg, 1024));

% Produit canal * égaliseur
H_total = G .* H_eq;

figure;
subplot(3,1,1); plot(f, abs(G)); title('Réponse en fréquence du canal');
subplot(3,1,2); plot(f, abs(H_eq)); title('Réponse en fréquence de l’égaliseur MMSE');
subplot(3,1,3); plot(f, abs(H_total)); title('Produit des réponses en fréquence');

%% (c) Réponses impulsionnelles échantillonnées
% Sans égalisation
g_sampled = g(1:Ns:end);
% Avec égalisation (convolution avec C_mmse)
g_eq = conv(g, C_mmse.');
g_eq_sampled = g_eq(1:Ns:end);

figure;
stem(g_sampled); title('Réponse impulsionnelle échantillonnée sans égalisation');
figure;
stem(g_eq_sampled); title('Réponse impulsionnelle échantillonnée avec égalisation MMSE');

%% (d) Constellation avant et après égalisation
% Réappliquer une info binaire avec la chaîne sans bruit
n_bits = 1000;
bits2 = randi([0 1], 1, n_bits);
symbols2 = 2*bits2 - 1;
dirac_seq2 = kron(symbols2, [1 zeros(1,Ns-1)]);
xe2 = conv(dirac_seq2, h);
xe_canal2 = conv(xe2, hc);
z2 = conv(xe_canal2, h);
z2 = z2(ceil(length(hc)/2):end);   % Décalage

% Échantillonnage au rythme symbole
z_sampled2 = z2(t0:Ns:end);

% Entrée de l’égaliseur (vecteurs Z(m))
M2 = length(z_sampled2) - N;
Z2 = zeros(N+1, M2);
for m = 1:M2
    Z2(:,m) = z_sampled2(m+N:-1:m);
end

% Sortie de l’égaliseur
y_eq = C_mmse.' * Z2;

% Constellations
figure;
plot(z_sampled2(1:M2), 'o'); axis equal;
title('Constellation avant égalisation');

figure;
plot(real(y_eq), imag(y_eq), 'x'); axis equal;
title('Constellation après égalisation MMSE');
