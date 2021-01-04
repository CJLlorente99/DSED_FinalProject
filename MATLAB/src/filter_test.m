%% Script que importa los datos procesados por el filtro implementado en la 
% FPGA y los compara con los filtrados idealmente

L = length(data) - 2;

% Importar ficheros .dat

data_out_FPGA_HP = load('../../output_data/sample_out_haha_HP.dat')./127;
data_out_FPGA_LP = load('../../output_data/sample_out_haha_LP.dat')./127;

% Tratar datos originales

[data,fs] = audioread('../data/haha.wav');

filterHP = filter([-0.0078 -0.2031 0.6015 -0.2031 -0.0078], [1 0 0 0 0], data);
filterLP = filter([0.039 0.2422 0.4453 0.2422 0.039], [1 0 0 0 0], data);

% Plot filters
% WARNING, AUDIO/DSP... TOOLBOX MUST BE INSTALLED

[h_HP, w_HP] = freqz([-0.0078 -0.2031 0.6015 -0.2031 -0.0078], [1 0 0 0 0], 5000, fs);
[h_LP, w_LP] = freqz([0.039 0.2422 0.4453 0.2422 0.039], [1 0 0 0 0], 5000, fs);

figure (1)
subplot 211
plot(w_HP, 20*log10(abs(h_HP)))
title('HP transfer function')
xlabel('Frequency (Hz)')
ylabel('(dB)')

subplot 212
plot(w_LP, 20*log10(abs(h_LP)))
title('LP transfer function')
xlabel('Frequency (Hz)')
ylabel('(dB)')

% Plotear gráficos de error

error_LP = abs(filterLP(2:end)-data_out_FPGA_HP);
error_HP = abs(filterHP(2:end)-data_out_FPGA_LP);

figure (2)
subplot 211
plot(1/fs*(0:L),error_LP)
title("error LP")
xlabel('Time (s)')
ylabel('(V)')

subplot 212
plot(1/fs*(0:L), error_HP)
title("error HP")
xlabel('Time (s)')
ylabel('(V)')

% Some data

avg_error_LP = sum(error_LP)/length(error_LP)
avg_error_HP = sum(error_HP)/length(error_HP)
avg_error_LP_2 = sum(error_LP.^2)/length(error_LP)
avg_error_HP_2 = sum(error_HP.^2)/length(error_HP)

%% FFT comparison

% Original fft

f = fs*(0:L/2)/L; % frequency array for right sided spectrum

fftHaha = fft(data(2:end)); % compute fft
P2 = abs(fftHaha/L); % two sided fft
P1 = P2(1:L/2 + 1); % computations to obtain real one sided spectrum
P1(2:end-1) = 2*P1(2:end-1);

% figure (4)
% plot(f, P1)
% title("Single-sided FFT of original data")

fft_Haha_LP = fft(filterLP(2:end)); % compute fft
P2_Haha_LP = abs(fft_Haha_LP/L); % two sided fft
P1_Haha_LP = P2_Haha_LP(1:L/2 + 1); % computations to obtain real one sided spectrum
P1_Haha_LP(2:end-1) = 2*P1_Haha_LP(2:end-1);

figure (5)
subplot 211
plot(f, 20*log10(abs(P1)))
title("Single-sided FFT of original data")
xlabel('Frequency (Hz)')
ylabel('(dB)')

subplot 212
plot(f, 20*log10(abs(P1_Haha_LP)))
title("Single-sided FFT of original data LP")
xlabel('Frequency (Hz)')
ylabel('(dB)')

fft_Haha_HP = fft(filterHP(2:end)); % compute fft
P2_Haha_HP = abs(fft_Haha_HP/L); % two sided fft
P1_Haha_HP = P2_Haha_HP(1:L/2 + 1); % computations to obtain real one sided spectrum
P1_Haha_HP(2:end-1) = 2*P1_Haha_HP(2:end-1);

figure (6)
subplot 211
plot(f, 20*log10(abs(P1)))
title("Single-sided FFT of original data")
xlabel('Frequency (Hz)')
ylabel('(dB)')

subplot 212
plot(f, 20*log10(abs(P1_Haha_HP)))
title("Single-sided FFT of original data HP")
xlabel('Frequency (Hz)')
ylabel('(dB)')

% FPGA filtered fft

fft_FPGA_LP = fft(data_out_FPGA_LP); % compute fft
P2_FPGA_LP = abs(fft_FPGA_LP/L); % two sided fft
P1_FPGA_LP = P2_FPGA_LP(1:L/2 + 1); % computations to obtain real one sided spectrum
P1_FPGA_LP(2:end-1) = 2*P1_FPGA_LP(2:end-1);

figure (7)
subplot 211
plot(f, 20*log10(abs(P1)))
title("Single-sided FFT of original data")
xlabel('Frequency (Hz)')
ylabel('(dB)')

subplot 212
plot(f, 20*log10(abs(P1_FPGA_LP)))
title("Single-sided FFT of FPGA LP data")
xlabel('Frequency (Hz)')
ylabel('(dB)')

fft_FPGA_HP = fft(data_out_FPGA_HP); % compute fft
P2_FPGA_HP = abs(fft_FPGA_HP/L); % two sided fft
P1_FPGA_HP = P2_FPGA_HP(1:L/2 + 1); % computations to obtain real one sided spectrum
P1_FPGA_HP(2:end-1) = 2*P1_FPGA_HP(2:end-1);

figure (8)
subplot 211
plot(f, 20*log10(abs(P1)))
title("Single-sided FFT of original data")
xlabel('Frequency (Hz)')
ylabel('(dB)')

subplot 212
plot(f, 20*log10(abs(P1_FPGA_HP)))
title("Single-sided FFT of FPGA HP data")
xlabel('Frequency (Hz)')
ylabel('(dB)')

% Calculate errors with fft

error_freq_LP = abs(P1_FPGA_LP-P1_Haha_LP);
error_freq_HP = abs(P1_FPGA_HP-P1_Haha_HP);

figure (9)
subplot 211
plot(f,error_freq_LP)
title('error LP')
xlabel('Frequency (Hz)')
ylabel('(V)')

subplot 212
plot(f, error_freq_HP)
title('error HP')
xlabel('Frequency (Hz)')
ylabel('(V)')
