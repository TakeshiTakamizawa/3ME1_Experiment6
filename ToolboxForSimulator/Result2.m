function [Non, Teflon, Lanolin] = Result2(Data_Non, Data_Teflon, Data_Lanolin, Non, Teflon, Lanolin, font_size)
titlename_Non = 'Non-lubricated'; titlename_Teflon = 'Teflon sheet'; titlename_Lanolin = 'Lanolin';
Non = calc_Result2(Data_Non, Non, titlename_Non);
Teflon = calc_Result2(Data_Teflon, Teflon, titlename_Teflon);
Lanolin = calc_Result2(Data_Lanolin, Lanolin, titlename_Lanolin);

figure;
subplot(1,3,1)
errorbar(Non.Dimen, Non.StrainC_mean, Non.StrainC_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', 'b', 'MarkerFaceColor','b');
xlabel('Dimensionless height [-]'); ylabel('Circumferential strain [-]');
title(titlename_Non);
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

subplot(1,3,2)
errorbar(Teflon.Dimen, Teflon.StrainC_mean, Teflon.StrainC_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', 'r', 'MarkerFaceColor','r');
xlabel('Dimensionless height [-]'); ylabel('Circumferential strain [-]');
title(titlename_Teflon);
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

subplot(1,3,3)
errorbar(Lanolin.Dimen, Lanolin.StrainC_mean, Lanolin.StrainC_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', 'm', 'MarkerFaceColor','m');
xlabel('Dimensionless height [-]'); ylabel('Circumferential strain [-]');
title(titlename_Lanolin);
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

figure
errorbar(Non.Dimen, Non.StrainC_mean, Non.StrainC_std, 'o-', 'LineWidth', 5, 'MarkerSize', 6, 'CapSize', 20, 'Color', 'b', 'MarkerFaceColor','b');
hold on;
errorbar(Teflon.Dimen, Teflon.StrainC_mean, Teflon.StrainC_std, 'o-', 'LineWidth', 5, 'MarkerSize', 6, 'CapSize', 20, 'Color', 'r', 'MarkerFaceColor','r');
hold on;
errorbar(Lanolin.Dimen, Lanolin.StrainC_mean, Lanolin.StrainC_std, 'o-', 'LineWidth', 5, 'MarkerSize', 6, 'CapSize', 20, 'Color', 'm', 'MarkerFaceColor','m');
xlabel('Dimensionless height [-]'); ylabel('Circumferential strain [-]');
legend('Non-lubricated', 'Teflon sheet', 'Lanolin', 'FontSize',font_size);
set(gca, 'FontSize', font_size);
set(gca, 'TickLength', [0.03 0.03], 'XMinorTick', 'on', 'YMinorTick', 'on');

function Materials = calc_Result2(Data_Materials, Materials, titlename)
h0 = mean(Data_Materials.h0, 'omitnan');
D0 = mean(Data_Materials.D0, 'omitnan');
dnd = Data_Materials.dnd;
Zn = Data_Materials.Zn;
Zn0 = mean([Zn(16), Zn(17), Zn(18)]);
for i = 1:length(Zn)
    Zn(i) = Zn(i) - Zn0;
    Strain_c(i) = dnd(i)/D0 - 1;
end
Materials.Zn = Zn;
Materials.Strain_c = Strain_c;
n = length(Strain_c);
    if mod(n,3) ~= 0
        warning('データ数が3の倍数ではありません. 余りは無視されます. ');
        n = floor(n / 3) * 3;
        Strain_c = Strain_c(1:n);
        Zn = Zn(1:n);
    end
StrainC_groups = reshape(Strain_c, 3, []);
Zn_groups = reshape(Zn, 3, []);
StrainC_mean = mean(StrainC_groups);
StrainC_std = std(StrainC_groups);
Zn_std = std(Zn_groups);
Zn_mean = mean(Zn_groups);
for i = 1:length(Zn_mean)
    Dimen(i) = Zn_mean(i)/h0;
end
Materials.StrainC_mean = StrainC_mean;
Materials.StrainC_std = StrainC_std;
Materials.ZnC_std = Zn_std;
Materials.ZnC_mean = Zn_mean;
Materials.Dimen = Dimen;

% figure;
% errorbar(Dimen, StrainC_mean, StrainC_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', [0 0.4470 0.7410]);
% xlabel('Dimensionless height [-]', 'FontSize',20); ylabel('Circumferential strain [-]', 'FontSize',20);
% title(titlename);
end
end