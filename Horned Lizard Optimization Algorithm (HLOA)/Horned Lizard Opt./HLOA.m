function [vMin, theBestVct, Convergence_curve] = HLOA(AramaAjanları_no, Max_iter, lb, ub, dim, fobj)

    Positions = initialization(AramaAjanları_no, dim, ub, lb);
    for i = 1:size(Positions, 1)
        Fitness(i) = fobj(Positions(i, :)); % fitness değerini al
    end
    [vMin, minIdx] = min(Fitness);  % en küçük fitness değeri vMin ve pozisyon minIdx
    theBestVct = Positions(minIdx, :);  % en iyi vektör 
    [vMax, maxIdx] = max(Fitness); % en büyük fitness değeri vMax ve pozisyon maxIdx
    Convergence_curve = zeros(1, Max_iter);
    Convergence_curve(1) = vMin;
    alphaMelanophore = alpha_melanophore(Fitness, vMin, vMax);
    
    % Ana döngü
    for t = 1:Max_iter  
       for r = 1:AramaAjanları_no
         if (0.5 < rand)   % eğer 0.5'ten büyükse
             v(r, :) = mimicry(theBestVct, Positions, Max_iter, AramaAjanları_no, t);
         else
             if (mod(t, 2))
                v(r, :) = shootBloodstream(theBestVct, Positions(r, :), Max_iter, t); 
             else
                v(r, :) = randomWalk(theBestVct, Positions(r, :));
             end
         end   
         Positions(maxIdx, :) = Skin_darkening_or_lightening(theBestVct, Positions, AramaAjanları_no);
         
         if (alphaMelanophore(r) <= 0.3)
             v(r, :) = replaceSearchAgent(theBestVct, Positions, AramaAjanları_no);
         end
        
         % Sınırların dışına çıkan arama ajanlarını geri getir
         v(r, :) = checkBoundaries(v(r, :), lb, ub);
         
         % Yeni çözümleri değerlendir
         Fnew = fobj(v(r, :));
         
         % Çözüm iyileşirse güncelle
         if Fnew <= Fitness(r)
            Positions(r, :) = v(r, :);
            Fitness(r) = Fnew;
         end
         
         if Fnew <= vMin
             theBestVct = v(r, :);
             vMin = Fnew;
         end 
       end
       
       % Maksimum ve alfa-melanofor güncelle
       [vMax, maxIdx] = max(Fitness);
       alphaMelanophore = alpha_melanophore(Fitness, vMin, vMax);
       Convergence_curve(t) = vMin; 
    end
    % HLOA Algoritmasının sonu
end
