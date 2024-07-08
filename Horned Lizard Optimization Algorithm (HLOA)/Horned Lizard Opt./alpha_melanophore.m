function [ o ] =  alpha_melanophore(  fit, min, max )
    for i=1:size(fit,2)
         o(i)= (max-fit(i))/(max-min);
    end

