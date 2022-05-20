classdef TestRBC < matlab.unittest.TestCase
    
    properties
        m
        u
        r
        Area_r
        Volume_r
        As
        Vs
        stds
        min_dts
        ground_truth
        L
        dir_ij
    end
    
    methods (TestClassSetup)
        function createVars(testCase)
            disp('---- Setting Up TestCases ---');
            
            % Saved mat file that contains ground truth matrices
            testCase.ground_truth = matfile("module3_Noah/ground_truth/ground_truth.mat");
            
            % This is in essences an integration test
            u = ComUnit('erg', ComUnit.nm_to_cm(1000), 300, ...
                ComUnit.kBT_to_erg(10, 300)); 
            m = ModMembrane(2, 'unit', u);
            m.var.coord = testCase.ground_truth.coord;
            r = mean(sqrt(sum(m.var.coord(:,1).^2+ ...
                m.var.coord(:,2).^2+m.var.coord(:,3).^2, 2)));
            
            testCase.Area_r = 4*pi*r^2;
            testCase.Volume_r = 0.6 * 4/3 * pi * r^3;
            testCase.m = m;
            testCase.u = u;
            
            % Run with just the internal force. This should converge
            [m_after,stds,As,Vs,min_dts] = Run_iterations_LE(...
                m, 0.02, 0, 0, 0, 0, 1000, 0.0001, false, false);
            testCase.stds = stds;
            testCase.As = As;
            testCase.Vs = Vs;
            testCase.min_dts = min_dts;
            

            [testCase.L, ~, testCase.dir_ij] = compute_L_and_dir_ij(m);
            
            disp('---- Setup Complete ---');
        end
    end
    
    
    methods (Test)
          
        function testF_tot(testCase)
            disp('Unit Testing compute_F_tot!')
            F_tot_test = compute_F_tot(testCase.m, ...
                testCase.Fi,testCase.dir_ij,testCase.L);
            testCase.assertEqual(F_tot_test, testCase.ground_truth.F_tot);
        end
        
        function test_calculate_forces(testCase)
            disp('Unit Testing calculate_forces!')
            
            [F_b_test, F_a_test, F_v_test] = calculate_forces(testCase.m, 0.0001, 1, 1, testCase.r);
            
            testCase.assertEqual(F_b_test, testCase.ground_truth.F_b);
            testCase.assertEqual(F_a_test, testCase.ground_truth.F_a);
            testCase.assertEqual(F_v_test, testCase.ground_truth.F_v);
        end

        function testMeshCreate(testCase)
            disp('Unit Testing Mesh Object Instantiation')
            m_test = ModMembrane(2, 'unit', testCase.u);
            % assertInstanceOf(m_test, 'ModMembrane');
            % assertInstanceOf(m_test, 'struct');
            import matlab.unittest.constraints.IsOfClass
            testCase.verifyThat(m_test,IsOfClass('ModMembrane'))
        end
        
        % TODO: Need to fill more tests for convergence of area, volume, min_dt
        function testAreaConvergence(testCase)
            disp('Testing Fi only Area Convergence after 1000 iterations')
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            last_10_As = mean(testCase.As(length(testCase.As)-10:length(testCase.As)));
            testCase.verifyThat(last_10_As, IsEqualTo(testCase.Area_r, 'Within', AbsoluteTolerance(3)))
        end
        
        function testVolumeConvergence(testCase)
            disp('Testing Fi only Volume Convergence after 1000 iterations')
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            last_10_Vs = 0.6 * mean(testCase.Vs(length(testCase.Vs)-10:length(testCase.Vs)));
            testCase.verifyThat(last_10_Vs, IsEqualTo(testCase.Volume_r, 'Within', AbsoluteTolerance(7)))
        end
        
        function testmindtConvergence(testCase)
            disp('Testing Fi only min_dt Convergence after 1000 iterations')
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            import matlab.unittest.constraints.IsLessThan
            last_10_min_dts = mean(testCase.min_dts(length(testCase.min_dts)-10:length(testCase.min_dts)));
            testCase.verifyThat(last_10_min_dts,IsLessThan(0.05))
        end
    end
end