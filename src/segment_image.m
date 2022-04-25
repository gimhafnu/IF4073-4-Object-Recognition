% Attempts to segment the images from a platenumber

function [list_of_files] = segment_image(image, folder, file_name, num_suffix)
    if nargin==2
        file_name = "image";
        num_suffix = true; 
    elseif nargin ==3
        num_suffix = true; 
    end


    I = image;
    I_size = size(I);
    % Make grey then binary
    I_gray = rgb2gray(I);
    bin_threshold = graythresh(I_gray);
    I_bin = imbinarize(I_gray, bin_threshold);
    % cleans the image from small stuffs/area
    I_bin_clean = I_bin;
    
    % This is for the output, to perhaps help other functions know which
    % files got created from this segmentation
    seg_file_list = [];
    
    
    % Attempts to check if the background is white or black
    
    white_count = 0;
    black_count = 0;
    for i = 1:I_size(1)
        for j = 1:I_size(2)
            %if i==1 || i==I_size(1)|| j==1 || j==I_size(2)
            if I_bin_clean(i,j) == 0
                black_count = black_count + 1;
            else
                white_count = white_count + 1;
            end
            %end
        end
    end
    % If the background is white, make it black
    if white_count > black_count
        I_bin_clean = ~I_bin_clean;
    end
    
    % Tries to clean smaller "areas" from the image
    % This should delete the expiration date
    I_bin_clean =  bwareaopen(I_bin_clean, round(I_size(1) * I_size(2) / 180));
    %I_bin_clean =  bwareaopen(I_bin_clean, 128);
    
    %figure, imshow(I_bin_clean);
    
    % Labels the connected areas to help segmentation
    [Labels, label_n] = bwlabel(I_bin_clean);
    Label_props = regionprops(Labels,'BoundingBox');
    % Tries to make segmentations' bounding box
    %hold on
    %for n=1:size(Label_props,1)
    %    rectangle('Position',Label_props(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    %end
    %hold off

    %figure;

    % Segments the image
    for n=1:label_n
        % Gets the actual label's area by checking which pixels have each
        % label's number
        [r,c] = find(Labels==n);
        n1 = I_bin_clean(min(r):max(r),min(c):max(c));
        %n1 = imgaussfilt(double(n1),1);

        % Attempts to smooth out the edges of the area
        N = 6;
        kernel = ones(N, N) / N^2;
        blurryImage = convn(double(n1), kernel, 'same');
        n1 = blurryImage > 0.5;
        
        % Attempts to upscale the image
        minpadsize = 4; 
        outsize = [256 256]; % The actual image size to be made
        n1_size = size(n1);
        
        % Ignores area if it's... long
        % More or less the aspect ratio of the actual plate
        if n1_size(2) / n1_size(1) > 2.4
            %figure, imshow(n1);
            %disp("Skipping");
            continue
        end

        nr = [];
        hpad = 0;
        % Resizes the image
        n1 = imresize(n1,outsize);
        n1 = imgaussfilt(double(n1),1);
        n1 = padarray(imresize(n1,[20 20],'bicubic'),[4 4],0,'both'); 
        np = n1;

        % Makes the segmentation folder if it doesn't exist
        if not(isfolder(folder))
            mkdir(folder);
        end
        segmentedImages1 = [];

        % Writes the segmented images
        if num_suffix
            segmentedImages1 = fullfile(folder, sprintf(file_name+'%d.png', n));
        else
            segmentedImages1 = fullfile(folder, sprintf(file_name+'.png'));
        end
        imwrite(np, segmentedImages1);
        seg_file_list = [seg_file_list, segmentedImages1];
        %disp(seg_file_list);
        %pause(1)
    end

    list_of_files = seg_file_list;
end


