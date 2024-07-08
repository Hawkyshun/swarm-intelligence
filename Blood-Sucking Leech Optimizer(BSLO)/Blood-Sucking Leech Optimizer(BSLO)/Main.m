clear all
clc

% benchmarksType = 1 için 23 Klasik benchmark fonksiyonları
% benchmarksType = 2 için CEC 2017
% benchmarksType = 3 için CEC 2019
benchmarksType = 1;

if benchmarksType == 1
    maxFunc = 23;
elseif benchmarksType == 2
    maxFunc = 30;
elseif benchmarksType == 3
    maxFunc = 10;
else
    exit;
end

Arama_Ajanı_Sayısı = 30;
Max_iterasyon = 1000;
runs = 30;
for fn = 1:maxFunc
    
    Fonksiyon_adı = strcat('F', num2str(fn));
    if benchmarksType == 1
        [lb, ub, dim, fobj] = Get_Functions_details(Fonksiyon_adı);
    elseif benchmarksType == 2
        if fn == 2
            continue;   % CEC-BC-2017'nin istikrarsız davranışı nedeniyle fonksiyon-2'yi atla
        end
        [lb, ub, dim, fobj] = CEC2017(Fonksiyon_adı);
    elseif benchmarksType == 3
        [lb, ub, dim, fobj] = CEC2019(Fonksiyon_adı);
    end
    
    En_iyi_skorlar_T = zeros(runs, 1);
    OrtalamaKonvEğrisi = zeros(Max_iterasyon, 1);
    Konverjans_eğrisi = zeros(runs, Max_iterasyon);

    for run = 1:runs
        [En_iyi_skor, En_iyi_pozisyon, cg_eğrisi] = BSLO(Arama_Ajanı_Sayısı, Max_iterasyon, lb, ub, dim, fobj);
        En_iyi_skorlar_T(run) = En_iyi_skor;       
    end
    
    En_iyi_skor_En_iyi = min(En_iyi_skorlar_T);
    En_iyi_skor_Ortalama = mean(En_iyi_skorlar_T);
    En_iyi_skor_StandartSapma = std(En_iyi_skorlar_T);
    % Çıktı
    format long
    display([Fonksiyon_adı, ' En İyi:  ', num2str(En_iyi_skor_En_iyi), '     ', 'Ortalama:  ', num2str(En_iyi_skor_Ortalama), '     ', 'Standart Sapma:  ', num2str(En_iyi_skor_StandartSapma)]);
end
