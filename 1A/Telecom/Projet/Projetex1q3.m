% Paramètres
Fe = 24000;         % Fréquence d'échantillonnage (Hz)
Rb = 3000;          % Débit binaire (bps)
Te = 1/Fe;          % Période d'échantillonnage
Ts = 1/Rb;          % Durée d’un symbole
Ns = Ts / Te;       % Facteur de suréchantillonnage
Ns = round(Ns);     % S'assurer que c'est un entier

% Séquence binaire test
bits = [0 1 1 0 0 1];

% Mapping BPSK : 0 -> -1, 1 -> +1
symbols = 2*bits - 1;

% Génération du signal émis : impulsions rectangulaires
diracs = kron(symbols, [1 zeros(1, Ns-1)]);
h_em = ones(1, Ns);             % Filtre d'émission rectangulaire
x_emis = conv(diracs, h_em);    % Signal en sortie de l'émetteur

% Canal multipath : h_c(t) = α0 δ(t) + α1 δ(t - Ts)
alpha0 = 1;
alpha1 = 0.5;
hc = zeros(1, Ns*2);     % Longueur 2*Ts
hc(1) = alpha0;
hc(Ns+1) = alpha1;

x_canal = conv(x_emis, hc);   % Signal après le canal

% Filtre de réception : même que émission (rectangulaire)
h_rec = ones(1, Ns);
x_recu = conv(x_canal, h_rec);  % Signal reçu après filtrage

% Troncature du signal pour aligner avec les symboles
t_total = length(x_recu);
temps = (0:t_total-1) * Te;

% Affichage du signal reçu pour séquence 011001
figure;
plot(temps, x_recu, 'LineWidth', 1.5);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal en sortie du filtre de réception hr(t)');
grid on;

%% (a) Diagramme de l’œil
% Découpage du signal pour chaque symbole
% On ignore les transitoires : centrage
x_eye = buffer(x_recu(Ns:end-Ns), Ns);
figure;
plot(x_eye, 'b');
title('Diagramme de l’œil');
xlabel('Échantillons dans un symbole');
ylabel('Amplitude');
grid on;

%% (b) Constellation
% Échantillonnage au bon instant : t0 + mTs → ici à m = Ns (1 symbole)
% Décalage total : filtre émission + canal (1 + 1 symbole) + filtre réception (1 symbole)
% Total décalage = 3*Ns
t0 = 3*Ns;
x_ech = x_recu(t0 : Ns : t0 + (length(symbols)-1)*Ns);


%% (c) TEB (sans bruit)
% Détection seuil 0
symbols_detected = double(x_ech > 0);
bits_detected = symbols_detected;

% Calcul TEB
TEB = mean(bits_detected ~= bits);
fprintf("TEB mesuré (sans bruit) = %.5f\n", TEB);
