function fonts = readyfont()
    % Readies the font so it matches better to the plates later

    % Readies the font to be "segmented"
    % % It's mostly just so the plate and the fonts get the same treatment
    % % % first before they're compared
    fonts_folder = "..\image\templates\fonts\";

    %disp("READING FONT");
    
    fonts = ["A","B","C","D","E","F","G","H","I","J","K","L","M", ...
        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z", ...
        "0","1","2","3","4","5","6","7","8","9"];
    
    file_type = ".png";

    fonts_ = [];
    
    % Actually do the "segmentation"s here
    for i=1:size(fonts,2)
        full_path = fonts_folder + fonts(i) + file_type;
        %disp(full_path);
        I = imread(full_path);
        [segs_fonts] = segment_image(I, "..\image\templates\fonts_seg", fonts(i), false);
        fonts_ = [fonts_, segs_fonts];
        %disp(segs_fonts);
        I_BW = imbinarize(rgb2gray(I));
        I_BW_skel = bwmorph(I_BW,'skel',inf); % Makes the skeleton
        %figure, imshow(I_BW_skel);
    end
    
    fonts = fonts_;
end