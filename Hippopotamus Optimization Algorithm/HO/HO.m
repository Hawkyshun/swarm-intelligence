%% Mohammad Hussien Amiri ve Nastaran Mehrabi Hashjin tarafından Tasarlanmış ve Geliştirilmiştir
function [En_Iyi_Skor, En_Iyi_Pozisyon, HO_Kurva] = HO(Arama_Ajanları, Max_Iterasyonlar, alt_sınır, üst_sınır, boyut, uygunluk)

alt_sınır = ones(1, boyut) .* alt_sınır;                              % Değişkenler için alt sınır
üst_sınır = ones(1, boyut) .* üst_sınır;                              % Değişkenler için üst sınır

%% Başlangıç
for i = 1:boyut
    X(:, i) = alt_sınır(i) + rand(Arama_Ajanları, 1) .* (üst_sınır(i) - alt_sınır(i));                          % İlk populasyon
end

for i = 1:Arama_Ajanları
    L = X(i, :);
    uygunluk_değeri(i) = uygunluk(L);
end

%% Ana Döngü
for t = 1:Max_Iterasyonlar
    %% En İyi Aday Çözümün Güncellenmesi
    [en_iyi, konum] = min(uygunluk_değeri);
    if t == 1
        En_Iyi_Pozisyon = X(konum, :);                                  % Optimal konum
        En_Iyi_Skor = en_iyi;                                           % Optimizasyon hedef fonksiyonu
    elseif en_iyi < En_Iyi_Skor
        En_Iyi_Skor = en_iyi;
        En_Iyi_Pozisyon = X(konum, :);
    end

    for i = 1:Arama_Ajanları/2

        %% Faz 1: Nehir veya göldeki hipopotamların pozisyon güncellemesi (Keşif)
        Dominant_hippopotamus = En_Iyi_Pozisyon;
        I1 = randi([1, 2], 1, 1);
        I2 = randi([1, 2], 1, 1);
        Ip1 = randi([0, 1], 1, 2);
        RandGroupNumber = randperm(Arama_Ajanları, 1);
        RandGroup = randperm(Arama_Ajanları, RandGroupNumber);

        % Rastgele Grubun Ortalaması
        OrtalamaGrup = mean(X(RandGroup, :)) .* (length(RandGroup) ~= 1) + X(RandGroup(1, 1), :) * (length(RandGroup) == 1);
        Alfa{1, :} = (I2 * rand(1, boyut) + (~Ip1(1)));
        Alfa{2, :} = 2 * rand(1, boyut) - 1;
        Alfa{3, :} = rand(1, boyut);
        Alfa{4, :} = (I1 * rand(1, boyut) + (~Ip1(2)));
        Alfa{5, :} = rand;
        A = Alfa{randi([1, 5], 1, 1), :};
        B = Alfa{randi([1, 5], 1, 1), :};
        X_P1(i, :) = X(i, :) + rand(1, 1) .* (Dominant_hippopotamus - I1 .* X(i, :));
        T = exp(-t / Max_Iterasyonlar);
        if T > 0.6
            X_P2(i, :) = X(i, :) + A .* (Dominant_hippopotamus - I2 .* OrtalamaGrup);
        else
            if rand() > 0.5
                X_P2(i, :) = X(i, :) + B .* (OrtalamaGrup - Dominant_hippopotamus);
            else
                X_P2(i, :) = ((üst_sınır - alt_sınır) .* rand + alt_sınır);
            end

        end
        X_P2(i, :) = min(max(X_P2(i, :), alt_sınır), üst_sınır);

        L = X_P1(i, :);
        F_P1(i) = uygunluk(L);
        if F_P1(i) < uygunluk_değeri(i)
            X(i, :) = X_P1(i, :);
            uygunluk_değeri(i) = F_P1(i);
        end

        L2 = X_P2(i, :);
        F_P2(i) = uygunluk(L2);
        if F_P2(i) < uygunluk_değeri(i)
            X(i, :) = X_P2(i, :);
            uygunluk_değeri(i) = F_P2(i);
        end

    end
    %% Faz 2: Hipopotamların avcılara karşı savunması (Keşif)
    for i = 1 + Arama_Ajanları/2:Arama_Ajanları
        avcı = alt_sınır + rand(1, boyut) .* (üst_sınır - alt_sınır); 
        L = avcı;
        F_HL = uygunluk(L);
        distance2Leader = abs(avcı - X(i, :));
        b = unifrnd(2, 4, [1 1]);
        c = unifrnd(1, 1.5, [1 1]);
        d = unifrnd(2, 3, [1 1]);
        l = unifrnd(-2*pi, 2*pi, [1 1]);
        RL = 0.05 * levy(Arama_Ajanları, boyut, 1.5);

        if uygunluk_değeri(i) > F_HL
            X_P3(i, :) = RL(i, :) .* avcı + (b ./ (c - d * cos(l))) .* (1 ./ distance2Leader);
        else
            X_P3(i, :) = RL(i, :) .* avcı + (b ./ (c - d * cos(l))) .* (1 ./ (2 .* distance2Leader + rand(1, boyut)));
        end
        X_P3(i, :) = min(max(X_P3(i, :), alt_sınır), üst_sınır);

        L = X_P3(i, :);
        F_P3(i) = uygunluk(L);

        if F_P3(i) < uygunluk_değeri(i)
            X(i, :) = X_P3(i, :);
            uygunluk_değeri(i) = F_P3(i);
        end
    end

    %% Faz 3: Avcıdan kaçan hipopotamlar (Kullanım)
    for i = 1:Arama_Ajanları
        LO_YEREL = (alt_sınır ./ t);
        HI_YEREL = (üst_sınır ./ t);
        Alfa{1, :} = 2 * rand(1, boyut) - 1;
        Alfa{2, :} = rand(1, 1);
        Alfa{3, :} = randn;
        D = Alfa{randi([1, 3], 1, 1), :};
        X_P4(i, :) = X(i, :) + (rand(1, 1)) .* (LO_YEREL + D .* (HI_YEREL - LO_YEREL));
        X_P4(i, :) = min(max(X_P4(i, :), alt_sınır), üst_sınır);

        L = X_P4(i, :);
        F_P4(i) = uygunluk(L);
        if F_P4(i) < uygunluk_değeri(i)
            X(i, :) = X_P4(i, :);
            uygunluk_değeri(i) = F_P4(i);
        end

    end
    en_iyi_son(t) = En_Iyi_Skor;
    disp(['Iterasyon ' num2str(t) ': En İyi Maliyet = ' num2str(en_iyi_son(t))]);

    En_Iyi_Skor = en_iyi;
    En_Iyi_Pozisyon = En_Iyi_Pozisyon;
    HO_Kurva = en_iyi_son;

end

end
