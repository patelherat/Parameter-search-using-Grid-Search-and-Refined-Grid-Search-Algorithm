function HW_09_Find_Canny_Parameters()
    input_image = imread('IMG_4242B.jpg');     %reads the image
    input_image = rgb2gray(input_image);       %converts into grayscale 
    input_image = medfilt2(input_image, [12, 12]);  %removes the noise
    
    desired_edge_map = imread('Target_Map_for_Img_B.png');
    desired_edge_map = im2double(desired_edge_map);
    
    sig = [0.25 0.5 1.0 2.0 3.0];              %sigma
    h2 = [ 0.5, 0.4, 0.3, 0.25, 0.2, 0.125, 0.125, 0.10 ]; %upper threshold
    for idx = 1 : length(h2)
        h1_list = h2(idx)*[0.95, 0.9:-0.2:0.1, 0.05];
    end
    h1_list(h1_list<0.00125) = [];                  %very small values will be removed by this
    h1 = h1_list;                                   %storing the lower threshold
    %im2 = grid_search(input_image, desired_edge_map, sig, h1, h2);  %calls grid_search() with standard deviation, threshold1 and threshold2 as parameters.
    im3 = Refining_grid_search(input_image, desired_edge_map, sig, h1, h2); %calls Refining_grid_search()
end