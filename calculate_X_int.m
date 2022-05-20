%% Calculate matrix of X_int
function X_int_mtx = calculate_X_int(subset, L_square, Fi)
    dr = Fi.rn(2) - Fi.rn(1);
    X_int_mtx = NaN(length(subset),1);
    for i = 1:length(subset)
        X_int_mtx(i) = floor(L_square(subset(i,1),subset(i,2))/dr + 0.5) - floor(Fi.rn(1)/dr+0.5);
    end
end