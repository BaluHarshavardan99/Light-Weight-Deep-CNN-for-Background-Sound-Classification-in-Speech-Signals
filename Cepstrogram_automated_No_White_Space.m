clear, clc, close all
%% get a section of the sound file
D = 'C:\Users\balu1\Desktop\NOIZEUS\train\-15dB'; %% PATH FOR INPUT AUDIO FILES
S = dir(fullfile(D,'*.wav'));
N = numel(S);
y = cell(1,N);
Fs = cell(1,N);
for k = 1:N
    F = fullfile(D,S(k).name);
     [x, fs] = audioread(F);
     %   filename=audio_files(k).name
%   [x, fs] = audioread('track.wav');	% load an audio file
x = x(:, 1);                     	% get the first channel
N = length(x);                   	% signal length
to = (0:N-1)/fs;                    % time vector
x = detrend(x);                             
%% plot the signal spectrum
% spectral analysis
winlen = N;
win = blackman(winlen, 'periodic');
nfft = round(2*winlen);
[PS, f] = periodogram(x, win, nfft, fs, 'power');
X = 10*log10(PS);
%% plot the signal spectrogram
% time-frequency analysis
winlen = 1024;
win = blackman(winlen, 'periodic');
hop = round(winlen/4);
nfft = round(2*winlen);
[~, F, T, STPS] = spectrogram(x, win, winlen-hop, nfft, fs, 'power');
STPS = 10*log10(STPS);
%% plot the cepstrogram
% cepstral analysis
[C, q, tc] = cepstrogram(x, win, hop, fs);          % calculate the cepstrogram
C = C(q >= 1e-3, :);                                % ignore all cepstrum coefficients for                                                    % quefrencies bellow 1 ms  
q = q(q >= 1e-3);                                   % ignore all quefrencies bellow 1 ms
q = q*1000;                                         % convert the quefrency to ms
% plot the cepstrogram
figure(4)
[T, Q] = meshgrid(tc, q);
surf(T, Q, C)
shading interp
axis off
box on
view(0, 90)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Quefrency, ms')
% title('Cepstrogram of the signal')  
[~, cmax] = caxis;  
caxis([0 cmax])   

path='C:\Users\balu1\Desktop\NOIZEUS\train\-15dB\-15dB'; %%DESTINATION FOLDER PATH FOR GRAPHS
exportgraphics(figure(4),fullfile(path,['sp' num2str(k) '_train_sn-15.png']))

% path='C:\Users\balu1\Desktop\test'; %%DESTINATION FOLDER PATH FOR GRAPHS
% saveas(figure(4),fullfile(path,['sp' num2str(k) '_train_sn15.png']));
  
end


