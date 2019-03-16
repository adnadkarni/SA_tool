function [] = runControl(yCP, yPara)
%  open('workspace_opf_start.mat');
%  init=ans.init;
%load kundur.mat;
%% Variable assignments

baseMVA=100;
global db;
mpc = yPara.mpc;
ntp = yPara.ntp;
Ybus = yPara.Ybus;

%% Execute 

k=1;
for t=[6000]
    [ mpc] = pred_subst( mpc,ntp,db,t);
    
    
    if t < 100
        branch_out = 0;
    else
        branch_out = 5;
        mpc.branch(branch_out,3) = 0.0015/4;
        mpc.branch(branch_out,4) = 0.0288/4;
        mpc.branch(branch_out,5) = 2.346*4;
        
        [ Ybus ] = makeYbus(baseMVA, mpc.bus, mpc.branch);
    end
        
    
    
    %% Make GAMS parameter structure
    [ M2G ] = mat2gms( Ybus.G, Ybus.B, Ybus.Yf, Ybus.Yt, ntp, mpc );
    
    %% Execute GAMS OPF    
    gams('kundur10Bus.gms');
    
    %%
    irgdx('matsol.gdx','model_status','solver_status');
    if (model_status<=2 && solver_status==1)
        if branch_out ~=0
            mesge{1} = sprintf('GAMS OPF solution found for contingency no. %d between lines %d and %d, importing results to MATLAB',...
                branch_out,mpc.branch(branch_out,1),mpc.branch(branch_out,2));
        end
    else
        
        mesge{1} = sprintf('GAMS OPF solution could not be found');
        disp (mesge{1});
    end
    
    % Import GAMS results back into MATLAB
    
    [G2M, R] = gms2mat(ntp);
    
    [res_tab] = results_table(R);
    
    Vr = R.V_gms(:,2).*cos(R.Vph_gms(:,2)*pi/180);
    Vi = R.V_gms(:,2).*sin(R.Vph_gms(:,2)*pi/180);
    
    Vbus = complex(Vr,Vi);
    Vm(:,2*k-1:2*k) = R.V_gms(:,2:3);
    k=k+1;
end




