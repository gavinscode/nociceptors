clear; close all; clc

force = 0:0.1:10;

figure; 

% Add upper range to linear
subplot(2,2,1); hold on; axis square

% threhsold at top
temp = force; temp(temp > 5) = 5;
l1 = plot(force, temp*2, 'g', 'linewidth',2);

l2 = plot(force, 2*(force/2), 'r', 'linewidth',2);

l3 = plot(force, force/2, 'b', 'linewidth',2);

temp = force; temp(temp > 5) = 5;
l4 = plot(force, temp, 'k', 'linewidth',2);

xlabel('Stimulus intensity')
ylabel('Firing rate')

ylim([0 10]); xlim([0 10])

title('Linear fns - gain upper range')

legend([l4 l1 l2 l3],  'Standard', 'Sensitisation', 'Expansion', 'Compression')



% Add upper range to sigmoidal 
subplot(2,2,2); hold on; axis square

plot(force, 20*(1./(1+exp(-force)) - 0.5), 'g', 'linewidth',2);

plot(force, 20*(1./(1+exp(-force/2)) - 0.5), 'r', 'linewidth',2);

plot(force, 10*(1./(1+exp(-force/2)) - 0.5), 'b', 'linewidth',2);

plot(force, 10*(1./(1+exp(-force)) - 0.5), 'k', 'linewidth',2);

xlabel('Stimulus intensity')
ylabel('Activity')

ylim([0 10]); xlim([0 10])

title('Sigmoid functions - gain upper range')



% Add lower range to linear
subplot(2,2,3); hold on; axis square

% Therhsold at bottom
temp = force; temp(temp < 5) = 5;
l1 = plot(force, 2*(temp-5), 'g', 'linewidth',2);

l2 = plot(force, 2*(force/2), 'r', 'linewidth',2);

l3 = plot(force, force/2, 'b', 'linewidth',2);

temp = force; temp(temp < 5) = 5;
l4 = plot(force, temp-5, 'k', 'linewidth',2);

xlabel('Stimulus intensity')
ylabel('Activity')

ylim([0 10]); xlim([0 10])

title('Linear fns - gain lower range')



% Add lower range to sigmoidal
subplot(2,2,4); hold on; axis square

plot(force, 20*(1./(1+exp(-(force-5))) - 0.5), 'g', 'linewidth',2);

plot(force, 20*(1./(1+exp(-(force)/2)) - 0.5), 'r', 'linewidth',2);

plot(force, 10*(1./(1+exp(-(force)/2)) - 0.5), 'b', 'linewidth',2);

plot(force, 10*(1./(1+exp(-(force-5))) - 0.5), 'k', 'linewidth',2);

xlabel('Stimulus intensity')
ylabel('Activity')

ylim([0 10]); xlim([0 10])

title('Sigmoid functions - gain lower range')

%% Explore two stimuli - w planes

figure; hold on; axis equal;
surf = fit([0 0; 1 0; 0 1;], [0 1 1]', 'poly11');
plot(surf)

line([0 1], [0 0], [0 1], 'color', 'm')
line([0 0], [0 1], [0 1], 'color', 'm')
% line([1 0], [1 1], [0 1], 'color', 'm')

line([0 1], [0 0], [0 1], 'color', 'k')
line([0 2], [0 0], [0 1], 'color', 'b')
line([0 1], [0 0], [0 2], 'color', 'g')
line([0 2], [0 0], [0 2], 'color', 'r')

xlabel('stim 1'); ylabel('stim 2'); zlabel('activity')

%% Explore two stimuli - with sigmoids, didn't work so well

% syms x y a b c
% eqn = y == a*(1/(1+exp(-(x-c)/b))-0.5)
% solve(eqn, x)
% c - b*log(1/(y/a + 1/2) - 1)
activity = 0:0.5:10;

figure;
forceStandard = -log(1./(activity/10+0.5)-1); 
forceExpand = -2*log(1./(activity/20+0.5)-1); 
forceSensitise = -log(1./(activity/20+0.5) - 1);
forceCompress = -2*log(1./(activity/10+0.5) - 1);

forceStandard(forceStandard ~= real(forceStandard)) = NaN;
forceExpand(forceExpand ~= real(forceExpand)) = NaN;
forceSensitise(forceSensitise ~= real(forceSensitise)) = NaN;
forceCompress(forceCompress ~= real(forceCompress)) = NaN;

subplot(2,2,1); hold on
plot(forceStandard, activity, 'ko', 'linewidth',2);

plot(forceExpand, activity, 'ro', 'linewidth',2);

plot(forceSensitise, activity, 'go', 'linewidth',2);

plot(forceCompress, activity, 'bo', 'linewidth',2);

% Make alternate modality
forceStandard_Stim2 = 40-log(1./(activity/5+0.5)-1); 
forceExpand_Stim2 = 40-2*log(1./(activity/10+0.5)-1); 
forceSensitise_Stim2 = 40-log(1./(activity/10+0.5) - 1);
forceCompress_Stim2 = 40-2*log(1./(activity/5+0.5) - 1);

forceStandard_Stim2(forceStandard_Stim2 ~= real(forceStandard_Stim2)) = NaN;
forceExpand_Stim2(forceExpand_Stim2 ~= real(forceExpand_Stim2)) = NaN;
forceSensitise_Stim2(forceSensitise_Stim2 ~= real(forceSensitise_Stim2)) = NaN;
forceCompress_Stim2(forceCompress_Stim2 ~= real(forceCompress_Stim2)) = NaN;

subplot(2,2,2); hold on
plot(forceStandard_Stim2, activity, 'ko', 'linewidth',2);

plot(forceExpand_Stim2, activity, 'ro', 'linewidth',2);

plot(forceSensitise_Stim2, activity, 'go', 'linewidth',2);

plot(forceCompress_Stim2, activity, 'bo', 'linewidth',2);



subplot(2,2,3); hold on

plot(forceStandard, forceExpand, 'r-o', 'linewidth',2)

plot(forceStandard, forceSensitise, 'g-o', 'linewidth',2)

plot(forceStandard, forceCompress, 'b-o', 'linewidth',2)

plot(forceStandard, forceStandard, 'k-o', 'linewidth',2)



subplot(2,2,4); hold on

plot(forceStandard, forceExpand_Stim2, 'r-o', 'linewidth',2)

plot(forceStandard, forceSensitise_Stim2, 'g-o', 'linewidth',2)

plot(forceStandard, forceCompress_Stim2, 'b-o', 'linewidth',2)

plot(forceStandard, forceStandard_Stim2, 'k-o', 'linewidth',2)

%%% Shift sections below to other file
%% To test from adult vs. juvenile force curve
juvenile = [5.4299, -0.1123;
19.6833, 0.0709;
40.0452, 0.5734;
99.7738, 3.1282;
149.6606, 4.5438;
199.8869, 4.7298;
300.0000, 6.0353];

adult = [-0.5090, 0.0238;
4.4118, 0.2633;
9.8416, 0.4117;
19.6833, 0.8223;
39.7059, 2.0762;
99.6041, 5.2003;
149.6606, 7.1168;
199.8869, 8.0770;
300.3394, 9.8152];

juvenile(juvenile < 0) = 0;
adult(adult < 0) = 0;


figure; hold on
h1 = plot(juvenile(:,1), juvenile(:,2), 'k', 'linewidth',2);
h2 = plot(adult(:,1), adult(:,2), 'm', 'linewidth',2);

% Try fitting
sigmoidFit = 'a*(1/(1+exp(-x/b))-0.5)';

fittedJuvenile = fit(juvenile(:,1), juvenile(:,2), sigmoidFit, 'startPoint', [15 100])

fittedAdult = fit(adult(:,1), adult(:,2), sigmoidFit, 'startPoint', [15 100])

h3 = plot(fittedJuvenile);
h4 = plot(fittedAdult);

set(h3, 'color', 'k', 'Linewidth', 2', 'linestyle', ':')
set(h4, 'color', 'm', 'Linewidth', 2', 'linestyle', ':')

compressionRatio = fittedAdult.a/fittedJuvenile.a;
stretchRatio = fittedAdult.b/fittedJuvenile.b;
meanRatio = (compressionRatio + stretchRatio)/2;

h5 = plot(0:500, compressionRatio*fittedJuvenile.a*(1./(1+exp(-(0:500)/(fittedJuvenile.b*compressionRatio))) - 0.5), 'r', 'linewidth',2);

h6 = plot(0:500, compressionRatio*fittedJuvenile.a*(1./(1+exp(-(0:500)/(fittedJuvenile.b))) - 0.5), 'g', 'linewidth',2);

h7 = plot(0:500, fittedJuvenile.a*(1./(1+exp(-(0:500)/(fittedJuvenile.b*stretchRatio))) - 0.5), 'b', 'linewidth',2);

legend([h1 h3 h2 h4 h5 h6 h7], 'Juvenile', 'Juvenile fitted', 'Adult', 'Adult fitted', 'Equiv. Expansion', 'Compression only', 'Stretch only')

ylabel('Firing rate')
xlabel('Force (mN)')

ylim([0 12]); xlim([0 500])

title('Adult and Juvenile AM nociceptors')

%% Test by receptor type;

CMH = [11.7256, 0.7371;
23.4623, 0.8298;
46.4159, 1.3341;
92.8755, 1.8680;
185.8385, 2.6371;
371.8522, 3.2004;
744.0548, 3.4107];

CM = [11.7256, 0.3253;
23.4623, 0.6239;
46.9467, 1.5695;
93.9376, 2.6916;
185.8385, 4.6371;
371.8522, 6.8474;
752.5636, 7.3813];

AM = [11.9512, 0.2253;
23.9280, 0.6348;
47.9074, 1.4949;
95.9177, 3.3584;
192.0413, 5.9386;
384.4948, 5.2423];

%%% Scaling to mn is roughly 0.2, but get correct from supplemental figure
CMH(:,1) = CMH(:,1)/5;
CM(:,1) = CM(:,1)/5;
AM(:,1) = AM(:,1)/5;

figure; subplot(1,2,1); hold on;
h1 = plot(CMH(:,1), CMH(:,2), 'k', 'linewidth',2);
h2 = plot(CM(:,1), CM(:,2), 'm', 'linewidth',2);

fittedCMH = fit(CMH(:,1), CMH(:,2), sigmoidFit, 'startPoint', [15 100])

fittedCM = fit(CM(:,1), CM(:,2), sigmoidFit, 'startPoint', [15 100])

fittedAM = fit(AM(:,1), AM(:,2), sigmoidFit, 'startPoint', [15 100])

h3 = plot(fittedCMH);
h4 = plot(fittedCM);

set(h3, 'color', 'k', 'Linewidth', 2', 'linestyle', ':')
set(h4, 'color', 'm', 'Linewidth', 2', 'linestyle', ':')

ylim([0 8]); xlim([0 150])

compressionRatio = fittedCM.a/fittedCMH.a;
stretchRatio = fittedCM.b/fittedCMH.b;
meanRatio = (compressionRatio + stretchRatio)/2;

h5 = plot(0:300, compressionRatio*fittedCMH.a*(1./(1+exp(-(0:300)/(fittedCMH.b*compressionRatio))) - 0.5), 'r', 'linewidth',2);

h6 = plot(0:300, compressionRatio*fittedCMH.a*(1./(1+exp(-(0:300)/(fittedCMH.b))) - 0.5), 'g', 'linewidth',2);

h7 = plot(0:300, fittedCMH.a*(1./(1+exp(-(0:300)/(fittedCMH.b*stretchRatio))) - 0.5), 'b', 'linewidth',2);

legend([h1 h3 h2 h4 h5 h6 h7], 'CMH', 'CMH fitted', 'CM', 'CM fitted', 'Equiv. Expansion', 'Compression only', 'Stretch only')

ylabel('Firing rate')
xlabel('Force (mN)')

title('CMH and CM nociceptors')

subplot(1,2,2); hold on;
h1 = plot(CMH(:,1), CMH(:,2), 'k', 'linewidth',2);
h2 = plot(AM(:,1), AM(:,2), 'c', 'linewidth',2);

h3 = plot(fittedCMH);
h4 = plot(fittedAM);

set(h3, 'color', 'k', 'Linewidth', 2', 'linestyle', ':')
set(h4, 'color', 'c', 'Linewidth', 2', 'linestyle', ':')

compressionRatio = fittedAM.a/fittedCMH.a;
stretchRatio = fittedAM.b/fittedCMH.b;
meanRatio = (compressionRatio + stretchRatio)/2;

h5 = plot(0:300, compressionRatio*fittedCMH.a*(1./(1+exp(-(0:300)/(fittedCMH.b*compressionRatio))) - 0.5), 'r', 'linewidth',2);

h6 = plot(0:300, compressionRatio*fittedCMH.a*(1./(1+exp(-(0:300)/(fittedCMH.b))) - 0.5), 'g', 'linewidth',2);

h7 = plot(0:300, fittedCMH.a*(1./(1+exp(-(0:300)/(fittedCMH.b*stretchRatio))) - 0.5), 'b', 'linewidth',2);

legend([h1 h3 h2 h4 h5 h6 h7], 'CMH', 'CMH fitted', 'AM', 'AM fitted', 'Equiv. Expansion', 'Compression only', 'Stretch only')

ylim([0 8]); xlim([0 150])
ylabel('Firing rate')
xlabel('Force (mN)')
title('CMH and AM nociceptors')
%% Summary
adultRatio = (fittedAdult.a/fittedJuvenile.a)/(fittedAdult.b/fittedJuvenile.b)

CMRatio = fittedCM.a/fittedCMH.a/(fittedCM.b/fittedCMH.b)

AMRatio = fittedAM.a/fittedCMH.a/(fittedAM.b/fittedCMH.b)