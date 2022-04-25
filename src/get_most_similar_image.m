function [char, similarity] = get_most_similar_image(image, method)
    % method is either "template", "skeleton", or "both"
    if nargin == 1
        method = "template";
    end

    fonts_folder = "..\image\templates\fonts_seg\";
    fonts = ["A","B","C","D","E","F","G","H","I","J","K","L","M", ...
    "N","O","P","Q","R","S","T","U","V","W","X","Y","Z", ...
    "0","1","2","3","4","5","6","7","8","9"];
    file_type = ".png";

    most_similar = "_";
    most_similar_score = 0;
    
    % image MUST be a binary image, but considering the weird ways they are
    % saved... try to handle those too anyway

    % If the image is saved RGB, then make it grayscale first
    if (size(image,3)) == 3
            image = rgb2gray(image);
    end
    
    % If the image isn't a binary image, then make it one
    if islogical(image)
        image_BW = image;
    else
        image_BW = imbinarize(image);
    end
    
    image_skeleton = bwmorph(image_BW,'skel',inf); % Makes the skeleton

    % Readies folder to save the image's skeleton
    if not(isfolder("..\image\temporary\temp_"))
        mkdir ..\image\temporary\temp_
    end
    cnt_num = 0;
    cnt_num_helper = false;
    while ~cnt_num_helper
        if isfile("..\image\temporary\temp_\main_bw" + cnt_num + ".png")
            cnt_num = cnt_num + 1;
        else
            cnt_num_helper = true;
        end
    end
    % Writes the image skeleton
    imwrite(image_skeleton, "..\image\temporary\temp_\main_bw" + cnt_num + ".png");

    temp_bak = [];
    
    for i=1:size(fonts,2)
        full_path = fonts_folder + fonts(i) + file_type;
        %disp(full_path);
        I = imread(full_path);

        % Handles the weirdly saved font files too (makes sure it's binary)
        if (size(I,3)) == 3
            I = rgb2gray(I);
        end
        %disp(class(I));
        if islogical(I)
            I_BW = I;
        else
            I_BW = imbinarize(I);
        end
        
        I_BW_skel = bwmorph(I_BW,'skel',inf); % Makes the skeleton
        
        %figure, imshow(I_BW_skel);

        % Get the similary score with the current character based on
        % selected method
        % % ssim is... structural similarity... it's kinda similar to PSNR,
        % I think???
        if method == "skeleton"
            sim_with_current = ssim(uint8(image_skeleton), uint8(I_BW_skel));
            %sim_with_current = psnr(uint8(image_skeleton), uint8(I_BW_skel));
        elseif method == "template"
            sim_with_current = ssim(uint8(image_BW), uint8(I_BW));
            %sim_with_current = psnr(uint8(image_BW), uint8(I_BW));
        elseif method == "both"
            sim_1 = ssim(uint8(image_skeleton), uint8(I_BW_skel));
            sim_2 = ssim(uint8(image_BW), uint8(I_BW));

            %sim_1 = psnr(uint8(image_skeleton), uint8(I_BW_skel));
            %sim_2 = psnr(uint8(image_BW), uint8(I_BW));

            sim_with_current = (sim_1 + sim_2) / 2;
        end
        %disp("  "), disp(fonts(i)), disp(" : "), disp(sim_with_current);

        % If the score is better than the currently saved best one... then
        % make this the best one
        if sim_with_current > most_similar_score
            most_similar_score = sim_with_current;
            most_similar = fonts(i);
        end

        temp_bak = [temp_bak, [fonts(i), sim_with_current]];

        % saves the skeleton
        imwrite(I_BW_skel, "..\image\temporary\temp_\" + fonts(i) + "_bw" + ".png");
    end

    %disp(temp_bak);

    char = most_similar;
    similarity = most_similar_score;
end


