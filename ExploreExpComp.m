clear; close all; clc

force = 0:0.1:10;

figure; 

% Add upper range to linear
subplot(2,2,1); hold on; axis square

% threhsold at top
forceActivity_linearSensitize = force; forceActivity_linearSensitize(forceActivity_linearSensitize > 5) = 5;
forceActivity_linearSensitize = forceActivity_linearSensitize*2;
l1 = plot(force, forceActivity_linearSensitize, 'g', 'linewidth',2);

forceActivity_linearExpand = 2*(force/2);
l2 = plot(force, forceActivity_linearExpand, 'r', 'linewidth',2);

forceActivity_linearCompress = force/2;
l3 = plot(force, forceActivity_linearCompress, 'b', 'linewidth',2);

forceActivity_linearStandard = force; forceActivity_linearStandard(forceActivity_linearStandard > 5) = 5;
l4 = plot(force, forceActivity_linearStandard, 'k', 'linewidth',2);

xlabel('Stimulus intensity')
ylabel('Activity')

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
% close all
% could put heat relevant curve here.
otherIntensity = force;
otherActivity_linearStandard = forceActivity_linearStandard;
otherActivity_linearExpand = forceActivity_linearExpand;
otherActivity_linearCompress = forceActivity_linearCompress;
otherActivity_linearSensitize = forceActivity_linearSensitize;

figure; 
% plot different combinations
% Standard x
% 1-1 Standard y - everything is equal (reference on all plots)
standardX = [force zeros(1,length(otherIntensity))];
standardY = [zeros(1,length(force)) otherIntensity ];
standardZ = [forceActivity_linearStandard otherActivity_linearStandard];

% Get hull
standardFaces = convhull(standardX, standardY, standardZ);

% Remove sides based on normal direction - doesnt have a bottom
tempNormals = meshFaceNormals([standardX', standardY', standardZ'], standardFaces);
standardFaces = standardFaces(tempNormals(:,3) > 0,:);

% Plot on all
for i = 1:16
    subplot(4,4,i); hold on; axis equal; view([30 30])
    
    trisurf(standardFaces, standardX, standardY, standardZ-0.1, 'Facecolor', 'k', 'Edgecolor', 'none', 'FaceAlpha', 0.3);
    plot3(force, zeros(1,length(otherIntensity)), forceActivity_linearStandard, 'k', 'linewidth',2);
    plot3(zeros(1,length(force)), otherIntensity, otherActivity_linearStandard, 'k', 'linewidth',2);
    
    xlabel('S1'); ylabel('S2'); zlabel('A')
end

forceActivityArray = [forceActivity_linearStandard', forceActivity_linearExpand', forceActivity_linearCompress', forceActivity_linearSensitize'];
otherActivityArray = [otherActivity_linearStandard', otherActivity_linearExpand', otherActivity_linearCompress', otherActivity_linearSensitize'];

colorArray = [0 0 0; 1 0 0; 0 0 1; 0 1 0];

% Step through X
for i = 1:4
    % Step throuhg y
    for j = 1:4
       % Dont need to do for standard vs. standard
       if i > 1 | j > 1
           subplot(4,4,4*(i-1)+j);
           
           tempX = [force zeros(1,length(otherIntensity))];
           tempY = [zeros(1,length(force)) otherIntensity ];
           tempZ = [forceActivityArray(:,i)' otherActivityArray(:,j)'];
           
           % Convex hull doesn't work if points are coplanar, so expansion can't have only expansion and/or compression
           if i == 1 | i == 4 | j == 1 | j == 4
               tempFaces = convhull(tempX, tempY, tempZ);

               tempNormals = meshFaceNormals([tempX', tempY', tempZ'], tempFaces);
               tempFaces = tempFaces(tempNormals(:,3) > 0,:);
           else
             % Line is coplanar, so just make simple triangle  
             tempFaces = [1 length(force), length(tempX)];
           end
            
           tempCol = (colorArray(i,:) + colorArray(j,:))/2;
           trisurf(tempFaces, tempX, tempY, tempZ, 'Facecolor', tempCol, 'Edgecolor', 'none', 'FaceAlpha', 0.6);
               
           plot3(force, zeros(1,length(otherIntensity)), forceActivityArray(:,i), 'color', colorArray(i,:), 'linewidth',2);
           plot3(zeros(1,length(force)), otherIntensity, otherActivityArray(:,j), 'color', colorArray(j,:), 'linewidth',2);
       end
    end
end

% 1-2 Expanding y
% subplot(5,4,4+2);
% 
% tempFaces = convhull(tempX, tempY, tempZ);
% 
% tempNormals = meshFaceNormals([tempX', tempY', tempZ'], tempFaces);
% tempFaces = tempFaces(tempNormals(:,3) > 0,:);
% 
% 
% xlabel('Stimulus 1 intnsity'); ylabel('Stimulus 2 intensity'); zlabel('Activity')
% 
% % 1-3 Compressing y
% subplot(5,4,4+3);
% tempX = [force zeros(1,length(otherIntensity))];
% tempY = [zeros(1,length(force)) otherIntensity ];
% tempZ = [forceActivity_linearStandard otherActivity_linearCompress];
% 
% tempFaces = convhull(tempX, tempY, tempZ);
% 
% tempNormals = meshFaceNormals([tempX', tempY', tempZ'], tempFaces);
% tempFaces = tempFaces(tempNormals(:,3) > 0,:);
% 
%  trisurf(tempFaces, tempX, tempY, tempZ, 'Facecolor', 'b', 'Edgecolor', 'none', 'FaceAlpha', 0.5);
% 
% plot3(force, zeros(1,length(otherIntensity)), forceActivity_linearStandard, 'k', 'linewidth',2);
% plot3(zeros(1,length(force)), otherIntensity, otherActivity_linearCompress, 'b', 'linewidth',2);
% xlabel('Stimulus 1 intnsity'); ylabel('Stimulus 2 intensity'); zlabel('Activity')
% 
% % Sensitizing y
% subplot(5,4,4+4);
% tempX = [force zeros(1,length(otherIntensity))];
% tempY = [zeros(1,length(force)) otherIntensity ];
% tempZ = [forceActivity_linearStandard otherActivity_linearSensitize];
% 
% tempFaces = convhull(tempX, tempY, tempZ);
% 
% tempNormals = meshFaceNormals([tempX', tempY', tempZ'], tempFaces);
% tempFaces = tempFaces(tempNormals(:,3) > 0,:);
% 
%  trisurf(tempFaces, tempX, tempY, tempZ, 'Facecolor', 'g', 'Edgecolor', 'none', 'FaceAlpha', 0.5);
% 
% plot3(force, zeros(1,length(otherIntensity)), forceActivity_linearStandard, 'k', 'linewidth',2);
% plot3(zeros(1,length(force)), otherIntensity, otherActivity_linearSensitize, 'g', 'linewidth',2);
% xlabel('Stimulus 1 intnsity'); ylabel('Stimulus 2 intensity'); zlabel('Activity')



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