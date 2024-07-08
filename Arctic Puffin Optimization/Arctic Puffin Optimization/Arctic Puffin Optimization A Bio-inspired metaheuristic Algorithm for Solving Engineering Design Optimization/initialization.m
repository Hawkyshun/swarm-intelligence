% Bu fonksiyon, arama ajanlarının ilk popülasyonunu başlatır
function Positions=initialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % sınırların sayısı

% Eğer tüm değişkenlerin sınırları eşitse ve kullanıcı hem ub hem de lb için tek bir sayı girerse
if Boundary_no==1
    Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
end

% Eğer her değişkenin farklı bir alt ve üst sınırı varsa
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end
end
