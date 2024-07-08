% Girdi parametreleri
% n -> Adım sayısı
% m -> Boyut sayısı
% beta -> Güç yasası indeksi % Not: 1 < beta < 2
% Çıktı
% z -> 'n' adet 'm' boyutlu levy adımları
%_________________________________________________________________________
function [z] = levy(n, m, beta)
  num = gamma(1 + beta) * sin(pi * beta / 2); % Payda için kullanılır
  den = gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2); % Pay için kullanılır
  sigma_u = (num / den)^(1 / beta); % Standart sapma
  u = random('Normal', 0, sigma_u, n, m); 
  v = random('Normal', 0, 1, n, m);
  z = u ./ (abs(v).^(1 / beta));
end
