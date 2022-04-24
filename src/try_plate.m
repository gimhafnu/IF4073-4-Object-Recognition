I = imread("..\image\plate_1_.jpg");
if (isfolder("..\image\templates\temp_segmented"))
    rmdir ..\image\templates\temp_segmented s;
end

[seg_files] = segment_image(I,"..\image\templates\temp_segmented");
disp(seg_files)

fonts_folder = "..\image\templates\fonts\";
fonts = ["A","B","C","H","I","J","L","U","0","1","2","4", ...
"6","8"];
file_type = ".png";

for i=1:size(fonts,2)
    full_path = fonts_folder + fonts(i) + file_type;
    disp(full_path);
    I = imread(full_path);
    [segs_fonts] = segment_image(I, "..\image\templates\fonts_seg", fonts(i), false);
    disp(segs_fonts);
    I_BW = imbinarize(rgb2gray(I));
    I_BW_skel = bwmorph(I_BW,'skel',inf); % Makes the skeleton
    %figure, imshow(I_BW_skel);
end

segs_folder = '..\image\templates\temp_segmented';
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(segs_folder, '*.png'); 
theFiles = dir(filePattern);

detected = [];
detect_method = "skeleton";
detect_method = "template";
detect_method = "both";

if (isfolder("..\image\templates\temp_"))
        rmdir ..\image\templates\temp_ s;
end

for i=1:size(theFiles,1)
    file_path = fullfile(theFiles(i).folder, theFiles(i).name);
    disp(file_path);
    disp("  --- ");
    I = imread(file_path);
    [char, similarity] = get_most_similar_image(I, detect_method);
    disp("char : " + char);
    disp(similarity);

    disp("==========");
    detected = [detected, char];
end

disp("Detected : "), disp(detected);