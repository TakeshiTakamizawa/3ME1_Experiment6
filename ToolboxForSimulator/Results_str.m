function [Non, Teflon, Lanolin] = Results_str(Data_Non, Data_Teflon, Data_Lanolin, font_size, titlename_Non , titlename_Teflon, titlename_Lanolin, plotnumber)
Non = calc_Str(Data_Non, titlename_Non, plotnumber);
Teflon = calc_Str(Data_Teflon, titlename_Teflon, plotnumber);
Lanolin = calc_Str(Data_Lanolin, titlename_Lanolin, plotnumber);

function Materials = calc_Str(Data_Materials, titlename, plotnumber)
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

coeff = polyfit(log_strain(plotnumber:end), log_stress(plotnumber:end), 1);  % 線形回帰

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
plot(Non.NominalStrain, Non.NominalStress, 'bo', 'LineWidth',5); hold on;
plot(Teflon.NominalStrain, Teflon.NominalStress, 'ro', 'LineWidth',5); hold on;
plot(Lanolin.NominalStrain, Lanolin.NominalStress, 'ko', 'LineWidth',5)
legend('Non-lubricated', 'Teflon sheet', 'Lanolin', 'Interpreter', 'latex', 'FontSize',font_size);
xlabel('NominalStrain $\varepsilon$ [-]', 'Interpreter', 'latex','FontSize' ,font_size); 
ylabel('NominalStress $\sigma$ [MPa]', 'Interpreter', 'latex', 'FontSize',font_size); 
title('nominal stress-nominal strain diagram', 'Interpreter', 'latex', 'FontSize',font_size)
axis([-0.1 0.8 0 230]);
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

subplot(1,3,2)
plot(Non.TrueStrain, Non.TrueStress, 'bo', 'LineWidth',5); hold on;
plot(Teflon.TrueStrain, Teflon.TrueStress, 'ro', 'LineWidth',5); hold on;
plot(Lanolin.TrueStrain, Lanolin.TrueStress, 'ko', 'LineWidth',5)
legend('Non-lubricated', 'Teflon sheet', 'Lanolin', 'Interpreter', 'latex', 'FontSize',font_size);
xlabel('TrueStrain $\varepsilon_{\mathrm{t}}$ [-]', 'Interpreter', 'latex', 'FontSize',font_size); 
ylabel('TrueStress $\sigma_{\mathrm{t}}$ [MPa]', 'Interpreter', 'latex', 'FontSize',font_size); 
title('true stress-true strain diagram', 'Interpreter', 'latex', 'FontSize',font_size)
axis([-0.1 0.8 0 230]);
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

subplot(1,3,3)
P_max = [Non.Pmax, Teflon.Pmax, Lanolin.Pmax];
x = 1:3;
colors = {'b', 'r', 'k'};
hold on
for i = 1:length(P_max)
    bar(x(i), P_max(i), 'FaceColor', colors{i});
end
xticks(x)
xticklabels({'$\mathrm{Non\!-\!lubricated}$', '$\mathrm{Teflon\ sheet}$', '$\mathrm{Lanolin}$'})
set(gca, 'TickLabelInterpreter', 'latex')
ylabel('Load $P_{\mathrm{max}}$ [KN]', 'Interpreter', 'latex')
title('maximum load', 'Interpreter', 'latex')
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');
hold off
box on

% subplot(1,3,3)
% P_max = [Non.Pmax, Teflon.Pmax, Lanolin.Pmax];
% X = categorical({'Non-lubricated', 'Teflon sheet', 'Lanolin'});
% X = reordercats(X,{'Non-lubricated', 'Teflon sheet', 'Lanolin'});
% hold on
% colors = {'b', 'r', 'k'};
% for i = 1:length(P_max)
%     bar(X(i), P_max(i), 'FaceColor', colors{i});
% end
% set(gca, 'FontSize', font_size);
% set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');
% 
% ylabel('Load $P_{\mathrm{max}}$ [KN]', 'Interpreter', 'latex')
% title('maximum load', 'Interpreter', 'latex')
% hold off
% box on

figure

loglog(Non.TrueStrain, Non.TrueStress, 'bo', 'LineWidth',5); hold on;
loglog(Teflon.TrueStrain, Teflon.TrueStress, 'ro', 'LineWidth',5); hold on;
loglog(Lanolin.TrueStrain, Lanolin.TrueStress, 'ko', 'LineWidth',5)
legend('Non-lubricated', 'Teflon sheet', 'Lanolin', 'FontSize',font_size);
xlabel('TrueStrain $\varepsilon$ [-]', 'Interpreter', 'latex', 'FontSize',font_size); 
ylabel('TrueStress $\sigma_{\mathrm{t}}$ [MPa]', 'Interpreter', 'latex', 'FontSize',font_size); 
title('true stress-true strain diagram', 'FontSize',font_size)

set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

figure
loglog(Non.TrueStrain, Non.TrueStress, 'bo', 'LineWidth',2, 'MarkerSize',5, 'MarkerFaceColor','b'); hold on;
loglog(Teflon.TrueStrain, Teflon.TrueStress, 'ro', 'LineWidth',2, 'MarkerSize',5, 'MarkerFaceColor','r'); hold on;
loglog(Lanolin.TrueStrain, Lanolin.TrueStress, 'ko', 'LineWidth',2, 'MarkerSize',5, 'MarkerFaceColor','k')
strain_fit = logspace(log10(min([min(Non.TrueStrain(plotnumber)), min(Teflon.TrueStrain(plotnumber)), min(Lanolin.TrueStrain(plotnumber))])), log10( max([max(Non.TrueStrain), max(Teflon.TrueStrain), max(Lanolin.TrueStrain)]) ), 100);
stress_Non = Non.K * strain_fit.^Non.n;
loglog(strain_fit, stress_Non, 'b-', 'LineWidth', 5);
stress_Teflon = Teflon.K * strain_fit.^Teflon.n;
loglog(strain_fit, stress_Teflon, 'r-', 'LineWidth', 5);
stress_Lanolin = Lanolin.K * strain_fit.^Lanolin.n;
loglog(strain_fit, stress_Lanolin, 'k-', 'LineWidth', 5);
xlabel('True Strain $\varepsilon$ [-]', 'Interpreter', 'latex');
ylabel('True Stress $\sigma_{\mathrm{t}}$ [MPa]', 'Interpreter', 'latex');
legend({titlename_Non, titlename_Teflon, titlename_Lanolin, ...
    ['$\sigma = ' num2str(Non.K,'%.1f') '\varepsilon^{' num2str(Non.n,'%.3f') '}$', ':',titlename_Non], ...
    ['$\sigma = ' num2str(Teflon.K,'%.1f') '\varepsilon^{' num2str(Teflon.n,'%.3f') '}$', ':',titlename_Teflon], ...
    ['$\sigma = ' num2str(Lanolin.K,'%.1f') '\varepsilon^{' num2str(Lanolin.n,'%.3f') '}$', ':',titlename_Lanolin]}, ...
    'Interpreter', 'latex', 'Location', 'best');

set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

% figure
% plot(Non.NominalStrain, Non.NominalStress, 'b-o', 'LineWidth',5); hold on;
% plot(Teflon.NominalStrain, Teflon.NominalStress, 'r-o', 'LineWidth',5); hold on;
% plot(Lanolin.NominalStrain, Lanolin.NominalStress, 'k-o', 'LineWidth',5)
% legend('Non-lubricated', 'Teflon sheet', 'Lanolin');
% xlabel('NominalStrain [-]'); ylabel('NominalStress [KPa]');
% 
% figure
% loglog(Non.TrueStrain, Non.TrueStress, 'b-o', 'LineWidth',5); hold on;
% loglog(Teflon.TrueStrain, Teflon.TrueStress, 'r-o', 'LineWidth',5); hold on;
% loglog(Lanolin.TrueStrain, Lanolin.TrueStress, 'k-o', 'LineWidth',5)
% legend('Non-lubricated', 'Teflon sheet', 'Lanolin');
% xlabel('NominalStrain [-]'); ylabel('NominalStress [KPa]');
% figure
% P_max = [Non.Pmax, Teflon.Pmax, Lanolin.Pmax];
% X = categorical({'Non-lubricated', 'Teflon sheet', 'Lanolin'});
% X = reordercats(X,{'Non-lubricated', 'Teflon sheet', 'Lanolin'});
% hold on
% colors = {'b', 'r', 'k'};
% for i = 1:length(P_max)
%     bar(X(i), P_max(i), 'FaceColor', colors{i});
% end
% set(gca, 'FontSize', font_size);
% set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');
% hold off

end