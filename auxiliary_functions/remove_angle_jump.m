function [ xa_n ] = remove_angle_jump( xa )
for sz=1:size(xa,2)
    xa1 = xa(:,sz);
    xa1 = xa1-pi;
    x_jmp = []; jmp = [];
    x_pks_all = []; pks_all = [];
    x_pks = []; pks = [];
    
    jj=1;
    for j=2:size(xa1,1)
        ang_diff = xa1(j)-xa1(j-1);
        if abs(ang_diff) > 0.25 && abs(ang_diff) < 0.35  % jump in this range
            if abs(xa1(j+1))<0.1  % jumps near zero only
                jmp(jj,1) = abs(ang_diff);
                x_jmp(jj,1) = j-1;
                pk_cnt=1;
                for kk=2:j
                    if (xa1(kk)-xa1(kk-1))>0.9*pi    % only switching peaks (2pi) and sudden shifts after loss of data
                        x_pks_all(pk_cnt,1) = kk;
                        pks_all(pk_cnt,1) = xa1(kk);
                        pk_cnt = pk_cnt+1;
                    end
                end
                
                if ~isempty(x_pks_all)
                    x_pks(jj,1) = x_pks_all(end,1);
                    pks(jj,1) = pks_all(end,1);
                end
                jj=jj+1;
            end
        end
    end
    
    xa1_n = xa1;
    
    if ~isempty(x_pks_all)
        
        for k=1:size(x_jmp,1)
            if x_pks(k,1) ~=0
                xa1_n(x_pks(k,1):x_jmp(k,1),1) = xa1_n(x_pks(k,1):x_jmp(k,1),1)-jmp(k,1);
            end
        end   
    end
    kink_pts = [x_pks,x_jmp];
    xa_n(:,sz)=xa1_n;
    
    
end
end

