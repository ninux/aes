% clean up
clear all;
close all;

nm  = 220;      % Anzahl Module
pm  = 260;      % Modulleistung
nw  = 0.975;    % Wirkungsgrad Wechselrichter
pg0 = nm * pm;  % Modulleistung nominal
g0  = 1E3;      % Bestrahlungsstärke (STC-Wert) [W/m^2]

g   = [37 65 112 152 185 198 208 182 129 77 42 29];                   % Bestrahlungsstärke [W/m^2]
r30 = [1.34 1.28 1.16 1.06 1.01 0.98 1 1.05 1.13 1.21 1.26 1.34];     % Globalstahlungsfaktoren
kg  = [0.96 0.73 0.81 0.83 0.84 0.84 0.84 0.84 0.84 0.82 0.75 0.66];  % Generatorkorrekturfaktor
kt  = [1.05 1.03 1.01 0.98 0.95 0.93 0.91 0.92 0.95 0.99 1.04 1.05];  % Temperaturkorrekturfaktor
ndi = [31 28 31 30 31 30 31 31 30 31 30 31];                          % Anzahl Tage im Monat

gg  = g .* r30;                     % Bestrahlungsstärke in Modulebene [W/m^2]
gi  = gg;                           % 
hi  = 24 * gi;                      % Tägliche Strahlungssumme [(W*h)/(m^2*d)]
hgi = r30 .* hi;                    % 
yfi = nw .* kg .* kt .* (hgi./g0);  % Yield (spezifischer Ertrag)
Ei  = pg0 .* ndi .* yfi;            % Monatserträge
Ea  = sum(Ei);                      % Jahresertrag

p_wr  = 4248;  % Preis Wechselrichter [Fr.]
p_pv  = 224;   % Preis PV-Modul [Fr.];
p_ak  = 2165;  % Preis Anschlusskasten [Fr.]

p_tot = (4*p_wr) + (nm*p_pv) + p_ak;  % Preis TOTAL [Fr.]

z     = 0.05; % Zins 5%
n_wr  = 10;   % Amortisationszeit Wechselrichter 10 Jahre
n_r   = 25;   % Amortisationszeit ohne Wechselrichter 25 Jahre 
a_wr  = z / ( 1 - (1+z)^(-n_wr) );  % Annulitätsfaktor Wechselrichter
a_r   = z / ( 1 - (1+z)^(-n_r) );   % Annulitätsfaktor ohne Wechselrichter

ka_wr = (4*p_wr) * a_wr;            % Jährliche Kapitalkosten Wechselrichter
ka_r  = ((nm*p_pv) + p_ak) * a_r;   % Jährliche Kapitalkosten ohne Wechselrichter
ka_t  = ka_wr + ka_r;               % Jährliche Kapitalkosten
p_u   = 1000;                       % Kosten des Jahresunterhalts

printf("Jahresertrag: \t\t\t%i MWh\n", Ea/1E6);
printf("Preis der Anlage: \t\t%i Fr.\n", p_tot);
printf("Jährliche Kapitalkosten: \t%i Fr.\n", ka_t);
printf("Gestehungskosten: \t\t%i Fr./kWh\n", (ka_t+p_u)/(Ea/1E3));
