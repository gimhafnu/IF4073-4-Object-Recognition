I = imread("..\image\plate_1_.jpg"); % The plate number image
% Readies the font so it matches better to the plates later
fonts = readyfont();
% Attempts to detect the character in the plates
detected = detect_plate(I, "skeleton");
disp("Detected : "), disp(detected);