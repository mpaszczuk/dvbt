close all;
clear all;
% clc;

draw = 1;

load('dvbt.mat')
data = data(1:100000);
N = length(data); n = 0:1/N:1; n = n(1:N);

%Rysowanie widma odebranych danych
plot(n,20*log(abs((fft(data)))));
title('Widmo odebranych danych');
%Konwersja w dó³
fo = 8e6/fs;
k=1:length(data);
c = exp(  -j*(2*pi*fo*k ) )';
data_low = data .*c;

figure; plot(n,20*log(abs((fft(data_low)))));
title('Widmo po zmianie czêstotliwoœci');

data_filtered = my_filter(data_low, draw);

B = 8e6; fs_dvb = 8/7*B;
[P,Q] = rat(fs_dvb/(fs));

data_low_resam = resample(data_filtered,P,Q);
N = length(data_low_resam); n = 0:1/N:1; n = n(1:N);
figure, plot(n,20*log(abs((fft(data_low_resam)))));
title('Widmo sygna³u po zmianie czêstotliwoœci próbkowania');

sym_per_block =  8192; 
guard_interval =  1/8;
korelacja = [];
for ind = 1:(sym_per_block + sym_per_block*guard_interval)
    if (ind + sym_per_block+guard_interval*sym_per_block)> length(data_low_resam)
        break;
    end
    first_guard = data_low_resam(int32(ind):int32(ind +guard_interval*sym_per_block));
    second_guard = data_low_resam(int32(ind + sym_per_block):int32(ind + sym_per_block+guard_interval*sym_per_block));
    korr = corr(first_guard, second_guard);
    korelacja = [korelacja korr];
end
figure, plot(abs(korelacja));
title("Poszukiwanie odstêpu ochronnego");

[pks,locs] = findpeaks(abs(korelacja),'MinPeakProminence',0.4,'MinPeakDistance',7000);
figure, stem(locs,pks);
data_no_guard = []

symbol_end = locs(1)+1024+8192:8192+1024:length(data_low_resam)
for k = symbol_end
        data_no_guard = [data_no_guard data_low_resam(k-8192:k-1)];
end

data_af_fft= [];
for k = 1:length(data_no_guard(1,:))
    data_af_fft = [data_af_fft fft(data_no_guard(:,k))];
end
% data_af_fft = ifft(data_no_guard);
% data_af_fft_sum = data_af_fft';
% data_af_fft_sum = data_af_fft(:);
figure, plot(data_af_fft(:,1),'.');
title('Symbol po FFT');

symbols = [];
for k = 1:length(data_af_fft(1,:))
    symbols = [symbols fftshift(data_af_fft(:,k))];
end
% symbols = fftshift(data_af_fft);
symbols = symbols(689:end,:);
symbols = symbols(1:6817,:);
one_symbol = symbols(:,1);
figure, plot(symbols(:,1),'.');
title('Symbol po usuniêciu zer');

ind = 1;
 l = 3;
for ind = 1:length(symbols(1,:))
    normalize_sig(symbols(:,ind),l);
    l = l +1;
end

