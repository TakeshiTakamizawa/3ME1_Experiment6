function [Non, Teflon, Lanolin] = Results_str(Data_Non, Data_Teflon, Data_Lanolin, font_size)
Non = calc_Str(Data_Non);
Teflon = calc_Str(Data_Teflon);
Lanolin = calc_Str(Data_Lanolin);

function Materials = calc_Str(Data_Materials)
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
Materials.h0 = h0;
Materials.D0 = D0;
Materials.h = h;
Materials.NominalStrain = NominalStrain;
Materials.NominalStress = NominalStress;
Materials.TrueStrain = TrueStrain;
Materials.TrueStress = TrueStress;
Materials.Pmax = max(P);
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
xlabel('NominalStrain [-]', 'FontSize',font_size); 
ylabel('NominalStress [MPa]', 'FontSize',font_size); 
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