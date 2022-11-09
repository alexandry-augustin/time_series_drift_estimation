function [Sigma_implied]=ImpliedVolatility(F, R, C, K, T, N)
Sigma_implied=zeros(N,1); %pre-allocation

dt=T/N;

for k=1:N
    Sigma_implied(k)=blsimpv(F(k), K, R(k), T-(k-1)*dt, C(k));
end