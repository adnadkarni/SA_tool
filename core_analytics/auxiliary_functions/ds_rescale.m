function [ Yo_tr ] = ds_rescale(Yo_tr)

[ ~,F1,D,~,~,~ ] = fin_diff_op( Yo_tr.win_sz );

for i=1:size(Yo_tr.val,2)    
    Yo_tr.val(:,i) = Yo_tr.val(:,i)/Yo_tr.scfact(i,i);
    Yo_tr.X(:,i) = Yo_tr.X(:,i)/Yo_tr.scfact(i,i);
    Yo_tr.U(:,i) = Yo_tr.U(:,i)/Yo_tr.scfact(i,i);
    
    Yo_tr.Fx(:,i) = F1*Yo_tr.X(:,i)/(Yo_tr.ts);
    Yo_tr.Dx(:,i) = D*Yo_tr.X(:,i)/(2*Yo_tr.ts);
end
end