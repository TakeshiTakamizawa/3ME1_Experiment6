clc; close all; clear;

%% setting condition
addpath(genpath('ToolboxForSimulator'));
Data_Non     = readtable('Data_Non.xlsx');
Data_Teflon     = readtable('Data_Teflon_extra.xlsx');
Data_Lanolin     = readtable('Data_Lanolin.xlsx');
font_size = 20;
titlename_Non = 'Non-lubricated';
titlename_Teflon = 'Teflon sheet';
titlename_Lanolin = 'Lanolin';
plotnumber = 11;
% Experimental results
[Non, Teflon, Lanolin] = Results_str(Data_Non, Data_Teflon, Data_Lanolin, font_size, titlename_Non, titlename_Teflon, titlename_Lanolin, plotnumber);

[Non, Teflon, Lanolin] = Result1(Data_Non, Data_Teflon, Data_Lanolin, Non, Teflon, Lanolin, font_size);
[Non, Teflon, Lanolin] = Result2(Data_Non, Data_Teflon, Data_Lanolin, Non, Teflon, Lanolin, font_size);

