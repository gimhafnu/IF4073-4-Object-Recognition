function [char, similarity] = get_most_similar_image(image, method)
    % method is either "template", "skeleton", or "both"
    if nargin == 1
        method = "template";
    end

    fonts_folder = "..\image\templates\fonts_seg\";
    fonts = ["A","B","C","H","I","J","L","U","0","1","2","4", ...
    "6","8"];
    file_type = ".png";

    most_similar = "_";
    most_similar_score = 0;
    
    % image MUST be a binary image, but considering the weird ways they are
    % saved...
    %image_BW = imbinarize(image);
    if (size(image,3)) == 3
            image = rgb2gray(image);
    end
    %disp(class(I));
    if islogical(image)
        image_BW = image;
    else
        image_BW = imbinarize(image);
    end
    %image_BW = image;
    %image_skeleton = bwmorph(image_BW,'spur',Inf);
    image_skeleton = bwmorph(image_BW,'skel',inf); % Makes the skeleton
    %image_skeleton = bwmorph(image_skeleton,'skel',inf); % Makes the skeleton
    %image_skeleton = bwmorph(image_skeleton,'spur',Inf);

    
    if not(isfolder("..\image\templates\temp_"))
        mkdir ..\image\templates\temp_
    end
    cnt_num = 0;
    cnt_num_helper = false;
    while ~cnt_num_helper
        if isfile("..\image\templates\temp_\main_bw" + cnt_num + ".png")
            cnt_num = cnt_num + 1;
        else
            cnt_num_helper = true;
        end
    end
    imwrite(image_skeleton, "..\image\templates\temp_\main_bw" + cnt_num + ".png");

    temp_bak = [];
    
    for i=1:size(fonts,2)
        full_path = fonts_folder + fonts(i) + file_type;
        %disp(full_path);
        I = imread(full_path);
        if (size(I,3)) == 3
            I = rgb2gray(I);
        end
        %disp(class(I));
        if islogical(I)
            I_BW = I;
        else
            I_BW = imbinarize(I);
        end
        %I_BW_skel = bwmorph(I_BW,'spur',Inf);
        I_BW_skel = bwmorph(I_BW,'skel',inf); % Makes the skeleton
        %I_BW_skel = bwmorph(I_BW_skel,'skel',inf); % Makes the skeleton
        %I_BW_skel = bwmorph(I_BW_skel,'spur',Inf);
        
        
        %figure, imshow(I_BW_skel);
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
        if sim_with_current > most_similar_score
            most_similar_score = sim_with_current;
            most_similar = fonts(i);
        end

        temp_bak = [temp_bak, [fonts(i), sim_with_current]];
        imwrite(I_BW_skel, "..\image\templates\temp_\" + fonts(i) + "_bw" + ".png");
    end

    disp(temp_bak);

    char = most_similar;
    similarity = most_similar_score;
end


