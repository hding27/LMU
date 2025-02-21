%%% Analysis of Lanex screens %%%

 % Structure of .m file

    % a)  Read in .mat files generated in ReadLanex.m  

    % b)  Important Parameters                          
    
    % c)  Take only Region of Interest                  
    % c1) Save the full Picture with marking rectangles 
    % c2) Generate 3D - Plot                            
    % c3) Beam Profil                                   
    % c4) Charge Density
    
    % d)  Generate Absolute Scale with error bars
    % d1) List of Important Parameters
    % d2) compute intermediate results
    % d3) compute absolute scale

    % e5) compute error of intermediate result 
    % e6) compute error bars
    
    % f) Generate Plots and dat files
    % f1) Plot 1D horizontal Beam Profil of each charge in one Plot
    
    % g) Write the Dat files
    % g1) Lanex Screens
    % g2) Parameters of Lanex experiment for cross checking   
    % g3) Write CLS dat file
    
    % END !!!
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                                 %%%%%%%                                 %
%                                    %                                    %
%                          %%%%%%% START %%%%%%%                          %
%                                    %                                    %
%                                 %%%%%%%                                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% a) Read in .mat files generated in ReadLanex.m

    clear all;
    cd('C:\Masterarbeit_Thomas\Analysis\Intermediateresult\Lanex');
    load('Lanexstruc.mat');

% b) Important Parameters
    
    % Paramters for absolute scale
    
        % Generate Structure for all Paramters in order tyding up workspace
    
        Parameter.distanceFilter = 449;   % [mm]
        Parameter.distanceCamera = 517;   % [mm] 
        
        for i = 1:6
            for j = 1:length(Screens1(1,i).parameter.ndfilter)
                
                Parameter.ndFilter(1,j,i) =  Screens1(1,i).parameter.ndfilter(j);           % logscale of nd - filters    
                Parameter.exposure (1,j,i) =  Screens1(1,i).parameter.exposure_time(j)/100; % exposure time [ms]
           
            end
        end
        
        Parameter.window    =  0.913; % Transmission of Window
        Parameter.objectiv  =  0.929; % Transmission of Objective
        Parameter.reflexion =  0.991; % Reflexion of the silver mirror @ wavelength
        Parameter.aperture  =  22.96; % Clear aperture [mm] 
        Parameter.qeLanex   =  0.601; % Quantum efficiency of the ccd chip @ Lanex wavelength
        
    % Error for the error bars (
        
        % err_ ^= measurement error ;  sig_ ^= statistical error std of
        % mean value92.9
    
        ErrParameter.errDistanceFilter = 4; % [mm]
        
        for i = 1:6
            for j = 1:length(Screens1(1,i).parameter.ndfilter)
                
                ErrParameter.sigNdFilter(1,j,i) = Screens1(1,i).parameter.err_ndfilter(j);
                
            end
        end
        
        ErrParameter.sigWindow = 0.01;
        ErrParameter.sigObjectiv = 0.002;
        ErrParameter.sigReflexion = 0.001;
        ErrParameter.errAperture = 0.04; % [mm]
        ErrParameter.sigQeLanex = 0.023; 

    % c) Take only Region of Interest


    for i=1:6    % Loop for the screens
     
       for j=2:length(Screens1(1,i).parameter.ndfilter) % loop for charge
         
       cdata = Screens1(1,i).Signal.(['Signal' num2str(Screens1(1,i).charge2(j))]); % Redefinition for easyness
       [C,I] = max(sum(cdata));   % Output maximum value summation over colums Finds the maximum colum in order to avoid 
                                  % finding maximum in the nowhere by hot pixel
       [B,J] = max(sum(cdata')'); % Output maximum value summation over rows Finds the maximum colum in order to avoid 
                                  % finding maximum in the nowhere by hot pixel
    
        % Define Rectangle
        
        b = J - 50 + (15 - 2 * j);  % Left upper corner
        c = I + 50 - (15 - 2 * j);  % Right lower corner
        pos_cdata = [c-74-4*j b 74+4*j 74+4*j]; % Define Rectangle
        
        % Define Background on the same picture --> advantage getting
        % sensitve to online X-Ray( immediatly generated ones)
        
        pos_BG = [800 100 350 350];
        
        BG = (cdata(100:449 , 700:1049));  % Define Background Spot
        cdata_ROI = cdata(b:b+73+4*j , c-73-4*j:c); 
        rescale = (size(BG)/size(cdata_ROI))^2;
        BG = sum(BG(:)) / rescale; % Rescale BG to ROI size
        
        % Image Full Picture
        
        figure(1)
         x = 4.86 * (Parameter.distanceCamera / 50 - 1); % Sensorsize * (distance / focal length - 1)
         X = linspace(0,x, 1296);
         y = 3.62 * (Parameter.distanceCamera / 50 - 1);  % used for conversion pixel to mm
         Y = linspace(0,y,966);
        image(cdata,'Cdatamapping','scaled');
        colormap default;
        colorbar;
        caxis([0 max(cdata_ROI(:))]);
        hold on;
        r_cdata = rectangle('Position',pos_cdata,'EdgeColor','y'); % Draw Rectangle
        r_BG    = rectangle('Position',pos_BG,'EdgeColor','r');   % Draw Rectangle
        r_cdata.LineWidth = 1.5;
        r_BG.LineWidth = 2.5;
        
    % c1) Save the full Picture with marking rectangles
        
        folder = Screens1(1,i).name;
        cd(fullfile('C:\Masterarbeit_Thomas\Analysis\Intermediateresult\Lanex\22.10\Pics_Cam1',folder));
        print(num2str(Screens1(1,i).charge2(j)),'-r200','-dpng');  % Save the image
        
        
    % c2) Generate 3D - Plot
        
        figure(2)
        X = linspace(0, length(cdata_ROI) * x / 1296, length(cdata_ROI));
        Y = linspace(0, length(cdata_ROI) * y /  966, length(cdata_ROI));
        cdata_ROI_3D = cdata_ROI/max(cdata_ROI(:)); % Normalized Intensity
        surf(X,Y,cdata_ROI_3D);
        xlim([0 length(cdata_ROI) * x / 1296]);
        ylim([0 length(cdata_ROI) * y / 966]);
        colormap autumn;
        hold on;
        
        % Save 3D - Image
        
        cd(fullfile('C:\Masterarbeit_Thomas\Analysis\Intermediateresult\Lanex\22.10\Pics_Cam1_Roi',folder));
        print(['3D' num2str(Screens1(1,i).charge2(j))],'-r200','-dpng');  % Save the image
        
    % c3) Beam Profil 
        
        % Image ROI

        hf2 = figure(3);
        set(hf2, 'Position', [20 20 950 900]) % Determine Postion of the figure
        alpha(0)
        subplot(4,4, [5,6,7,9,10,11,13,14,15]) % Show Cut through the gauss in x and y direction
        imagesc(X,Y,cdata_ROI) % Plot 2D Plot
        xlabel('Distance [mm]');
        ylabel('Distance [mm]');
        set(gca,'YDir','reverse');
        
        % search maximum
        
        [C,I] = max(cdata_ROI(:));
        [I_row, I_col] = ind2sub(size(cdata_ROI),I);
        
        subplot(4,4, 1:3);
        plot(X,cdata_ROI(I_row,:),'green','LineWidth',3); % horizontal Beam scan
        xlim([0 length(cdata_ROI) * x / 1296]);
        set(gca,'xTick', [],'xticklabel',[],'yTick', [],'yticklabel',[]); % Scale delete 
        
        subplot(4,4,[8,12,16]);
        plot(cdata_ROI(:,I_col),Y,'red','LineWidth',3); % vertical Beam scan % rotate around 90°
        ylim([0 length(cdata_ROI) * y / 966]);
        colormap jet;
        
        set(gca,'YDir','reverse'); % for rotation around 90°
        set(gca,'xTick', [],'xticklabel',[],'yTick', [],'yticklabel',[]); % Show off scale
        
        figure(gcf); % bring current figure to front

        
        % Save Roi Image
        
        cd(fullfile('C:\Masterarbeit_Thomas\Analysis\Intermediateresult\Lanex\22.10\Pics_Cam1_Roi',folder));
        print( num2str(Screens1(1,i).charge2(j)),'-r200','-dpng');  % Save the image
        
        Screens1(1,i).IntResult.BeamProfil.(['Profil_' num2str(j)]) = 10^(Screens1(1,i).parameter.ndfilter(j)) / ...
        (Screens1(1,i).parameter.exposure_time(j))*100*cdata_ROI(I_row,:);
        Screens1(1,i).IntResult.BeamProfil.(['Profilnorm_' num2str(j)]) = cdata_ROI_3D(I_row,:);
        L_charge(i,j) = {[num2str(Screens1(1,i).charge2(j)),'pC']};
        
    % c4) Charge Density

        % Total Charge Density (rho_ICT [pC/mm^2])
        
         p = 0;  % Declare counter variable p
         z = cdata_ROI(:);
         z1 = mean(mean(cdata_ROI(I_row-1:I_row+1,I_col-1:I_col+1))); % Compute mean of 3x3 Matrix around Maximum        
         for o = 1:length(z)  % loop for peak pixel
             
             if (z(o) >= 1 / exp(3.5) * z1)
                 p = p + 1;
             end
             
         end
         
         z = (x * y) / (1296 * 966);  % Area of one pixel in [mm²]
         
         Screens1(1,i).Result.chargeDensity(j) = Screens1(i).charge(j) / (p * z);
                 
         % Scintillation Charge Density (rho_Scint [pC / mm^2])
         
            % Write all pixel count outside peak (3 sigma) to 0
         
         z2 = cdata_ROI(:);
         z2(find(z2 <= 1 / exp(3.5) * z1)) = 0;
          
            % Clear all zeros
         
         cl = z2 > 0;
         z2 = z2(cl);
         
            % Calculate mean of slope in hopefully linear regime
            
            for k = 1:7
                
                a = (Screens1(i).Result.absValue(k))/(Screens1(i).charge(k));
                
            end
            
            a = mean(a);
            
         Screens1(1,i).Result.scintChargeDensity(j) = Screens1(i).IntResult.attenuation(j) * sum(z2) ...
                                                      / Parameter.exposure(1,j,i)                    ...
                                                      / Screens1(i).IntResult.solidAngle             ... % Signal in Phot / sr
                                                      / a                                            ... % conversion to pC  
                                                      / (p * z);                                    ... % Divide by Area
                                                      
         % Scintillation Peak density ([pC / mm^2])
         
         Screens1(1,i).Result.scintPeakChargeDensity(j) = Screens1(i).IntResult.attenuation(j) * sum(z1) ...
                                                          / Parameter.exposure(1,j,i)                    ...
                                                          / Screens1(i).IntResult.solidAngle             ... % Signal in Phot / sr
                                                          / a                                            ... % conversion to pC  
                                                          / z;                                          ... % Divide by Area
    
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                           %
%d) %  Generate Absolute Scale with error bars  %
    %                                           % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


         
      
    % d1) compute intermediate results
      
        Screens1(1,i).IntResult.solidAngle = (Parameter.aperture/2)^2 * pi / Parameter.distanceFilter^2;   % solid angle of the camera
        Screens1(1,i).IntResult.signal(j) = (sum(cdata_ROI(:))-BG);
        Screens1(1,i).IntResult.attenuation(j) = 10^(Parameter.ndFilter(1,j,i)) / ...
        (Parameter.window * Parameter.objectiv * Parameter.reflexion * Parameter.qeLanex); % attenuation of signal
    

            
         
    % d2) compute absolute scale
        
         Screens1(1,i).Result.absValue(j) = Screens1(1,i).IntResult.signal(j) * ...              % Here comes the analysis ( Heart of code )  
                                            Screens1(1,i).IntResult.attenuation(1,j,i) / ... 
                                            (Parameter.exposure(1,j,i) * Screens1(1,i).IntResult.solidAngle);  
                                       
      end
   end          
       
      % d3) compute error of intermediate result 
      
          % Declare System variable
          
          syms a1;   % Stands for aperture but easier to do differentiation with syms variables
          syms a2;   % Stands for distance but easier to do differentiation with syms variables
          
          % Create System function
          
          f(a1,a2) = (a1 / 2)^2 * pi / a2^2; % Create symfun
          
          % Evaluating the differentiation
        
          b1 = abs(diff(f,a1));  % evaluation of differentiation with respect to aperture
          b2 = abs(diff(f,a2));  % evaluation of differentiation with respect to distance
          
          % Convert to real variable
        
          a1 = Parameter.aperture;
          a2 = Parameter.distanceFilter;
        
          subs(b1);
          subs(b2);
             
          % Use method of linearisation in order to calculate errors ( Taylor
          % exp can be cut at linear term due to size of error )
        
          f = b1 * ErrParameter.errAperture + b2 * ErrParameter.errDistanceFilter;  % calculate the error
          f = f(a1,a2);
          
          for i = 1:6 % Evaluate Error of Solid angle
        
            Screens1(1,i).IntResult.DeltaSolidAngle = double(f);   % convert sym to double
          
          end
          
          for i = 1:6 % Evaluate Sum of standard deviation matrix ^= statistical error
              for j = 1:11
                  
                Screens1(1,i).IntResult.DeltaSignal(j) = sum(sum((Screens1(i).Signal.( ...
                ['ErrSignal' num2str(Screens1(1,i).charge2(j))])(b:b+73+4*j , c-73-4*j:c)))); 
              
              end 
          end
          
          % Declare System variables
          
          syms a1; % Stands for nd_filter
          syms a2; % "  - -   " window
          syms a3; % "  - -   " objectiv
          syms a4; % "  - -   " reflexion
          syms a5; % "  - -   " qe_Lanex
          
          % Create System function
          
          f1(a1,a2,a3,a4,a5) = a1 / (a2 * a3 * a4 * a5); 
          
          % Evaluating the differentiation
              
          b1 = abs(diff(f1,a1));
          b2 = abs(diff(f1,a2));
          b3 = abs(diff(f1,a3));
          b4 = abs(diff(f1,a4));
          b5 = abs(diff(f1,a5));
          
          % Convert to real variable
          
          a2 = Parameter.window;
          a3 = Parameter.objectiv;
          a4 = Parameter.reflexion;
          a5 = Parameter.qeLanex;
          
          for i = 1:6
              for j = 1:11
                  
                  a1(i,j) = Parameter.ndFilter(1,j,i);
                  
               end
           end
          
          % convert to double
          
          a1 = double(a1);
          
          subs(b1); subs(b2); subs(b3); subs(b4); subs(b5);
  
          % Use method of gaussian error propagation in order to calculate errors    
          
          for i = 1:6 % Evaluate Error of attenuation
              for j = 1:11
                  
                 f1 = sqrt((b1 * 10^(Parameter.ndFilter(1,j,i)) / (Parameter.ndFilter(1,j,i)) * ...
                      ErrParameter.sigNdFilter(1,j,i))^2 + (b2 * ErrParameter.sigWindow)^2 + ...  % calculate the error
                      (b3 * ErrParameter.sigObjectiv)^2 + (b4 * ErrParameter.sigReflexion)^2 + (b5 * ErrParameter.sigQeLanex)^2);
          
                 f1 = f1(a1(i,j),a2,a3,a4,a5);
          
                 Screens1(1,i).IntResult.DeltaAttenuation(j) = double(f1);
                 
              end
          end
                                      
    % d4) compute error bars
    
        syms a1; % Stands for signal
        syms a2; % "  -  -  " attenuation
        syms a3; % "  -  -  " solidAngle
        syms a4; % "  -  -  " exposure
        
        f2(a1,a2,a3,a4) = a1 * a2 / (a3 * a4);
        
        b1 = abs(diff(f2,a1));
        b2 = abs(diff(f2,a2));
        b3 = abs(diff(f2,a3));
        
        subs(b1);
        subs(b2);
        subs(b3);
        
        for i = 1:6
            for j = 1:11
                
                a1 = Screens1(1,i).IntResult.signal(j);
                a2 = Screens1(1,i).IntResult.attenuation(j);
                a3 = Screens1(1).IntResult.solidAngle;
                a4 = Parameter.exposure(1,j,i);
                
                % Compute the errorbars 
                
                f2 = sqrt((b1 * Screens1(1,i).IntResult.DeltaSignal(j))^2 + (b3 * Screens1(1,i).IntResult.DeltaSolidAngle)^2) + ...
                     b2 * Screens1(1,i).IntResult.DeltaAttenuation(j);
                        
                f2 = f2(a1,a2,a3,a4); 
                
                Screens1(1,i).Result.DeltaAbsValue(j) = double(f2);
                
            end
        end
        
% e) Generate Plots and dat files
        
    % e1) Plot 1D horizontal Beam Profil of each charge in one Plot
        
        figure(4)
        clf;

        for i = 6:6
           for l=1:11
               
             % Declare variable  
            
             z = Screens1(1,i).IntResult.BeamProfil.(['Profil_' num2str(l)]);
             Z = Screens1(1,i).IntResult.BeamProfil.(['Profilnorm_' num2str(l)]);
             
             % Create X - axis in mm  
             
             X = linspace(0, length(z) * x / 1296, length(z));
             
             % Plot 
             
             subplot(2,1,1);
             plot(X,z); % horizontal Beam scan
             ylabel('Signal [a.u.]');
             hold on;
            
             subplot(2,1,2)
             plot(X,Z);
             ylabel('Normalized Signal');
             xlabel('Length [mm]');
             ylim([0 1.1])
             hold on;
          
            end

           legend(L_charge(i,:));

         end 
       
    % e2) Plot figure in linear scale
    
    for i = 1:6
        
        figure(6);
        X = Screens1(1,i).charge;               % Create X-Vector 
        Y = Screens1(1,i).Result.sumROI;        % Create Y-Vector
        plot(X,Y,'-s');                         % Plot X-Y graphic
        xlabel('Charge [pC]');                  % Label the x-axis
        ylabel('Signal [photons / sr]');        % Label the y-axis
        grid on;                                % Show grid
        hold on;                                % Plot all in one plot   
        
    end

    % Legend
        
        L1(i) = {Screens1(1,i).name};           % Create Legend entries
        
%f) Write the Dat files
    
    %f1) Lanex Screens
    
        % Absolute calib
        
        for k = 1:6
        
            % Generate Matrix to write
        
            A = [Screens1(k).charge; Screens1(k).charge * 6.242 * 10^6 ; ...
                 Screens1(k).Result.chargeDensity; Screens1(k).Result.chargeDensity * 6.242 * 10^6 ; ...
                 Screens1(k).Result.absValue; Screens1(k).Result.DeltaAbsValue] ;
        
            cd('C:\Masterarbeit_Thomas\Analysis\Intermediateresult\Lanex\12.11');
            f =sprintf([Screens1(1,k).name,'Absolutecalib.txt']);
            fid=fopen(f,'wt');
            fprintf(fid,'Total Charge [pC] ' );
            fprintf(fid,'Total number of electrons [] ');
            fprintf(fid,'Charge density [pC / mm²] ');
            fprintf(fid,'Electron density [1 / mm²] ');
            fprintf(fid,'Signal [photons / sr] ');
            fprintf(fid,'Error Signal [photons / sr]\n ' );
            fprintf('\n');
            fprintf(fid,'%1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t % 1.3E \r\n ',A); 
            fclose(fid);
        
        end
        
        % Calulate y error
        
        for k = 1:6
            for l = 1:11
                
                error(k,l) = Screens1(k).Result.DeltaAbsValue(l) / Screens1(k).Result.absValue(l);
                
            end
        end
        
        for k = 1:6
        
            
        % Saturation effects
        
            A = [Screens1(k).Result.chargeDensity; 0.03 * Screens1(k).Result.chargeDensity; ...
                 Screens1(k).Result.scintChargeDensity; error(k) * Screens1(k).Result.scintChargeDensity; ...
                 Screens1(k).Result.scintPeakChargeDensity; error(k) * Screens1(k).Result.scintPeakChargeDensity];
                  
            cd('C:\Masterarbeit_Thomas\Analysis\Intermediateresult\Lanex\12.11');
            f = sprintf([Screens1(1,k).name,'Saturation.txt']);
            fid=fopen(f,'wt');
            fprintf(fid,' Charge density [pC / mm^2] ');
            fprintf(fid,' Error Charge density [pC / mm^2] ');
            fprintf(fid,' Scintillation C. D. [pC / mm^2] ');
            fprintf(fid,' Error Scintillation C. D. [pC / mm^2] ');
            fprintf(fid,' Peak C. D. [pC / mm^2] ');
            fprintf(fid,' Error Peak C. D. [pC / mm^2] \n');
            fprintf('\n');
            fprintf(fid,'%1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \r\n ',A);
            fclose(fid);
            
        end   
        
        % Beamprofil
        
        for k = 1:6
            
            for l = 1:11
                
                z = Screens1(1,k).IntResult.BeamProfil.(['Profil_' num2str(l)]);
            
                % Generate Matrix to write
                
                A(l+1 , 1:length(z)) = (Screens1(1,k).IntResult.BeamProfil.(['Profil_' num2str(l)]))';
            
            end
            
            % Create X - axis in mm  
              
            X = linspace(0, length(z) * x / 1296, length(z));
            
            A(1, 1:length(z)) =  X;
            
            % Save file
            
            f =sprintf([Screens1(1,k).name,'Beamprofil.txt']);
            fid=fopen(f,'wt');
            fprintf(fid,'length [mm]\t' );
            fprintf(fid,'Signal [a. u.]\n');
            fprintf('\n');
            fprintf(fid,'%1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \t %1.3E \r\n ',A);
            fclose(fid);
            
        end
        
    % f2) Parameters of Lanex experiment for cross checking   
        
        f =sprintf('Parameter.txt');
        fid=fopen(f,'wt');
        fprintf(fid,'Parameters of Lanex calibration\n');
        fprintf(fid,'-------------------------------\n');
        fprintf(fid,'\n');
        fprintf(fid,'\n');
        fprintf(fid,'Distance to Filter in front of Cam [mm]\n');
        fprintf(fid,'%1.1f +- %1.1f',Parameter.distanceFilter, ErrParameter.errDistanceFilter);
        fprintf(fid,'\n');
        fprintf(fid,'\n');
        fprintf(fid,'Distance to Camera Objectiv [mm]\n');
        fprintf(fid,'%1.1f +- %1.1f',Parameter.distanceCamera, 1.1 * ErrParameter.errDistanceFilter);
        fprintf(fid,'\n');
        fprintf(fid,'\n');
        fprintf(fid,'Clear Aperture of Filter [mm]\n');
        fprintf(fid,'%1.2f +- %1.2f',Parameter.aperture, ErrParameter.errAperture);
        fprintf(fid,'\n');
        fprintf(fid,'\n');
        fprintf(fid,'Transmission of Window\n');
        fprintf(fid,'%1.3f +- %1.3f',Parameter.window, ErrParameter.sigWindow);
        fprintf(fid,'\n');
        fprintf(fid,'\n');
        fprintf(fid,'Transmission of Objectiv\n');
        fprintf(fid,'%1.3f +- %1.3f',Parameter.objectiv, ErrParameter.sigObjectiv);
        fprintf(fid,'\n');
        fprintf(fid,'\n');
        fprintf(fid,'Quantum efficiency of CCD - Chip\n');
        fprintf(fid,'%1.3f +- %1.3f',Parameter.qeLanex, ErrParameter.sigQeLanex);
        fclose(fid);
        
    % Save new Stuff to Lanexstruc.mat    
     
    cd('C:\Masterarbeit_Thomas\Analysis\Intermediateresult\Lanex');
    save('Lanexstruc.mat','Screens1');
    
% END !!!        