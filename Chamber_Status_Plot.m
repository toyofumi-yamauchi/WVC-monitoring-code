% Editor: Toyofumi Yamauchi
% Last update: 2/23/2021
clear
clc
format compact
format short
close all
warning('off','all')
set(0,'defaultAxesFontSize',13)
set(0,'DefaultLineLineWidth',2)
%% Color code
color = [[0,      0.4470, 0.7410];... % blue  
         [0.8500, 0.3250, 0.0980];... % orange
         [0.4660, 0.6740, 0.1880]];...% green
%% Read Data
filename = '21-04-26 Higher Amplitude 4';

% readmatrix is used when all data types are same
%table  = readtable(filename,'Format','%D%f%f%f%s%f%f%f%f%s');
table  = readtable(filename);
    time   = table2array(table(:,1));
    P      = table2array(table(:,2));
    T_LN2  = table2array(table(:,3));
    T_He   = table2array(table(:,4));
    memo   = table2array(table(:,5));
    MFC_P  = table2array(table(:,6));
    MFC_T  = table2array(table(:,7));
    MFC_SP = table2array(table(:,8));
    MFC_MF = table2array(table(:,9));
    MFC_G  = table2array(table(:,10));
%% Calcurating numbers
base_pressure = min(P);
min_LN2_temp  = min(T_LN2);
min_He_temp   = min(T_He);
%% Get time stamp
[mp1,mp2,rp1,rp2,cp1,cp2,ga1,ga2] = deal(time(1),time(1),time(1),time(1),time(1),time(1),time(1),time(1));
[mp1P,mp2P,rp1P,rp2P,cp1P,cp2P,ga1P,ga2P] = deal(0,0,0,0,0,0,0,0);
t_min_P = [];
for i = 1:length(time)
if isequal(memo(i),"Mechanical pump on")
    mp1 = time(i);
    mp1P = P(i);
elseif isequal(memo(i),"Mechanical pump off")
    mp2 = time(i);
    mp2P = P(i);
elseif isequal(memo(i),"Roots pump on")
    rp1 = time(i);
    rp1P = P(i);
elseif isequal(memo(i),"Roots pump off")
    rp2 = time(i);
    rp2P = P(i);
elseif isequal(memo(i),"Cryo pump on")
    cp1 = time(i);
    cp1P = P(i);
elseif isequal(memo(i),"Cryo pump off")
    cp2 = time(i);
    cp2P = P(i);
elseif isequal(memo(i),"Gas on")
    ga1 = time(i);
    ga1P = P(i);
elseif isequal(memo(i),"Gas off")
    ga2 = time(i);
    ga2P = P(i);
elseif isequal(P(i),base_pressure)
    t_min_P   = time(i);
elseif isequal(T_LN2(i),min_LN2_temp)
    t_min_LN2 = time(i);
elseif isequal(T_He(i),min_He_temp)
    t_min_He  = time(i);
end
end
%% Making plot
fig1 = figure(1);
set(fig1,'Position',[10 50 1000 750])
yyaxis left
p_plot = semilogy(time,P,'.','Color',color(1,:),'DisplayName','Pressure');
hold on
    semilogy(mp1,mp1P,'o','DisplayName','Mechanical pump on')
    semilogy(mp2,mp2P,'o','DisplayName','Mechanical pump off','MarkerFaceColor',[0, 0.4470, 0.7410])
    semilogy(rp1,rp1P,'^','DisplayName','Roots pump on')
    semilogy(rp2,rp2P,'^','DisplayName','Roots pump off','MarkerFaceColor',[0, 0.4470, 0.7410])
    semilogy(cp1,cp1P,'s','DisplayName','Cryopump on')
    semilogy(cp2,cp2P,'s','DisplayName','Cryopump off','MarkerFaceColor',[0, 0.4470, 0.7410])
    semilogy(ga1,ga1P,'d','DisplayName','Gas on')
    semilogy(ga2,ga2P,'d','DisplayName','Gas off','MarkerFaceColor',[0, 0.4470, 0.7410])
hold off
yyaxis right
LN2_plot = plot(time,T_LN2,'.','Color',color(2,:),'DisplayName','LN2 Temp');
hold on
He_plot  = plot(time,T_He, '.','Color',color(3,:),'DisplayName','He Temp');
hold off
title(filename)
yyaxis left
ylabel('Pressure [Torr]')
ylim([1e-9 1e3])
yticks([1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1 1e2 1e3])
ytickformat('%.e')
yyaxis right
ylabel('Temperature [K]')
ylim([0 300])
yticks([0 25 50 75 100 125 150 175 200 225 250 275 300])
xlim([min(time) max(time)])
%xlim([min(time) datetime(21,03,24,06,00,00)])
grid on
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';
legend([p_plot;LN2_plot;He_plot],'Location','SW');
%% 
disp('---Performances---')
disp(['Base pressure = ',num2str(base_pressure,'%.2E'),' [Torr] at '  ,datestr(t_min_P,  'HH:MM:SS AM mm/dd/yy')])
disp(['Min LN2 Temp  = ',num2str(min_LN2_temp ,'%.2f'),'    [K]    at ',datestr(t_min_LN2,'HH:MM:SS AM mm/dd/yy')])
disp(['Min He Temp   = ',num2str(min_He_temp  ,'%.2f'),'    [K]    at ',datestr(t_min_He, 'HH:MM:SS AM mm/dd/yy')])

disp('---Running time---')
fprintf('Mechanical pump = %s\n',mp2-mp1)
fprintf('Roots pump      = %s\n',rp2-rp1)
fprintf('Cryo-pump       = %s\n',cp2-cp1)
fprintf('Gas             = %s\n',ga2-ga1)
