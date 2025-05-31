function [Non, Teflon, Lanolin] = Results_str(Data_Non, Data_Teflon, Data_Lanolin)
Non = calc_Str(Data_Non);
Teflon = calc_Str(Data_Teflon);
Lanolin = calc_Str(Data_Lanolin);

function Materials = calc_Str(Data_Materials)
h0 = mean(Data_Materials.h0, 'omitnan');
D0 = mean(Data_Materials.D0, 'omitnan');
P = Data_Materials.P;
L = Data_Materials.L;
for i = 1:length(L)
    h(i) = h0 - L(i);
    NominalStrain(i) = 1 - h(i)/h0;
    TrueStrain(i) = log(h0/h(i));
    NominalStress(i) = 4*P(i)/(pi*D0);
    TrueStress(i) = NominalStress(i)*(1 - NominalStrain(i));
end
Materials.h0 = h0;
Materials.D0 = D0;
Materials.h = h;
Materials.NominalStrain = NominalStrain;
Materials.NominalStress = NominalStress;
Materials.TrueStrain = TrueStrain;
Materials.TrueStress = TrueStress;
end
figure
plot(Non.NominalStrain, Non.NominalStress, 'b-o', 'LineWidth',5); hold on;
plot(Teflon.NominalStrain, Teflon.NominalStress, 'r-o', 'LineWidth',5); hold on;
plot(Lanolin.NominalStrain, Lanolin.NominalStress, 'm-o', 'LineWidth',5)
legend('Non-lubricated', 'Teflon sheet', 'Lanolin');
xlabel('NominalStrain [-]'); ylabel('NominalStress [MPa]');
figure
loglog(Non.TrueStrain, Non.TrueStress, 'b-o', 'LineWidth',5); hold on;
loglog(Teflon.TrueStrain, Teflon.TrueStress, 'r-o', 'LineWidth',5); hold on;
loglog(Lanolin.TrueStrain, Lanolin.TrueStress, 'm-o', 'LineWidth',5)
legend('Non-lubricated', 'Teflon sheet', 'Lanolin');
xlabel('NominalStrain [-]'); ylabel('NominalStress [MPa]');
end