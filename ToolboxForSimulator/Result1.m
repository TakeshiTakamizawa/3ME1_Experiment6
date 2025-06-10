function [Non, Teflon, Lanolin] = Result1(Data_Non, Data_Teflon, Data_Lanolin, Non, Teflon, Lanolin, font_size)
titlename_Non = 'Non-lubricated'; titlename_Teflon = 'Teflon sheet'; titlename_Lanolin = 'Lanolin';
Non = calc_Result1(Data_Non, Non, titlename_Non);
Teflon = calc_Result1(Data_Teflon, Teflon, titlename_Teflon);
Lanolin = calc_Result1(Data_Lanolin, Lanolin, titlename_Lanolin);

% figure;
% subplot(1,3,1)
% errorbar(Non.Undim(:,2:end), Non.Strain_r_mean, Non.Strain_r_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', 'b', 'MarkerFaceColor','b');
% xlabel('Undimensional radius [-]', 'Interpreter', 'latex'); ylabel('Radial strain $\varepsilon$ [-]', 'Interpreter', 'latex');
% title(titlename_Non, 'Interpreter', 'latex');
% set(gca, 'FontSize', font_size);
% set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');
% 
% subplot(1,3,2)
% errorbar(Teflon.Undim(:,2:end), Teflon.Strain_r_mean, Teflon.Strain_r_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', 'r', 'MarkerFaceColor','r');
% xlabel('Undimensional radius [-]', 'Interpreter', 'latex'); ylabel('Radial strain $\varepsilon$ [-]', 'Interpreter', 'latex');
% title(titlename_Teflon, 'Interpreter', 'latex');
% set(gca, 'FontSize', font_size);
% set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');
% 
% subplot(1,3,3)
% errorbar(Lanolin.Undim(:,2:end), Lanolin.Strain_r_mean, Lanolin.Strain_r_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', 'k', 'MarkerFaceColor','k');
% xlabel('Undimensional radius [-]', 'Interpreter', 'latex'); ylabel('Radial strain $\varepsilon$ [-]', 'Interpreter', 'latex');
% title(titlename_Lanolin, 'Interpreter', 'latex');
% set(gca, 'FontSize', font_size);
% set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

figure;
errorbar(Non.Undim(:,2:end), Non.Strain_r_mean, Non.Strain_r_std, 'o', 'LineWidth', 2, 'MarkerSize', 6, 'CapSize', 10, 'Color', 'b', 'MarkerFaceColor','b');
hold on;
errorbar(Teflon.Undim(:,2:end), Teflon.Strain_r_mean, Teflon.Strain_r_std, 'o', 'LineWidth', 2, 'MarkerSize', 6, 'CapSize', 10, 'Color', 'r', 'MarkerFaceColor','r');
hold on;
errorbar(Lanolin.Undim(:,2:end), Lanolin.Strain_r_mean, Lanolin.Strain_r_std, 'o', 'LineWidth', 2, 'MarkerSize', 6, 'CapSize', 10, 'Color', 'k', 'MarkerFaceColor','k');
hold on;
xlabel('Normarized radius [-]', 'Interpreter', 'latex'); ylabel('Radial strain $\varepsilon_{\mathrm{r}}$ [-]', 'Interpreter', 'latex');
legend('Non-lubricated', 'Teflon sheet', 'Lanolin', 'Interpreter', 'latex', 'FontSize',font_size);
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');


function Materials = calc_Result1(Data_Materials, Materials, titlename)
D0 = mean(Data_Materials.D0, 'omitnan');
r_n = Data_Materials.r_n;
r_nd = Data_Materials.r_nd;
n = length(r_n);
    if mod(n,3) ~= 0
        warning('データ数が3の倍数ではありません. 余りは無視されます. ');
        n = floor(n / 3) * 3;
        r_n = r_n(1:n);
        Zn = Zn(1:n);
    end
nd = length(r_nd);
    if mod(nd,3) ~= 0
        warning('データ数が3の倍数ではありません. 余りは無視されます. ');
        nd = floor(nd / 3) * 3;
        r_nd = r_nd(1:nd);
        Zn = Zn(1:nd);
    end
r_n_groups = reshape(r_n, 3, []);
r_nd_groups = reshape(r_nd, 3, []);
for i = 1:length(r_n_groups)-1
    delr_n_groups(:,i) = r_n_groups(:,i+1) - r_n_groups(:,i);
end
for i = 1:length(r_nd_groups)-1
    delr_nd_groups(:,i) = r_nd_groups(:,i+1) - r_nd_groups(:,i);
end

for i = 1:length(delr_n_groups)
    for j = 1:1:3
        Strain_r(j,i) = delr_nd_groups(j,i)/delr_n_groups(j,i) - 1;
    end
end

Strain_r_mean = mean(Strain_r);
Strain_r_std = std(Strain_r);
r_n_groups_mean = mean(r_n_groups);
for i = 1:length(r_n_groups_mean)
    Undim(i) = r_n_groups_mean(i)/D0;
end

% figure;
% errorbar(Undim(:,2:end), Strain_r_mean, Strain_r_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', [0 0.4470 0.7410]);
% xlabel('Undimensional radius [-]', 'FontSize',20); ylabel('Radial strain [-]', 'FontSize',20);
% title(titlename);

Materials.delr_n_groups = delr_n_groups;
Materials.delr_nd_groups = delr_nd_groups;
Materials.Strain_r = Strain_r;
Materials.Strain_r_mean = Strain_r_mean;
Materials.Strain_r_std = Strain_r_std;
Materials.Undim = Undim;
end
end