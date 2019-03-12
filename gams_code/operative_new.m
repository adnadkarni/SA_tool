clc
clear
%  open('workspace_opf_start.mat');
%  init=ans.init;
load kundur.mat;
baseMVA=100;
mpc=case10;
mpc_base=mpc;

[NT] = bus_ip( mpc_base );
k=1;
for t=[6000]
    [ mpc_base] = pred_subst( mpc_base,NT,db,t);
    
    
    if t < 100
        branch_out = 0;
    else
        branch_out = 5;
        mpc_base.branch(branch_out,3) = 0.0015/4;
        mpc_base.branch(branch_out,4) = 0.0288/4;
        mpc_base.branch(branch_out,5) = 2.346*4;
    end
    
    % Update topology matrix
    
    [Ybus, Yf, Yt] = makeYbus(baseMVA, mpc_base.bus, mpc_base.branch);
    
    G = real(Ybus);
    B = imag(Ybus);
    
    % make GAMS structure
    [ M2G]= mat2gms_operative_slack( G,B,Yf,Yt,NT,mpc_base );
    
    gams('14busopf_slack.gms');
    
    irgdx('matsol.gdx','model_status','solver_status');
    if (model_status<=2 && solver_status==1)
        if branch_out ~=0
            mesge{1} = sprintf('GAMS OPF solution found for contingency no. %d between lines %d and %d, importing results to MATLAB',...
                branch_out,mpc_base.branch(branch_out,1),mpc_base.branch(branch_out,2));
        end
    else
        
        mesge{1} = sprintf('GAMS OPF solution could not be found');
        disp (mesge{1});
    end
    
    % Import GAMS results back into MATLAB
    
    [G2M, R] = gms2mat_operative_slack(NT);
    
    [res_tab] = results_table(R);
    
    Vr = R.V_gms(:,2).*cos(R.Vph_gms(:,2)*pi/180);
    Vi = R.V_gms(:,2).*sin(R.Vph_gms(:,2)*pi/180);
    
    Vbus = complex(Vr,Vi);
    Vm(:,2*k-1:2*k) = R.V_gms(:,2:3);
    k=k+1;
end




