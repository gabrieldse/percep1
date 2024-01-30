clear all ; close all ; clc;

folderPath = 'T:\Etudiants_MEA\!!!§§a.idhem\4A\percep1\sequence_01_simplified';

addpath(folderPath);
%erosion et dilatation dilataion d'abord
%% détourer la balee du reste de l'image
I = imread("0025.bmp");
I = im2double(I);
%La fonction colorfilter permet de garder le Halo d'une couleur selon son
%paramètre H (HSV) et sature le reste (dans notre cas le jaune
I_m = colorfilter(I,[30 70]);
figure(1)
imshow(I);
%on mets les couleurs claires que l'on veut en blanc et le reste en noir.

tab = zeros(1080,1920);

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

figure(2)
imshow(I_m,[]);
figure(3)
imshow(tab,[]);

% OPENING supprimer les petits pixel blancs (errosion, dilatation)

afterOpening = imopen(tab,strel('disk',10));

% CLOSING supprimer la ligne (l'inverse)

afterClosing = imclose(afterOpening,strel('disk',15));
figure(4)
imshowpair(afterOpening,afterClosing,'montage')


%% trouver le centre et le rayon de la balle

%1 garder les contour apparement Canny > Prewitt***
contourc = edge(afterClosing,'Canny');

% Example usage:
% Assuming 'edge_image' is the result of edge detection (e.g., using edge in MATLAB)
edge_image = contourc;

% Specify the range of radii to consider
radius_range = 130:170;

% Perform Hough Transform
[accumulator, centers_x, centers_y, radii] = hough_circle_transform(edge_image, radius_range);

% Display the result (plotting circles on the edge image)
imshow(edge_image, 'InitialMagnification', 'fit');
title('Image with Detected Circles');

hold on;
for i = 1:length(centers_x)
    viscircles([centers_x(i), centers_y(i)], radii(i), 'EdgeColor', 'r', 'LineWidth', 0.5, 'DrawBackgroundCircle', false);
end
hold off;
