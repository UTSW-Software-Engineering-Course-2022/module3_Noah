% Test example, where object is setup/tear down each method/test

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
        F_tot
        F_a
        F_b
        F_v
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
                m, 0.02, 0, 0, 0, 0, 1000, 0.0001, false);
            testCase.stds = stds;
            testCase.As = As;
            testCase.Vs = Vs;
            testCase.min_dts = min_dts;
            
            [Fi] = Finternal(m);
            [L, ~, dir_ij] = compute_L_and_dir_ij(m);
            [testCase.F_tot, ~] = compute_F_tot(m,Fi,dir_ij,L);
            [testCase.F_b, testCase.F_a, testCase.F_v] = calculate_forces(m, 0.0001, 1, 1, r);
            
            disp('---- Setup Complete ---');
        end
    end
    
%     methods (TestMethodTeardown)    
%         function destroyVars(testCase)
%             disp('---- Start Tear Down  --------');
%             A = testCase.m.Area();
%             fprintf('Area: %f, %f\n', sum(A), testCase.Area_r);
%             disp('----Tearing Down Complete --------');
%         end
%     end
    
    methods (Test)
          
        function testF_tot(testCase)
            disp('Unit Testing compute_F_tot!')
            testCase.assertEqual(testCase.F_tot, testCase.ground_truth.F_tot);
        end
        
        function testF_b(testCase)
            disp('Unit Testing compute_F_b!')
            testCase.assertEqual(testCase.F_b, testCase.ground_truth.F_b);
        end
        
        function testF_a(testCase)
            disp('Unit Testing compute_F_a!')
            testCase.assertEqual(testCase.F_a, testCase.ground_truth.F_a);
        end
        
        function testF_v(testCase)
            disp('Unit Testing compute_F_v!')
            testCase.assertEqual(testCase.F_v, testCase.ground_truth.F_v);
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