clc
clear
close all
%%
% Rescale factor of Vital was used for Trilogy 
%
%
% vital 
fileNameVital = 'vital_picket.dcm';
fileNameTrilogy= 'trilogy_picket.dcm';
fileNameTrilogyNew = 'trilogy_picket_rescale.dcm';
dicomInfo_vital = dicominfo(fileNameVital);
dicomArray_vital = dicomread(fileNameVital);

% trilogy
dicomInfo_trilogy = dicominfo(fileNameTrilogy);
dicomInfo_trilogy.RescaleIntercept = dicomInfo_vital.RescaleIntercept;
dicomInfo_trilogy.RescaleSlope = dicomInfo_vital.RescaleSlope;
dicomInfo_trilogy.RescaleType= dicomInfo_vital.RescaleType;
metadata = dicomInfo_trilogy;

dicomArray_trilogy = double(dicomread(fileNameTrilogy));
dicomArray_trilogy = abs(dicomArray_trilogy - max(dicomArray_trilogy(:)));
dicomArray_trilogy = dicomArray_trilogy ./max(dicomArray_trilogy (:)).*double(max(dicomArray_vital(:)));
dicomArray_trilogy = uint16(dicomArray_trilogy);

figure,
subplot(2,2,1), imshow(dicomArray_vital, []), title('Vital')
subplot(2,2,2), imshow(dicomArray_trilogy, []), title('Trilogy')
subplot(2,2,3), plot(dicomArray_vital(round(size(dicomArray_vital,1)/2), :), 'k--'),
subplot(2,2,4), plot(dicomArray_trilogy(round(size(dicomArray_trilogy,1)/2), :), 'r--')

dicomwrite(dicomArray_trilogy, fileNameTrilogyNew, metadata, 'CreateMode', 'copy');