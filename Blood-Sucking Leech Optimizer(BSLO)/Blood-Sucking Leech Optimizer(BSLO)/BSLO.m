function [Leeches_best_score, Leeches_best_pos, Convergence_curve] = BSLO(Arama_Ajanı_Sayısı, Max_iterasyon, lb, ub, dim, fobj)
%% En iyi sülükleri başlat
Leeches_best_pos = zeros(1, dim);
Leeches_best_score = inf; 
%% Arama ajanlarının pozisyonlarını başlatma
Leeches_Positions = initialization(Arama_Ajanı_Sayısı, dim, ub, lb);
Convergence_curve = zeros(1, Max_iterasyon);
Temp_best_fitness = zeros(1, Max_iterasyon);
fitness = zeros(1, Arama_Ajanı_Sayısı);
%% Parametreleri başlatma
t = 0; m = 0.8; a = 0.97; b = 0.001; t1 = 20; t2 = 20;
% Ana döngü
while t < Max_iterasyon
    N1 = floor((m + (1 - m) * (t / Max_iterasyon)^2) * Arama_Ajanı_Sayısı);
    % Fitness değerlerini hesaplama
    for i = 1:size(Leeches_Positions, 1)  
        % Sınır kontrolü
        Flag4ub = Leeches_Positions(i, :) > ub;
        Flag4lb = Leeches_Positions(i, :) < lb;
        Leeches_Positions(i, :) = (Leeches_Positions(i, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;               
        % Her arama ajanı için amaç fonksiyonunu hesaplama
        fitness(i) = fobj(Leeches_Positions(i, :));
        % En iyi sülükleri güncelleme
        if fitness(i) <= Leeches_best_score 
            Leeches_best_score = fitness(i); 
            Leeches_best_pos = Leeches_Positions(i, :);
        end
    end
    Prey_Position = Leeches_best_pos;
    % Yeniden izleme stratejisi
    Temp_best_fitness(t + 1) = Leeches_best_score;
    if t > t1
        if Temp_best_fitness(t + 1) == Temp_best_fitness(t + 1 - t2)
            for i = 1:size(Leeches_Positions, 1)
                if fitness(i) == Leeches_best_score 
                    Leeches_Positions(i, :) = rand(1, dim) .* (ub - lb) + lb;
                end
            end
        end
    end    
    if rand() < 0.5
        s = 8 - 1 * (-(t / Max_iterasyon)^2 + 1);
    else
        s = 8 - 7 * (-(t / Max_iterasyon)^2 + 1);
    end 
    beta = -0.5 * (t / Max_iterasyon)^6 + (t / Max_iterasyon)^4 + 1.5;
    LV = 0.5 * levy(Arama_Ajanı_Sayısı, dim, beta);
    %% Rastgele tam sayılar oluşturma
    minValue = 1;  % Minimum tam sayı değeri
    maxValue = floor(Arama_Ajanı_Sayısı * (1 + t / Max_iterasyon)); % Maksimum tam sayı değeri
    k2 = randi([minValue, maxValue], Arama_Ajanı_Sayısı, dim);
    k = randi([minValue, dim], Arama_Ajanı_Sayısı, dim);
    for i = 1:N1
        for j = 1:size(Leeches_Positions, 2) 
            r1 = 2 * rand() - 1; % r1 [0,1] arasında rastgele sayıdır
            r2 = 2 * rand() - 1;
            r3 = 2 * rand() - 1;           
            PD = s * (1 - (t / Max_iterasyon)) * r1;
            if abs(PD) >= 1
                % Yönlü sülüklerin keşfi
                b = 0.001;
                W1 = (1 - t / Max_iterasyon) * b * LV(i, j);
                L1 = r2 * abs(Prey_Position(j) - Leeches_Positions(i, j)) * PD * (1 - k2(i, j) / Arama_Ajanı_Sayısı);
                L2 = abs(Prey_Position(j) - Leeches_Positions(i, k(i, j))) * PD * (1 - (r2^2) * (k2(i, j) / Arama_Ajanı_Sayısı));
                if rand() < a
                    if abs(Prey_Position(j)) > abs(Leeches_Positions(i, j))
                        Leeches_Positions(i, j) = Leeches_Positions(i, j) + W1 * Leeches_Positions(i, j) - L1;
                    else
                        Leeches_Positions(i, j) = Leeches_Positions(i, j) + W1 * Leeches_Positions(i, j) + L1;
                    end
                else
                    if abs(Prey_Position(j)) > abs(Leeches_Positions(i, j))
                        Leeches_Positions(i, j) = Leeches_Positions(i, j) + W1 * Leeches_Positions(i, k(i, j)) - L2;
                    else
                        Leeches_Positions(i, j) = Leeches_Positions(i, j) + W1 * Leeches_Positions(i, k(i, j)) + L2;
                    end
                end                
            else
                % Yönlü sülüklerin kullanımı
                if t >= 0.1 * Max_iterasyon
                    b = 0.00001;
                end
                W1 = (1 - t / Max_iterasyon) * b * LV(i, j);
                L3 = abs(Prey_Position(j) - Leeches_Positions(i, j)) * PD * (1 - r3 * k2(i, j) / Arama_Ajanı_Sayısı);
                L4 = abs(Prey_Position(j) - Leeches_Positions(i, k(i, j))) * PD * (1 - r3 * k2(i, j) / Arama_Ajanı_Sayısı);
                if rand() < a
                    if abs(Prey_Position(j)) > abs(Leeches_Positions(i, j))
                        Leeches_Positions(i, j) = Prey_Position(j) + W1 * Prey_Position(j) - L3;
                    else
                        Leeches_Positions(i, j) = Prey_Position(j) + W1 * Prey_Position(j) + L3;
                    end
                else
                    if abs(Prey_Position(j)) > abs(Leeches_Positions(i, j))
                        Leeches_Positions(i, j) = Prey_Position(j) + W1 * Prey_Position(j) - L4;
                    else
                        Leeches_Positions(i, j) = Prey_Position(j) + W1 * Prey_Position(j) + L4;
                    end                   
                end
            end
        end
    end
    % Yönsüz sülüklerin arama stratejisi
    for i = (N1 + 1):size(Leeches_Positions, 1)
        for j = 1:size(Leeches_Positions, 2)
            if min(lb) >= 0
                LV(i, j) = abs(LV(i, j));
            end
            if rand() > 0.5
                Leeches_Positions(i, j) = (t / Max_iterasyon) * LV(i, j) * Leeches_Positions(i, j) * abs(Prey_Position(j) - Leeches_Positions(i, j));  
            else
                Leeches_Positions(i, j) = (t / Max_iterasyon) * LV(i, j) * Prey_Position(j) * abs(Prey_Position(j) - Leeches_Positions(i, j));          
            end
        end
    end
    t = t + 1;     
    Convergence_curve(t) = Leeches_best_score;  
end
