function im = grid_search(input_image, desired_edge_map, sig, h1, h2)
    
    smooth_fltr     = fspecial( 'Gauss', [13 13], 3 );       %smoothing filter that will help in edge detection
    im_smoother     = imfilter( input_image, smooth_fltr, 'same', 'repl' ); %N-d filtering of multidimensional images
    im_sub_sampled      = im_smoother( 5:5:end, 5:5:end, : );     %does sub-sampling to detect edges
    
    im_smoother     = imfilter( desired_edge_map, smooth_fltr, 'same', 'repl' );
    im_sub_sampled2 = im_smoother( 5:5:end, 5:5:end, : );
    im_sub_sampled2 = logical(im_sub_sampled2);                 %converts into logical for further calculations
    
    best_cost = 0;
    global tmp_cost;
    
    %does grid search(i.e try them all)
    for std_dev = 1:length(sig)
        for threshold2 = 1 : length(h2)
            for threshold1 = 1 : length(h1)
                tmp_cost = 0;
                if(threshold1<threshold2)
                    edges = edge(im_sub_sampled, 'Canny', [h1(threshold1) h2(threshold2)], sig(std_dev)); %does canny edge detection with parameter as image, thresholds and standard deviation
                    edges = im2double(edges);
                    tmp_cost = evaluate_cost_function(edges, im_sub_sampled2);    %evaluates the cost function
                    if(tmp_cost > best_cost)          %finds the maximum cost function
                        best_cost = tmp_cost;
                        best_parameters = [sig(std_dev), h1(threshold1), h2(threshold2)];   %stores the best parameters 
                    end
                end
            end
        end
    end

    im = [best_parameters(1), best_parameters(2), best_parameters(3), best_cost];
    
    %imshow(edge(edges, 'Canny', [best_parameters(2), best_parameters(3)], best_parameters(1)));
    global x;
    ans = edge(x, 'Canny', [best_parameters(2), best_parameters(3)], best_parameters(1));   %prints the edge with the best parameters
    %figure, imshow(ans);
    SE = strel('disk', 1);          %morphological structuring element disk with radius 1
    J = imdilate(ans, SE);          %dilates the image with the given structuring element
    figure, imshow(J);
    disp(best_cost); 
end
