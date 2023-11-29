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
L = 36e3*50; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=2; % SELECIONA O DEFEITO, 1-6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:1:4 % Varre as 4 freq

    time = zeros((36000*50),1);
    Accel_Coupled_H = zeros((36000*50),1);
    for k=1:1:50
    signal_name = Condition_label(i) + Machine_frequency_label(j);
    filename = 'Dataset\' + Condition_folder(i) + '\' + Machine_frequency_code(j) +...
        '\' + Condition_code(i) + Machine_frequency_code(j) + '_' + num2str(k,'%.3d') + '.lvm';
    
    data = lvm_import(filename,false); %% Importa cada arquivo
    
    time(1+36000*(k-1):36000*k) = data.Segment1.data(:,2) + 6*(k-1);
    Accel_Coupled_H(1+36000*(k-1):36000*k) = data.Segment1.data(:,4);
    end
    
    X = Accel_Coupled_H;
    rootmeansqr = rms(X);
    
   f2 = figure(2);
    subplot(2,2,j)
        M = 36000;
        L2 = 100;
        g = bartlett(M);
        Ndft = 36000;
        
        [s,f,t] = spectrogram(X,g,L2,Ndft,Fs);
        waterplot(s,f,t);
        zlim([0,160])
        title(signal_name)
end


function waterplot(s,f,t)
% Waterfall plot of spectrogram
    c =  abs(s)'.^2;
    waterfall(f,t,20*log10(c))
    set(gca,XDir="reverse",View=[30 50])
    xlabel("Frequency (Hz)")
    ylabel("Time (s)")

end