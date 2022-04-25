function detecteds = detect_plate(I, detect_method)
    % Readies folder for segmented characters from the plate number image
    if (isfolder("..\image\temporary\temp_segmented"))
        rmdir ..\image\temporary\temp_segmented s;
    end
    
    % Segmented characters from the plate number image, and save it
    [seg_files] = segment_image(I,"..\image\temporary\temp_segmented");
    %disp(seg_files)
    
    
    detected = "";
    
    % Readies folder to save skeletons (mostly for debugging)
    if (isfolder("..\image\temporary\temp_"))
            rmdir ..\image\temporary\temp_ s;
    end
    
    % Reads each segmented char and then try to find the most similar character
    % from the "fonts"
    for i=1:size(seg_files,2)
        file_path = seg_files(i);
        I = imread(file_path);
        
        % Do the actual comparisons here
        [char, similarity] = get_most_similar_image(I, detect_method);
    
        detected = strcat(detected,char);
    end
    
    % Outputs the detected files
    detecteds = detected;
end