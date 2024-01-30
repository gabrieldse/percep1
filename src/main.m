%% Import file
clear all ; close all ; clc;
folderPath = 'T:\Etudiants_MEA\!!!§§a.idhem\4A\percep1\sequence_01_simplified\'; addpath(folderPath);

fileList = dir(fullfile(folderPath, '*.bmp'));

for fileIndex = 1:length(fileList) %Loop over all .bmp files in the folder path
    
    I = imread(fileList(fileIndex).name); %load the image
    
    
    %% détourer la balee du reste de l'image
    %I2 = im2double(I);
    
    %La fonction colorfilter permet de garder le Halo d'une couleur selon son
    %paramètre H (HSV) et sature le reste (dans notre cas le jaune)
    start_time = tic;  % Record the start time
    I_m = colorfilter(I,[30 70]);
    tab = zeros(1080,1920); %on mets les couleurs claires que l'on veut en blanc et le reste en noir.
    coef = 0;
    for k = 1:3
        for i = 1:1080
            for j = 1:1920
                if I_m(i,j,k) <= coef
                    tab(i,j)=0;
                else
                    tab(i,j)=1;
                end
            end
        end
    end
    
    
    %% Improve the ball selection
    afterOpening = imopen(tab,strel('disk',10)); % OPENING supprimer les petits pixel blancs (errosion, dilatation)
    afterClosing = imclose(afterOpening,strel('disk',15)); % CLOSING supprimer la ligne (l'inverse)
    
    
    %% trouver le centre et le rayon de la balle
    
    %1 garder les contour apparement Canny > Prewitt***
    contourc = edge(afterClosing,'Canny',"nothinning");
    end_time = toc(start_time);  % Record the end time
    fprintf('Contour execution time: %.4f seconds\n', end_time);
    
    [accumulator, centers_x, centers_y, radii] = hough_circle_transform(contourc, 140:160);
    
   
    %% See all the steps on the image treatment
    start_time2 = tic;  % Record the start time
    % figure(1); imshow(I_m); % after select only yellow
    % figure(2); imshow(tab,[]); % black and white
    % figure(3); imshow(afterOpening)
    % figure(4); imshow(afterClosing)
    % figure(5); imshow(contourc)
    % figure(6); imshow(contourc)
    figure(6);
    imshow(contourc)
    hold on
    
    % Assuming you have defined centers_x, centers_y, and radii somewhere before
    center = [centers_x, centers_y];
    viscircles(center, radii, 'EdgeColor', 'r');
    
    txt = ['  (R,x,y) : (  ',num2str(centers_x),'  ,  ',num2str(centers_y),'  ,  ', num2str(radii),'  )'];
    
    % Adjust the position for text to avoid overlapping with the circle
    % Idealy in the same position for the video
    text(817, 1012, txt, 'Color', 'White', 'FontSize', 10)
    
    % Plot the red plus sign ('+')
    plot(centers_x, centers_y, 'r+', 'MarkerSize', 10, 'LineWidth', 2)
    
    hold off
    end_time2 = toc(start_time2);  % Record the end time
    fprintf('Plot execution time: %.4f seconds\n', end_time2);
    
    filename = sprintf('%sfigure_%d.png',folderPath, fileIndex);
    saveas(gcf, filename);
    close(gcf);
    
    
end

%% Create a VideoWriter object
video_filename = 'output_video.mp4';
videoObj = VideoWriter(video_filename, 'Motion JPEG AVI');
open(videoObj);

% Read each saved image and write it to the video
for loop_iteration = 1:fileIndex
    filename = sprintf('%sfigure_%d.png', folderPath, loop_iteration);
    img = imread(filename);
    writeVideo(videoObj, img);
end

% Close the video file
close(videoObj);

% Intervale 100:200
% Contour execution time: 1.3449 seconds
% Hough execution time: ***17.1324 seconds***
% Circle information: C(723,364) R= 152
% Plot execution time: 5.1954 seconds

% Interavle 140:160
% Contour execution time: 1.2968 seconds
% Hough execution time: ***2.8208 seconds***
% Circle information: C(723,364) R= 152
% Plot execution time: 4.1649 seconds


