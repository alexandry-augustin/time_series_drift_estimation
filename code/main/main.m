function main(N)
randn('state',988);

K=1000;
T=1;
dt=T/500;

simulate(K,T);	%Simulation of monthly return over N months. 
		%Also generate historical price files.

%---------------------
% Load data from Files
%---------------------
S=load('IndexPrice.txt');
Q=load('IndexDividend.txt');
    q=Q(1);
F=load('ForwardPrice.txt');
C=load('OptionPrice.txt');
R=load('ThreeMonthRate.txt');
    r=R(1);
Lambda=load('Lambda.txt');

dim=[size(S,1), size(Q,1), size(F,1), size(C,1), size(R,1), size(Lambda,1)];
N=min(dim);
%-----------------------------------------------------------------------
%Computation of the Implied volatility
Sigma_implied=ImpliedVolatility(F, R, C, K, T, N);

if sum(isnan(Sigma_implied)) > 0
    error('Unexpected situation');
end

Sigma_c=ones(length(Sigma_implied),1);
for k=1:length(Sigma_implied)
    d1=(log(F(k)/K)+Sigma_implied(k)^2/2*(T-(k-1)*dt))/(Sigma_implied(k)*sqrt(T-(k-1)*dt));
    Sigma_c(k)=Sigma_implied(k)*F(k)/C(k)*exp(-r*(T-(k-1)*dt))*normpdf(d1);
end
%-----------------------------------------------------------------------
%maximum likelihood estimation for kappa, lambda_bar and sigma_lambda
Theta=mle(, 'distribution', 'normal');
%-----------------------------------------------------------------------
%estimate lambda(t) using kalman filtering
[Lambda_hat, Epsilon]=estimate(Sigma_implied, Sigma_c, Theta, S, r, C, F, q, dt, N);

Mu=ones(N,1);
for k=1:N
    Mu(k)=(r-q)+Sigma_implied(k)*Lambda_hat(k);
end

S_hat=ones(N,1);
S_hat(1)=1000;
for k=2:N
    S_hat(k)=S_hat(k-1)+Mu(k-1)*S_hat(k-1)*dt+Sigma_implied(k-1)*S_hat(k-1)*sqrt(dt)*Epsilon(k-1);
end

Drift=ones(N,1);
Drift(1)=1000;
for k=2:N
    Drift(k)=Drift(k-1)+Mu(k)*S(k);
end

% Save Estimation on files
%'\n' for all UNIX applications, Microsoft Word and WordPad
%'\r\n' for Microsoft Notepad

% Open the file with write permission
fid = fopen('lambda_hat.txt', 'w'); 
fprintf(fid, '%4.2f\r\n', Lambda_hat); 
fclose(fid);
