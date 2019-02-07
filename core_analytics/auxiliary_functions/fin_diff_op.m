function [ F,F1,D,D3,D4,D5 ] = fin_diff_op( win_size )
e = ones(win_size,1);
D = spdiags([e -2*e e], 0:2, win_size-2, win_size);
F1 = spdiags([-e e],0:1, win_size-1, win_size);
F = spdiags([-e zeros(win_size,1) e],0:2, win_size-2, win_size);
D3 = spdiags([-0.5*e e zeros(win_size,1) -e 0.5*e], 0:4, win_size-4, win_size);
D4 = spdiags([e -4*e 6*e -4*e e], 0:4, win_size-4, win_size);
D5 = spdiags([e/3 e/3 e/3], 0:2, win_size-2, win_size);
end

