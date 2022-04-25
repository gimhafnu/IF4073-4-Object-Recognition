I = imread("..\image\Picture2.png"); % The plate number image
% Readies the font so it matches better to the plates later
fonts = readyfont();
% Attempts to detect the character in the plates
detected = detect_plate(I);
disp("Detected : "), disp(detected);