function [ yin ] = rescaleData(yin, ts)

[ ~,F1,D,~,~,~ ] = fin_diff_op( length(yin.indexWin) );

for i=1:size(yin.val,2)    
    yin.val(:,i) = yin.val(:,i)/yin.scfact(i,i);
    yin.X(:,i) = yin.X(:,i)/yin.scfact(i,i);
    yin.U(:,i) = yin.U(:,i)/yin.scfact(i,i);
    yin.W(:,i) = yin.W(:,i)/yin.scfact(i,i);
    
    yin.Fx(:,i) = F1*yin.X(:,i)/(ts);                                       % first order discrete time derivative
    yin.Dx(:,i) = D*yin.X(:,i)/(2*ts);                                      % second order discrete time derivative
    yin.Fw(:,i) = F1*yin.W(:,i)/(ts);
end
end