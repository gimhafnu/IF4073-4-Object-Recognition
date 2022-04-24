I = imread("..\image\plate_1_.jpg"); % The plate number image

% Readies folder for segmented characters from the plate number image
if (isfolder("..\image\temporary\temp_segmented"))
    rmdir ..\image\temporary\temp_segmented s;
end

% Segmented characters from the plate number image, and save it
[seg_files] = segment_image(I,"..\image\temporary\temp_segmented");
%disp(seg_files)

% Readies the font to be "segmented"
% % It's mostly just so the plate and the fonts get the same treatment
% % % first before they're compared
fonts_folder = "..\image\templates\fonts\";

fonts = ["A","B","C","D","E","F","G","H","I","J","K","L","M", ...
    "N","O","P","Q","R","S","T","U","V","W","X","Y","Z", ...
    "0","1","2","3","4","5","6","7","8","9"];

file_type = ".png";

% Actually do the "segmentation"s here
for i=1:size(fonts,2)
    full_path = fonts_folder + fonts(i) + file_type;
    %disp(full_path);
    I = imread(full_path);
    [segs_fonts] = segment_image(I, "..\image\templates\fonts_seg", fonts(i), false);
    %disp(segs_fonts);
    I_BW = imbinarize(rgb2gray(I));
    I_BW_skel = bwmorph(I_BW,'skel',inf); % Makes the skeleton
    %figure, imshow(I_BW_skel);
end

% Readies a list of files to be compared (the segmented images from the
% plate number
segs_folder = '..\image\temporary\temp_segmented';

filePattern = fullfile(segs_folder, '*.png'); 
theFiles = dir(filePattern);

detected = [];
detect_method = "skeleton";
detect_method = "template";
detect_method = "both";

% Readies folder to save skeletons (mostly for debugging)
if (isfolder("..\image\temporary\temp_"))
        rmdir ..\image\temporary\temp_ s;
end

% Reads each segmented char and then try to find the most similar character
% from the "fonts"
for i=1:size(theFiles,1)
    file_path = fullfile(theFiles(i).folder, theFiles(i).name);
    %disp(file_path);
    %disp("  --- ");
    I = imread(file_path);
    % Do the actual comparisons here
    [char, similarity] = get_most_similar_image(I, detect_method);
    %disp("char : " + char);
    %disp(similarity);

    %disp("==========");
    detected = [detected, char];
end

% Outputs the detected files
disp("Detected : "), disp(detected);