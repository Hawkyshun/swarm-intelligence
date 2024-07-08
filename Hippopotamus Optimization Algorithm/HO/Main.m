clc
clear
close all

Fun_name = 'F2';                     % test fonksiyonun numarası: 'F1' - 'F23' arası
SearchAgents = 16;                     % Hippopotamus sayısı (popülasyon üyeleri)
Max_iterations = 500;                     % maksimum iterasyon sayısı
[lowerbound, upperbound, dimension, fitness] = fun_info(Fun_name);                     % Obje fonksiyonu
[Best_score, Best_pos, HO_curve] = HO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness);

display(['HO tarafından ' [num2str(Fun_name)],' fonksiyonu için en iyi çözüm: ', num2str(Best_pos)]);
display(['HO tarafından ' [num2str(Fun_name)],' fonksiyonu için en iyi optimal değer: ', num2str(Best_score)]);

figure = gcf;
semilogy(HO_curve, 'Color', '#b28d90', 'LineWidth', 2)
xlabel('İterasyon');
ylabel('Şimdiye kadar elde edilen en iyi skor');
box on
set(findall(figure, '-property', 'FontName'), 'FontName', 'Times New Roman')
legend('HO')
