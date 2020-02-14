function z=prbs(init)
% z=prbs(init,g)
% 2^n-1-bit PRBS based on initial string 'init'
% and polynomial represented by vector g (e.g., g=[7 1] => x^7+x+1).
% Rob Lynch Quinta Corporation 3/31/97
z=init;
n=12;
for ind=(n+1):(2^n-1)
    q=xor(z(12-3),z(12-1));
%     z=[z q];
    z=[q z];
end
z = fliplr(z);