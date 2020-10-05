function im = Refining_grid_search(input_image, desired_edge_map, sig, h1, h2)
    
    smooth_fltr     = fspecial( 'Gauss', [13 13], 3 );       %smoothing filter that will help in edge detection
    im_smoother     = imfilter( input_image, smooth_fltr, 'same', 'repl' ); %N-d filtering of multidimensional images
    im_sub_sampled      = im_smoother( 5:5:end, 5:5:end, : );     %does sub-sampling to detect edges
    
    refinement_rate = 0.1;                                 %refinement rate alpha

    grid_deltas = [0.1, 0.05, 0.05];                        %a vector of initial parameter changes
    smears = min(sig) : grid_deltas(1) : max(sig);
    h1s = min(h1) : grid_deltas(2) : max(h1);
    h2s = min(h2) : grid_deltas(3) : max(h2);
     
    im2 = grid_search(input_image, desired_edge_map, smears, h1s, h2s);  %calls grid_search()
    
    store = [];
    count = 0;
    %loops until grid_search gives same cost_function for 2 consecutive
    %iterations
    while(true) 
        count = count + 1;
        grid_deltas = grid_deltas * refinement_rate;
        smear_min = im2(1) - 2 * grid_deltas(1);
        smear_max = im2(1) + 2 * grid_deltas(1);
        h1_min = im2(2) - 2 * grid_deltas(2);
        h1_max = im2(2) + 2 * grid_deltas(2);
        h2_min = im2(3) - 2 * grid_deltas(3);
        h2_max = im2(3) + 2 * grid_deltas(3);
        im = grid_search(input_image, desired_edge_map, smear_min : grid_deltas(1) : smear_max, h1_min : grid_deltas(2) : h1_max, h2_min : grid_deltas(3) : h2_max);
        store(count) = im(4);
        if(count >= 2 && (store(count) - store(count-1)) == 0)
%             ans = max(store);
%             if(ans < im2(4))
%                 flag=1;
%                 break;
%             end
        break;
        end 
    end
   
%     if(flag == 1)
%         imshow(edge(im_sub_sampled, 'Canny', [im2(2), im2(3)], im2(1)));
%     else
        %imshow(edge(im_sub_sampled, 'Canny', [im(2), im(3)], im(1)));
    %end
end