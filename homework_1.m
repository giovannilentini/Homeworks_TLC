close all
clear
clc

%questo è il segnale ecg preso dal file
load('./FilteredData_Subject_8_task_CW.mat');
signal = ECG(30000:32500, 1);

%Primo Esercizio:

%in questa prima sezione calcolo tutti i valori che andranno inseriti nel
%grafico della figura
energy = sum (abs(signal).^2);
mean_value = mean(signal);
var_value = var(signal);

%nella seconda sezione mi occupo semplicemente di graficare il tutto
figure;
subplot(2,1,1);
%figure('Name', 'Esercizio 1');
plot(signal);

yline(mean_value,'-.b','Mean Value','LineWidth',3,'Color', 'blue');
xlim([0 2500]);
ylim([-1, 1]);

xlabel('Time');
ylabel('Amplitude');
title('Signal');
grid on;

annotation("textbox", [.15 .6 .3 .3], "String", strcat("Energy: ", num2str(energy)), 'FitBoxToText','on', "BackgroundColor",[1 1 1]);
annotation("textbox", [.32 .6 .3 .3], "String", strcat("Variance: ", num2str(var_value)), 'FitBoxToText','on', "BackgroundColor",[1 1 1]);


%Secondo Esercizio:

%nella prima sezione del calcolo quanti punti del segnale 
%vanno messi a 0
p = 0.15; % 15%
signal_length = numel(signal);
n_to_remove = round(p * signal_length); % 15% della lunghezza del segnale

%creo il segnale degradato ponendo a gli ultimo n*p punti (scelti in
% maniera arbitraria) 
degraded_signal = signal;
degraded_signal(signal_length-n_to_remove:signal_length) = 0;

%procedo calcolandomi il valore medio, l'energia e la varianza del segnale
%ora ottenuto
degraded_energy = sum (abs(degraded_signal).^2);
degraded_mean = mean(degraded_signal);
degraded_var = var(degraded_signal);

%come ultimo passaggio grafico tutto
subplot(2,1,2);
%figure('Name', 'Esercizio 2');
plot(degraded_signal);

yline(degraded_mean,'-.b','Mean Value','LineWidth',3,'Color', 'blue');
annotation("textbox", [.6 .6 .3 .3], "String", strcat("Energy: ", num2str(degraded_energy)), 'FitBoxToText','on', "BackgroundColor",[1 1 1]);
xlim([0 2500]);
ylim([-1, 1]);

xlabel('Time');
ylabel('Amplitude');
title('Degraded Signal');
grid on;



%Esercizio 3:

%creazione del filtro, cioè una rect che vale 1 tra 250 e 1050 e 0 dalle
%altre perti
figure;

signal_length = 0:2500;
filter_input = rect(250, 1050, signal_length); % funzione creata da noi (in fondo)
                                         % crea una rect con inizio e fine
                                         % specificata


%qui grafico il filtro


%applico il filtro al segnale
%l'uitlizzo di same limita la lunghezza del segnale filtrato a quella del
%segnale di partenza
filtered_signal = conv(degraded_signal, filter_input, 'full');

subplot(2,1,1);
plot(filter_input);

xlim([0 length(filtered_signal)]);
ylim([-0.7, 1.5]);

xlabel('Time');
ylabel('Amplitude');
title('Filter Input');
grid on;
%ora posso graficare il segnale filtrato
subplot(2,1,2);
plot(filtered_signal);

xlim([0 length(filtered_signal)]);
ylim([-10, 10]);

xlabel('Time');
ylabel('Amplitude');
title('Filtered Signal');
grid on;


%ESERCIZIO 4
peak  = max(signal); %trovo il valore massimo del segnale
                      %dato che i picchi del segnale non sono tutti uguali
                      %a questo valore, farò un approssimazione 
                      %la differenza (in modulo) tra picco e segnale(i)
                      %deve essere minore di una certa soglia 

distanza_picchi = -1; % inizializzo a -1 
start = -1; %inizializzo a -1

x_firstPeak = 0; %inizializzo a 0 la x del primo picco
i = 1;
siglen = length(signal_length);
while i<siglen % loop lungo tutto il segnale
    if start == -1 && abs(peak-signal(i))<0.05 %se start ancora non è stato cambiato e il punto è catalogabile come picco 
        disp(i);
        disp(signal(i));
        start = i;
        x_firstPeak = i; % aggiorno la x del primo picco 
    elseif start ~= -1 && abs(peak-signal(i))<0.05 && (i-x_firstPeak)>=15 % se start è stata cambiata, il punto è un picco e la distanza fra 
                                                                           % fra la x del primo picco e la x del secondo è maggiore di 15 (altrimenti ti prende)
                                                                           % un valore di x subito dopo il primo picco 

        disp(i);
        disp(signal(i));
        distanza_picchi = i-start;
        break
    end 
    i=i+1;
end

if distanza_picchi == -1 % distanza_picchi non è stata cambiata perchè non è stato trovato un picco 
    disp("Il segnale ha soltanto un picco");
else 
    disp(strcat("Il segnale ha un picco circa ogni ", num2str(distanza_picchi)));
end
figure;
plot(signal);
xlim([0 siglen]);
title("Distanza tra picchi");
line([x_firstPeak, i], [peak, peak], "LineWidth", 5);
xlabel("Time");
ylabel("Amplitude");
grid on;

%FINE ESERCIZIO 4


function y = rect(start, last, x)
    y = zeros(numel(x), 1);
    y(x>=start & x<=last) = 1;
end






