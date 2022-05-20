classdef RBC
    
    properties
        m
        stds
        As
        Vs
        min_dts
    end
    
    methods
        function obj = RBC(m)
            obj.m = m;
        end
        
        function obj = computeRBC(obj, V0, k_c, k_a, k_v, k_r, t, delta_val, save, par)
            [obj.m, obj.stds, obj.As, obj.Vs, obj.min_dts] = Run_iterations_LE(obj.m, V0, k_c, k_a, k_v, k_r, t, delta_val, save, par);
        end    
    end
    
end
    