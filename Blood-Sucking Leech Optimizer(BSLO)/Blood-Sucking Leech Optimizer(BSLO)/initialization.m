function X = initialization(Arama_Ajanı_Sayısı, dim, ub, lb)

Sınır_no = size(ub, 2); % Değişken sınırlarının sayısı

% Eğer tüm değişkenlerin sınırları eşitse
if Sınır_no == 1
    X = rand(Arama_Ajanı_Sayısı, dim) .* (ub - lb) + lb;
end

% Eğer her bir değişkenin farklı lb ve ub değerleri varsa
if Sınır_no > 1
    for i = 1:dim
        ub_i = ub(i);
        lb_i = lb(i);
        X(:, i) = rand(Arama_Ajanı_Sayısı, 1) .* (ub_i - lb_i) + lb_i;
    end
end
