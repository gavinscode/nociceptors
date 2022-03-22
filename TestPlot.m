% threshold as mechanical, heat, cold, ph
close all; clc; clear

labels = {'Mechanical (mN)', 'Heat (oC)', 'Cold (oC)', 'Chemical (pH)'};

axLimits = [0 20 0 1; ...
            50 50 10 7];

axDirs = {'normal', 'normal', 'reverse', 'reverse'};

%%% Could colour lines by percentage of nociceptors
cols = lines(5);

% Frog
subplot(2,2,1);
frog_A_thresh = [26.5 39 7 2.8];

frog_C_thresh = [25.3 40 2 2.6];

spider_plot([frog_A_thresh' frog_C_thresh']', 'AxesLabels', labels, 'Color', cols([1 2],:), ...
    'AxesLimits', axLimits, 'AxesPrecision', [0,0,0,0],'linewidth',2,...
    'AxesFontSize', 15, 'LabelFontSize', 15, 'AxesDirection', axDirs);

set(gca, 'LineWidth', 1.5);

legend('A - polymodal','C - polymodal', 'FontSize',15, 'Location', 'northeastoutside')

title('Frog', 'FontSize',20)

% Fish 
subplot(2,2,2);
fish_A_poly = [(8.1+10)/2 28.9 NaN 2.38]; % google value for 1% acetic acid

fish_A_MThermal = [7.8 33.2 NaN NaN];

% Not need to reverse bounds for flipped axes
fish_A_poly_bounds = [ 0.5 20.1 NaN 3;... % Just guessed values for 0.5 and 1.5% acid bounds
                        69.6 37 NaN 1.8];
                    
fish_A_MThermal_bounds = [0.5 22 NaN NaN; ...
                            24.5 40 NaN NaN];

spider_plot([fish_A_poly' fish_A_MThermal']', 'AxesLabels', labels, 'Color', cols([1 2],:), ...
    'AxesLimits', axLimits, 'AxesPrecision', [0,0,0,0],'linewidth',2,...
    'AxesFontSize', 15, 'LabelFontSize', 15, 'AxesDirection', axDirs);

set(gca, 'LineWidth', 1.5);

legend('A - polymodal','C - MH', 'FontSize',15, 'Location', 'northeastoutside')

title('Trout', 'FontSize',20)

% Try some error bars
subplot(2,2,4);
axLimitsTemp = [[0; 100], axLimits(:,2:end)];

spider_plot([fish_A_poly' fish_A_MThermal' fish_A_poly_bounds' fish_A_MThermal_bounds']', ... 
    'AxesLabels', labels,  'Color', cols([1 2 1 1 2 2],:), 'LineStyle', {'-', '-', ':', ':', ':', ':'}, ...
    'Marker', {'o', 'o', 'none', 'none', 'none', 'none'}, 'FillOption', {'off', 'off', 'on', 'off', 'on', 'on'}, ...
    'AxesLimits', axLimitsTemp, 'AxesPrecision', [0,0,0,0],'linewidth',2,  ...
    'AxesFontSize', 15, 'LabelFontSize', 15, 'AxesDirection', axDirs);
  
set(gca, 'LineWidth', 1.5);

legend('A - polymodal','C - MH', 'FontSize',15, 'Location', 'northeastoutside')

title('Trout - with ranges', 'FontSize',20)

% Chicken
subplot(2,2,3);

axLimitsTemp = [[0; 250] axLimits(:, 2:end)];
        
chicken_A_MThermal_leg = [11.7 49 NaN NaN];

chicken_C_MThermal_leg = [14.7 49.4 NaN NaN];

chicken_C_Mthermal_beak = [245 44.5 NaN NaN];

chicken_C_Mechanical_break = [245 NaN NaN NaN];

spider_plot([chicken_A_MThermal_leg' chicken_C_MThermal_leg' chicken_C_Mthermal_beak' chicken_C_Mechanical_break']', ... 
    'AxesLabels', labels,  'Color', cols([1 2 3 4],:), ...
    'AxesLimits', axLimitsTemp, 'AxesPrecision', [0,0,0,0],'linewidth',2,  ...
    'AxesFontSize', 15, 'LabelFontSize', 15, 'AxesDirection', axDirs);
  
set(gca, 'LineWidth', 1.5);

legend('A - MH (leg)','C - MH (leg)', 'C - MH (beak)', 'C - M (beak)', 'FontSize',15, 'Location', 'northeastoutside')

title('Chicken', 'FontSize', 20)

% Combined
figure

axLimitsTemp = [[0; 150] axLimits(:, 2:end)];

%%% could do weighted mean given proprtions
spider_plot([nanmean([fish_A_poly' fish_A_MThermal']')' ...
    nanmean([frog_A_thresh' frog_C_thresh']')' ...
    nanmean([chicken_A_MThermal_leg' chicken_C_MThermal_leg' chicken_C_Mthermal_beak' chicken_C_Mechanical_break']')']',...
    'AxesLabels', labels, 'Color', cols([1 2 3],:), ...
    'AxesLimits', axLimitsTemp, 'AxesPrecision', [0,0,0,0],'linewidth',2, ...
    'AxesFontSize', 15, 'LabelFontSize', 15, 'AxesDirection', axDirs);

set(gca, 'LineWidth', 1.5);

legend('Trout','Frog', 'Chicken', 'FontSize',15, 'Location', 'northeastoutside')


                    