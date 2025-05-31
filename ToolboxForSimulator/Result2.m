function [Non, Teflon, Lanolin] = Result2(Data_Non, Data_Teflon, Data_Lanolin, Non, Teflon, Lanolin)
titlename_Non = 'Non-lubricated'; titlename_Teflon = 'Teflon sheet'; titlename_Lanolin = 'Lanolin';
Non = calc_Result2(Data_Non, Non, titlename_Non);
Teflon = calc_Result2(Data_Teflon, Teflon, titlename_Teflon);
Lanolin = calc_Result2(Data_Lanolin, Lanolin, titlename_Lanolin);

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

figure;
errorbar(Dimen, StrainC_mean, StrainC_std, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'CapSize', 8, 'Color', [0 0.4470 0.7410]);
xlabel('Dimensionless height [-]', 'FontSize',20); ylabel('Circumferential strain [-]', 'FontSize',20);
title(titlename);
end
end