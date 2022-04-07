clear; close all; clc


cd('/Users/gavintaylor/Documents/Matlab/Git_versioned_April_27/nociceptors/Data')

%%% Not fully implemented
useLinear = 0;

% Load mechanical data
CMechanical_ChickenLeg = readmatrix('Chicken Leg C mechanical.csv');

AMechanical_ChickenLeg = readmatrix('Chicken Leg Adelta mechanical.csv');

MechanicalHighThreshold_ChickenBeak = readmatrix('Chicken Beak Mechanical High Threshold.csv');

% Convert grams to newtons
CMechanical_ChickenLeg(:,1) = CMechanical_ChickenLeg(:,1)*9.81;

AMechanical_ChickenLeg(:,1) = AMechanical_ChickenLeg(:,1)*9.81;

MechanicalHighThreshold_ChickenBeak(:,1) = MechanicalHighThreshold_ChickenBeak(:,1)*9.81;

% Load thermal data
CThermal_ChickenLeg = readmatrix('Chicken Leg C Heat.csv');
AThermal_ChickenLeg = readmatrix('Chicken Leg ADelta Heat.csv');
temp = readmatrix('Chicken Beak CMH Heat Part 1.csv');
CMHThermal_ChickenBeak = readmatrix('Chicken Beak CMH Heat Part 2.csv');
CMHThermal_ChickenBeak = [CMHThermal_ChickenBeak' temp']';

% Convert to spikes/s (from num in 10s)
CMechanical_ChickenLeg(:,2) = CMechanical_ChickenLeg(:,2)/10;
AMechanical_ChickenLeg(:,2) = AMechanical_ChickenLeg(:,2)/10;
MechanicalHighThreshold_ChickenBeak(:,2) = MechanicalHighThreshold_ChickenBeak(:,2)/10;
CThermal_ChickenLeg(:,2) = CThermal_ChickenLeg(:,2)/10;
AThermal_ChickenLeg(:,2) = AThermal_ChickenLeg(:,2)/10;
CMHThermal_ChickenBeak(:,2) = CMHThermal_ChickenBeak(:,2)/10;


% Fit and plot mechanical data
figure; 
subplot(2,2,1); hold on

h1 = plot(CMechanical_ChickenLeg(:,1), CMechanical_ChickenLeg(:,2), 'ko');

h2 = plot(AMechanical_ChickenLeg(:,1), AMechanical_ChickenLeg(:,2), 'mo');

h3 = plot(MechanicalHighThreshold_ChickenBeak(:,1), MechanicalHighThreshold_ChickenBeak(:,2), 'co');

if useLinear
    fittedCMechLeg = fit(CMechanical_ChickenLeg(:,1), CMechanical_ChickenLeg(:,2), 'a*x+b')

    fittedAMechLeg = fit(AMechanical_ChickenLeg(:,1), AMechanical_ChickenLeg(:,2), 'a*x+b')

    fittedMechHighBeak = fit(MechanicalHighThreshold_ChickenBeak(:,1), MechanicalHighThreshold_ChickenBeak(:,2), 'a*x+b')
else
    sigmoidFit = 'a*(1/(1+exp(-(x-c)/b))-0.5)';

    fittedCMechLeg = fit(CMechanical_ChickenLeg(:,1), CMechanical_ChickenLeg(:,2), sigmoidFit, 'startPoint', [15 100 0], 'lower', [1 50 0])

    fittedAMechLeg = fit(AMechanical_ChickenLeg(:,1), AMechanical_ChickenLeg(:,2), sigmoidFit, 'startPoint', [15 100 0], 'lower', [1 50 0])

    fittedMechHighBeak = fit(MechanicalHighThreshold_ChickenBeak(:,1), MechanicalHighThreshold_ChickenBeak(:,2), sigmoidFit, 'startPoint', [15 100 0], 'lower', [1 50 0])
end

h1f = plot(fittedCMechLeg);
h2f = plot(fittedAMechLeg);
h3f = plot(fittedMechHighBeak);

set(h1f, 'color', 'k', 'Linewidth', 2', 'linestyle', ':')
set(h2f, 'color', 'm', 'Linewidth', 2', 'linestyle', ':')
set(h3f, 'color', 'c', 'Linewidth', 2', 'linestyle', ':')

sensitisationRatioMech = fittedMechHighBeak.a/fittedCMechLeg.a;
compressionRatioMech = fittedMechHighBeak.b/fittedCMechLeg.b;
if useLinear
    hE = plot(0:1000, sensitisationRatioMech*fittedCMechLeg.a*(0:1000)+fittedMechHighBeak.b, 'r', 'linewidth',2);

else
    hE = plot(0:1000, sensitisationRatioMech*fittedCMechLeg.a*(1./(1+exp(-((0:1000)-fittedMechHighBeak.c)/(fittedCMechLeg.b*sensitisationRatioMech))) - 0.5), 'r', 'linewidth',2);

    hS = plot(0:1000, sensitisationRatioMech*fittedCMechLeg.a*(1./(1+exp(-((0:1000)-fittedMechHighBeak.c)/(fittedCMechLeg.b))) - 0.5), 'g', 'linewidth',2);

    hC = plot(0:1000, fittedCMechLeg.a*(1./(1+exp(-((0:1000)-fittedMechHighBeak.c)/(fittedCMechLeg.b*compressionRatioMech))) - 0.5), 'b', 'linewidth',2);
end
legend([h1 h1f h2 h2f h3 h3f hE hS hC], 'Leg CMH', 'Leg CMH Fitted', 'Leg AMH', 'Leg AMH Fitted', 'Beak M-High', 'Beak M-High Fitted',...
    'Equiv. Expansion', 'Sensitisation only', 'Compression only')

ylabel('Firing rate')
xlabel('Force (mN)')

ylim([0 35]); xlim([0 1000])



% Fit and plot thermal data
subplot(2,2,2); hold on
h1 = plot(CThermal_ChickenLeg(:,1), CThermal_ChickenLeg(:,2), 'ko');

h2 = plot(AThermal_ChickenLeg(:,1), AThermal_ChickenLeg(:,2), 'mo');

h3 = plot(CMHThermal_ChickenBeak(:,1), CMHThermal_ChickenBeak(:,2), 'co');

fittedCThermalLeg = fit(CThermal_ChickenLeg(:,1), CThermal_ChickenLeg(:,2), sigmoidFit, 'startPoint', [5 1 40], 'lower', [1 1 0], 'upper', [100 10 50])

fittedAThermalLeg = fit(AThermal_ChickenLeg(:,1), AThermal_ChickenLeg(:,2), sigmoidFit, 'startPoint', [5 1 40], 'lower', [1 1 0], 'upper', [100 100 50])

fittedThermalBeak = fit(CMHThermal_ChickenBeak(:,1), CMHThermal_ChickenBeak(:,2), sigmoidFit, 'startPoint', [5 1 40], 'lower', [1 1 0], 'upper', [100 50 50])

h1f = plot(fittedCThermalLeg);
h2f = plot(fittedAThermalLeg);
h3f = plot(fittedThermalBeak);

set(h1f, 'color', 'k', 'Linewidth', 2', 'linestyle', '-.')
set(h2f, 'color', 'm', 'Linewidth', 2', 'linestyle', '-.')
set(h3f, 'color', 'c', 'Linewidth', 2', 'linestyle', '-.')

sensitisationRatioThermal = fittedThermalBeak.a/fittedCThermalLeg.a;
compressionRatioThermal = fittedThermalBeak.b/fittedCThermalLeg.b;

hE = plot(0:5000, sensitisationRatioThermal*fittedCThermalLeg.a*(1./(1+exp(-((0:5000)-fittedThermalBeak.c)/(fittedCThermalLeg.b*sensitisationRatioThermal))) - 0.5), 'r', 'linewidth',2);

hS = plot(0:5000, sensitisationRatioThermal*fittedCThermalLeg.a*(1./(1+exp(-((0:5000)-fittedThermalBeak.c)/(fittedCThermalLeg.b))) - 0.5), 'g', 'linewidth',2);

hC = plot(0:5000, fittedCThermalLeg.a*(1./(1+exp(-((0:5000)-fittedThermalBeak.c)/(fittedCThermalLeg.b*compressionRatioThermal))) - 0.5), 'b', 'linewidth',2);

legend([h1 h1f h2 h2f h3 h3f hE hS hC], 'Leg CMH', 'Leg CMH Fitted', 'Leg AMH', 'Leg AMH Fitted', 'Beak CMH', 'Beak CMH Fitted',...
    'Equiv. Expansion', 'Sensitisation only', 'Compression only')

ylabel('Firing rate')
xlabel('Heat (oC)')

ylim([0 35]); xlim([35 70])

%% Compare CMH Foot thermal and mech

%%% Not sure this is meaningfull....

subplot(2,2,3); hold on
xlim([0 1000]); ylim([0 20])

fittedCThermalLeg.a = fittedCThermalLeg.a*2.5;

h1f = plot(fittedCMechLeg);
h2f = plot(fittedCThermalLeg);

set(h1f, 'color', 'k', 'Linewidth', 2', 'linestyle', ':')
set(h2f, 'color', 'k', 'Linewidth', 2', 'linestyle', '-.')

sensitisationRatioFoot = fittedCThermalLeg.a/fittedCMechLeg.a;
compressionRatioFoot = fittedCThermalLeg.b/fittedCMechLeg.b; 

hE = plot(0:5000, sensitisationRatioFoot*fittedCMechLeg.a*(1./(1+exp(-((0:5000)-fittedCThermalLeg.c)/(fittedCMechLeg.b*sensitisationRatioFoot))) - 0.5), 'r', 'linewidth',2);

hS = plot(0:5000, sensitisationRatioFoot*fittedCMechLeg.a*(1./(1+exp(-((0:5000)-fittedCThermalLeg.c)/(fittedCMechLeg.b))) - 0.5), 'g', 'linewidth',2);

hC = plot(0:5000, fittedCMechLeg.a*(1./(1+exp(-((0:5000)-fittedCThermalLeg.c)/(fittedCMechLeg.b*compressionRatioFoot))) - 0.5), 'b', 'linewidth',2);

legend([h1f h2f hE hS hC], 'Leg CMH Mech Fitted', 'Leg CMH Thermal Fitted', ...
    'Equiv. Contraction', 'Desensitization only', 'Decompression only')

title('Meaningfull?')

subplot(2,2,4); hold on
xlim([0 1000]); ylim([0 35])

h1f = plot(fittedCMechLeg);
h2f = plot(fittedCThermalLeg);

set(h1f, 'color', 'k', 'Linewidth', 2', 'linestyle', ':')
set(h2f, 'color', 'k', 'Linewidth', 2', 'linestyle', '-.')

h3f = plot(fittedMechHighBeak);
h4f = plot(fittedThermalBeak);

set(h3f, 'color', 'c', 'Linewidth', 2', 'linestyle', ':')
set(h4f, 'color', 'c', 'Linewidth', 2', 'linestyle', '-.')

hE = plot(0:5000, sensitisationRatioFoot*fittedMechHighBeak.a*(1./(1+exp(-((0:5000)-fittedThermalBeak.c)/(fittedMechHighBeak.b*sensitisationRatioFoot))) - 0.5), 'r', 'linewidth',2);

hS = plot(0:5000, sensitisationRatioFoot*fittedMechHighBeak.a*(1./(1+exp(-((0:5000)-fittedThermalBeak.c)/(fittedMechHighBeak.b))) - 0.5), 'g', 'linewidth',2);

hC = plot(0:5000, fittedMechHighBeak.a*(1./(1+exp(-((0:5000)-fittedThermalBeak.c)/(fittedMechHighBeak.b*compressionRatioFoot))) - 0.5), 'b', 'linewidth',2);

legend([h1f h2f h3f h4f hE hS hC], 'Leg CMH Mech Fitted', 'Leg CMH Thermal Fitted', 'Beak M-high fitted', 'Beak CMH Thermal fitted', ...
    'Equiv. Contraction', 'Desensitization only', 'Decompression only')
