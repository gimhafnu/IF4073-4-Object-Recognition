function detecteds = detect_plate(I)
    % Readies folder for segmented characters from the plate number image
    if (isfolder("..\image\temporary\temp_segmented"))
        rmdir ..\image\temporary\temp_segmented s;
    end
    
    % Segmented characters from the plate number image, and save it
    [seg_files] = segment_image(I,"..\image\temporary\temp_segmented");
    %disp(seg_files)
    
    % Readies a list of files to be compared (the segmented images from the
    % plate number
    segs_folder = '..\image\temporary\temp_segmented';
    
    filePattern = fullfile(segs_folder, '*.png'); 
    theFiles = dir(filePattern);
    
    detected = "";
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
        detected = strcat(detected,char);
    end
    
    % Outputs the detected files
    disp("Detected : "), disp(detected);
    detecteds = detected;
end