function text = readplate(image, type)
    load imgfildata;
    % [~, Y] = size(image);
    image = imresize(image,[300 500]);
    
    if size(image,3)==3
      image=rgb2gray(image);
    end
    
    threshold = graythresh(image);
    image =~im2bw(image, threshold);
    image = bwareaopen(image, 30);
    
    % Handling reverse color
    [counts,binLocations] = imhist(image);
    if counts(2,1) > counts(1,1) && type == "full-plate"
        image = imcomplement(image);
    end
    
    if type == "full-plate"
        A = 4000; B = 750;
    elseif type == "medium-plate"
        A = 750; B = 250;
    elseif type == "mini-plate"
        A = 500; B = 75;
    end

%     figure,imshow(image);
    image1=bwareaopen(image,A);
%     figure,imshow(image1);
    image2 = image-image1;
    image2 = bwareaopen(image2, B);
%     figure,imshow(image2);
    
    [L,Net]=bwlabel(image2);
    propied=regionprops(L,'BoundingBox');
    hold on
    pause(1)
    for n=1:size(propied,1)
      rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end
    hold off
    
    final_output=[];
    t=[];
    for n=1:Net
      [r,c] = find(L==n);
      n1=image(min(r):max(r),min(c):max(c));
      n1=imresize(n1,[42,24]);
%       imshow(n1)
      pause(0.2)
      x=[ ];
      
      totalLetters=size(imgfile,2);
      for k=1:totalLetters
          y=corr2(imgfile{1,k},n1);
          x=[x y];
      end
      t=[t max(x)];
      if max(x)>.40
          z=find(x==max(x));
          out=cell2mat(imgfile(2,z));
          final_output=[final_output out];
      end
    end
    text = final_output;
end