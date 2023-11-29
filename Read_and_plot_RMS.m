clc; clear; close all;
lw=1; %Line Thickness

Condition_label = [ 
    "Baseline", 
    "Defeito Rolamento e Desbalanciamento", 
    "Defeito Rolamento" , 
    "Desalinhamento Horiz Lado Oposto ao Acoplamento", 
    "Desbalanciamento Lado do Acoplamento", 
    "Desbalanciamento Lado Oposto ao Acoplamento"];
Condition_folder = [ 
    "Baseline", 
    "Defeito Rol e Desbalanc", 
    "Defeito Rolamento", 
    "DesalinhHorizLOA", 
    "Desbalanc1LA", 
    "Desbalanc2LOA"];
Condition_code = [  
    "Normal_", 
    "RolamDesbal_", 
    "Rolam_", 
    "DesalinhHoriz_", 
    "Desbalanc1_", 
    "Desbalanc2_"];

Machine_frequency = 10:10:40;
Machine_frequency_label = [" 10 Hz"," 20 Hz"," 30 Hz"," 40 Hz"];
Machine_frequency_code = erase(Machine_frequency_label,' ');

Fs = 6e3;
T = 1/Fs;  
L = 36e3; 

for j=1:1:4 % Varre as 4 freq
figure(j);
L = strings;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:1:4 % SELECIONA O DEFEITO, 1-6
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for k=1:1:50 % Seleciona uim dos segmentos para cada ensaio, 1 - 50
            signal_name = Condition_label(i) + Machine_frequency_label(j);
            filename = 'Dataset\' + Condition_folder(i) + '\' + Machine_frequency_code(j) +...
                '\' + Condition_code(i) + Machine_frequency_code(j) + '_' + num2str(k,'%.3d') + '.lvm';
            data = lvm_import(filename,false);
            
            time = data.Segment1.data(:,2) + 6*(k-1);
            Accel_Coupled_H = data.Segment1.data(1:35000,8);
            Accel_Coupled_V = data.Segment1.data(1:35000,9);
            Accel_Uncoupled_H = data.Segment1.data(1:35000,10);
            Accel_Uncoupled_V = data.Segment1.data(1:35000,11);
            
            rms_c_H(k) = rms(Accel_Coupled_H);
            rms_c_V(k) = rms(Accel_Coupled_V);
            rms_u_H(k) = rms(Accel_Uncoupled_H);
            rms_u_V(k) = rms(Accel_Uncoupled_V);
        end
            hold on
            scatter(rms_c_H,rms_c_V)
            scatter(rms_u_H,rms_u_V)
            L = [L, Condition_folder(i) + ' Coupled ' + Machine_frequency_label(j), ...
                    Condition_folder(i) + ' Uncoupled '+Machine_frequency_label(j)];
    end
legend(L(2:end))
title('Valores RMS para as 50 Séries de cada condição @'+Machine_frequency_label(j))
grid
ylabel('RMS Vel Vertical')
xlabel('RMS Vel Horizontal')
end