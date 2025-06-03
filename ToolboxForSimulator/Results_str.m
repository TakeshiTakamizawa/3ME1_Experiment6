function [Non, Teflon, Lanolin] = Results_str(Data_Non, Data_Teflon, Data_Lanolin, font_size, titlename_Non , titlename_Teflon, titlename_Lanolin)
Non = calc_Str(Data_Non, titlename_Non);
Teflon = calc_Str(Data_Teflon, titlename_Teflon);
Lanolin = calc_Str(Data_Lanolin, titlename_Lanolin);

function Materials = calc_Str(Data_Materials, titlename)
h0 = mean(Data_Materials.h0, 'omitnan');
D0 = mean(Data_Materials.D0, 'omitnan');
P = 9.8066/10^3*Data_Materials.P; % [kgf] → [KN]
L = Data_Materials.L;
for i = 1:length(L)
    h(i) = h0 - L(i);
    NominalStrain(i) = 1 - h(i)/h0;
    TrueStrain(i) = log(h0/h(i));
    NominalStress(i) = 4*P(i)/(pi*D0)*10^3;
    TrueStress(i) = NominalStress(i)*(1 - NominalStrain(i));
end
idx = ~isnan(TrueStrain) & ~isnan(TrueStress);
TrueStrain = TrueStrain(idx);
TrueStress = TrueStress(idx);
log_strain = log(TrueStrain);
log_stress = log(TrueStress);

coeff = polyfit(log_strain(1:end), log_stress(1:end), 1);  % 線形回帰

n = coeff(1);
K = exp(coeff(2));
disp(titlename)
fprintf('%s 加工硬化指数 n = %.3f\n',titlename , n);
fprintf('%s 強度係数 K = %.1f MPa\n',titlename, K);

Materials.h0 = h0;
Materials.D0 = D0;
Materials.h = h;
Materials.NominalStrain = NominalStrain;
Materials.NominalStress = NominalStress;
Materials.TrueStrain = TrueStrain;
Materials.TrueStress = TrueStress;
Materials.Pmax = max(P);
Materials.n = n;
Materials.K = K;
end

figure
subplot(1,3,1)
plot(Non.NominalStrain, Non.NominalStress, 'b-o', 'LineWidth',5); hold on;
plot(Teflon.NominalStrain, Teflon.NominalStress, 'r-o', 'LineWidth',5); hold on;
plot(Lanolin.NominalStrain, Lanolin.NominalStress, 'm-o', 'LineWidth',5)
legend('Non-lubricated', 'Teflon sheet', 'Lanolin', 'FontSize',font_size);
xlabel('NominalStrain [-]', 'FontSize',font_size); 
ylabel('NominalStress [MPa]', 'FontSize',font_size); 
title('nominal stress-nominal strain diagram', 'FontSize',font_size)
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

subplot(1,3,2)
loglog(Non.TrueStrain, Non.TrueStress, 'b-o', 'LineWidth',5); hold on;
loglog(Teflon.TrueStrain, Teflon.TrueStress, 'r-o', 'LineWidth',5); hold on;
loglog(Lanolin.TrueStrain, Lanolin.TrueStress, 'm-o', 'LineWidth',5)
legend('Non-lubricated', 'Teflon sheet', 'Lanolin', 'FontSize',font_size);
xlabel('TrueStrain [-]', 'FontSize',font_size); 
ylabel('TrueStress [MPa]', 'FontSize',font_size); 
title('true stress-true strain diagram', 'FontSize',font_size)
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

subplot(1,3,3)
P_max = [Non.Pmax, Teflon.Pmax, Lanolin.Pmax];
X = categorical({'Non-lubricated', 'Teflon sheet', 'Lanolin'});
X = reordercats(X,{'Non-lubricated', 'Teflon sheet', 'Lanolin'});
hold on
colors = {'b', 'r', 'm'};
for i = 1:length(P_max)
    bar(X(i), P_max(i), 'FaceColor', colors{i});
end
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');
ylabel('Load [KN]')
title('maximum load')
hold off
box on

figure
loglog(Non.TrueStrain, Non.TrueStress, 'bo', 'LineWidth',5); hold on;
loglog(Teflon.TrueStrain, Teflon.TrueStress, 'ro', 'LineWidth',5); hold on;
loglog(Lanolin.TrueStrain, Lanolin.TrueStress, 'mo', 'LineWidth',5)
strain_fit = logspace(log10(0.001), log10( max([max(Non.TrueStrain), max(Teflon.TrueStrain), max(Lanolin.TrueStrain)]) ), 100);
stress_Non = Non.K * strain_fit.^Non.n;
loglog(strain_fit, stress_Non, 'b-', 'LineWidth', 5);
stress_Teflon = Teflon.K * strain_fit.^Teflon.n;
loglog(strain_fit, stress_Teflon, 'r-', 'LineWidth', 5);
stress_Lanolin = Lanolin.K * strain_fit.^Lanolin.n;
loglog(strain_fit, stress_Lanolin, 'm-', 'LineWidth', 5);
xlabel('True Strain');
ylabel('True Stress [MPa]');
legend({titlename_Non, titlename_Teflon, titlename_Lanolin, ...
    ['$\sigma = ' num2str(Non.K,'%.1f') '\varepsilon^{' num2str(Non.n,'%.2f') '}$', ':',titlename_Non], ...
    ['$\sigma = ' num2str(Teflon.K,'%.1f') '\varepsilon^{' num2str(Teflon.n,'%.2f') '}$', ':',titlename_Teflon], ...
    ['$\sigma = ' num2str(Lanolin.K,'%.1f') '\varepsilon^{' num2str(Lanolin.n,'%.2f') '}$', ':',titlename_Lanolin]}, ...
    'Interpreter', 'latex', 'Location', 'best');

set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

% figure
% plot(Non.NominalStrain, Non.NominalStress, 'b-o', 'LineWidth',5); hold on;
% plot(Teflon.NominalStrain, Teflon.NominalStress, 'r-o', 'LineWidth',5); hold on;
% plot(Lanolin.NominalStrain, Lanolin.NominalStress, 'm-o', 'LineWidth',5)
% legend('Non-lubricated', 'Teflon sheet', 'Lanolin');
% xlabel('NominalStrain [-]'); ylabel('NominalStress [KPa]');
% 
% figure
% loglog(Non.TrueStrain, Non.TrueStress, 'b-o', 'LineWidth',5); hold on;
% loglog(Teflon.TrueStrain, Teflon.TrueStress, 'r-o', 'LineWidth',5); hold on;
% loglog(Lanolin.TrueStrain, Lanolin.TrueStress, 'm-o', 'LineWidth',5)
% legend('Non-lubricated', 'Teflon sheet', 'Lanolin');
% xlabel('NominalStrain [-]'); ylabel('NominalStress [KPa]');
% figure
% P_max = [Non.Pmax, Teflon.Pmax, Lanolin.Pmax];
% X = categorical({'Non-lubricated', 'Teflon sheet', 'Lanolin'});
% X = reordercats(X,{'Non-lubricated', 'Teflon sheet', 'Lanolin'});
% hold on
% colors = {'b', 'r', 'm'};
% for i = 1:length(P_max)
%     bar(X(i), P_max(i), 'FaceColor', colors{i});
% end
% set(gca, 'FontSize', font_size);
% set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');
% hold off

end