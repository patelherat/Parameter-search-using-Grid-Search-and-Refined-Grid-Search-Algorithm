function tmp_cost = evaluate_cost_function(edges, im_sub_sampled2)
global tmp_cost;
global x;
x = zeros(size(edges, 1), size(edges, 2));          %take a matrix of zeros

%if the edges detected and the target map image both has 1, cost is increased and
%matrix 'x' is set to 1
%if the edges detected have 1 and target map image has 0, cost is decreased
%and matrix 'x' is set to 0
for row = 1 : size(edges, 1)
    for column = 1 : size(im_sub_sampled2, 2)
        if edges(row, column) == 1 && im_sub_sampled2(row, column) == 1
            tmp_cost = tmp_cost + 1;
            x(row, column) = 1;
        elseif edges(row, column) == 1 && im_sub_sampled2(row, column) == 0
            tmp_cost = tmp_cost - 0.1;
            x(row, column) = 0;
            %edges(row, column) = 0;
        end
    end
end
%figure, imshow(x);
%disp(tmp_cost);
end