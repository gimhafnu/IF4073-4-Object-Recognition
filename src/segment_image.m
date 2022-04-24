% Attempts to segment the images from a platenumber
%% Masih bermasalah
% 1. Garis yang pemisah plat nomor dan tanggal kadaluarsa
% 2. Kalau di bagian luarnya masih ada padding
% % Kayaknya yang ke 2 ini bisa diselesaikan dengan pakai edge detection?
%%

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
    
    if white_count > black_count
        I_bin_clean = ~I_bin_clean;
    end
    
    I_bin_clean =  bwareaopen(I_bin_clean, round(I_size(1) * I_size(2) / 160));
    %I_bin_clean =  bwareaopen(I_bin_clean, 128);
    
    %figure, imshow(I_bin_clean);
    
    % Labels the connected areas to help segmentation
    [Labels, label_n] = bwlabel(I_bin_clean);
    Label_props = regionprops(Labels,'BoundingBox');
    % Tries to make segmentations' bounding box
    hold on
    for n=1:size(Label_props,1)
        rectangle('Position',Label_props(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
    hold off

    %figure;

    % Segments the image
    for n=1:label_n
        [r,c] = find(Labels==n);
        n1 = I_bin_clean(min(r):max(r),min(c):max(c));
        %n1 = imgaussfilt(double(n1),1);
        N = 6;
        kernel = ones(N, N) / N^2;
        blurryImage = convn(double(n1), kernel, 'same');
        n1 = blurryImage > 0.5;

        minpadsize = 4; 
        outsize = [256 256];
        nr = imresize(n1,[outsize(1)-2*minpadsize NaN],'bicubic');
        hpad = (outsize(2)-size(nr,2))/2;
        if hpad < 0
            continue
        end
        %np_pre = [minpadsize floor(hpad)];
        np = padarray(nr,[minpadsize floor(hpad)],0,'pre'); 
        np = padarray(np,[minpadsize ceil(hpad)],0,'post');
        %np = imgaussfilt(double(np),1);
        %n1 = imresize(n1,[128 128]);
        %n1 = imgaussfilt(double(n1),1);
        %n1 = padarray(imresize(n1,[20 20],'bicubic'),[4 4],0,'both'); 


        np_old = np;
        [nx,ny] = size(np_old) ;
        [y,x] = find(np_old(:,:,1)==1) ;
        np = zeros(nx,ny) ;
        [X,Y] = meshgrid(1:ny,1:nx) ;
        idx = boundary(x,y) ;
        idx = inpolygon(X(:),Y(:),x(idx),y(idx)) ;
        np(idx) = 1 ;

        
        
        %subplot(3, 4, n);
        %imshow(np);
        
        if not(isfolder(folder))
            mkdir(folder);
        end
        segmentedImages1 = [];
        if num_suffix
            segmentedImages1 = fullfile(folder, sprintf(file_name+'%d.png', n));
        else
            segmentedImages1 = fullfile(folder, sprintf(file_name+'.png'));
        end
        imwrite(np, segmentedImages1);
        seg_file_list = [seg_file_list, segmentedImages1];
        %pause(1)
    end

    list_of_files = seg_file_list;
end


