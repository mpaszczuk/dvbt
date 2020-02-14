function data_filtered = my_filter(data_low, draw)
Fpass = 5000000;   % Passband Frequency
Fstop = 10000000;  % Stopband Frequency
Apass = 1;         % Passband Ripple (dB)
Astop = 100;        % Stopband Attenuation (dB)
Fs    = 30000000;  % Sampling Frequency

h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);

Hd = design(h, 'equiripple', ...
    'MinOrder', 'any', ...
    'StopbandShape', 'flat');
%%%%
data_filtered = filter(Hd, data_low);

if draw ~=0
    N = length(data_filtered); n = 0:1/N:1; n = n(1:N);
    figure, plot(n,20*log(abs((fft(data_filtered)))));
    title('Widmo sygna³u, po filtraji');
end
end