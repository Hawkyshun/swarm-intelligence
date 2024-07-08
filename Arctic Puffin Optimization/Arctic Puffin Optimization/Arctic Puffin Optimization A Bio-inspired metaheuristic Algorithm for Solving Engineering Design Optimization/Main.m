% MATLAB R2022b de geliştirildi
% Kaynak kodları
% _____________________________________________________
clear  % Çalışma alanını temizle
clc    % Komut penceresini temizle
close all  % Tüm grafik pencerelerini kapat

%% Parametrelerin Tanımlanması
N = 30; % Arama ajanlarının sayısı
T = 1000; % Maksimum iterasyon sayısı
F_name = 'F13'; % Test fonksiyonunun adı

% Seçilen benchmark fonksiyonunun ayrıntılarını yükle
[lb, ub, D, fobj] = Functions_details(F_name);

% APO algoritması ile en iyi çözümü bul
[Best_Fitness, Best_Pos, Convergence_curve] = APO(N, T, lb, ub, D, fobj);

%% Hesaplama Sonuçlarının Gösterilmesi
display(['En iyi uygunluk değeri:', num2str(Best_Fitness)]);
display(['En iyi pozisyon:', num2str(Best_Pos)]);
