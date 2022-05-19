function cnvgnc = check_convergence(i, stds, thresh_std, min_dt, thresh_dt)

    cnvgnc = false;

    % get last 1/5 length of convergence
    to_check = stds(i-floor(i/5) : i);
    
    if i > 200
        
        if mean(to_check) < thresh_std
            
            if min_dt < thresh_dt
                
                cnvgnc = true;
                
            end
            
        end
        
    end
    
end