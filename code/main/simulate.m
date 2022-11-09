function simulate(K,T)
N=500;dt=T/N;

sigma=.1; %Volatility for the index and forward

%----------------
% Brownian Motion
%----------------
dW=sqrt(dt)*randn(N,1);
W =cumsum(dW);
%---------------------
% Market Price of Risk
%---------------------
lambda_bar=1; %mean reversion level
sigma_lambda=1;
kappa=10;    %mean reversion rate

Lambda=zeros(N,1); %pre-allocation
Lambda(1)=1; %initial condition

for k=2:length(Lambda)
    %Ornstein-Uhlenbeck process
    Lambda(k)=Lambda(k-1)+kappa*(lambda_bar-Lambda(k-1))*dt+sigma_lambda*dW(k-1);
end

%--------------
% Interest Rate
%--------------
r=.02; %risk-free interest rate
R=zeros(N,1); %pre-allocation 

for k=1:N
    R(k)=r;
end

%---------------
% Index Dividend
%---------------
q=0;
Q=zeros(N,1); %pre-allocation 

for k=1:N
    Q(k)=q;
end

%------------
% Index Price
%------------
S=zeros(N,1); %pre-allocation 
S(1)=1000; %initial condition

for k=2:length(S)
    S(k)=S(k-1)+(r-q+sigma*Lambda(k-1))*S(k-1)*dt+sigma*S(k-1)*dW(k-1);
end

%--------------
% Forward Price
%--------------
F=zeros(N,1); %pre-allocation
F(1)=1000; %initial condition

for k=2:length(F)
    F(k)=F(k-1)+sigma*Lambda(k-1)*F(k-1)*dt+sigma*F(k-1)*dW(k-1);
end

%-----------
% Call Price
%-----------
d1=zeros(N,1); %pre-allocation
sigma_c=zeros(N,1); %pre-allocation

C=zeros(N,1); %pre-allocation
C(1)=1000; %initial condition

for k=2:length(C)
    d1(k-1)=(log(F(k-1)/K)+sigma^2/2*(T-(k-1)*dt))/(sigma*sqrt(T-(k-1)*dt));
    sigma_c(k-1)=sigma*F(k-1)/C(k-1)*exp(-r*(T-(k-1)*dt))*normpdf(d1(k-1)); %option volatility
    
    C(k)=C(k-1)+(r+sigma_c(k-1)*Lambda(k-1))*C(k-1)*dt+sigma_c(k-1)*C(k-1)*dW(k-1);
end

%-----------
% Call Price
%-----------
for k=1:length(C)
     C(k)=blsprice(F(k), K, r, T-(k-1)*dt, sigma);
end

%--------------------------
% Save Simulations on files
%--------------------------
%'\n' for all UNIX applications, Microsoft Word and WordPad
%'\r\n' for Microsoft Notepad

fid = fopen('lambda.txt', 'w'); % open the file with write permission
fprintf(fid, '%4.2f\r\n', Lambda); 
fclose(fid);
 
fid = fopen('ThreeMonthRate.txt', 'w'); %Open the file with write permission
fprintf(fid, '%4.2f\r\n', R); 
fclose(fid);

fid = fopen('IndexPrice.txt', 'w'); %Open the file with write permission
fprintf(fid, '%4.2f\r\n', S); 
fclose(fid);

fid = fopen('IndexDividend.txt', 'w'); %Open the file with write permission
fprintf(fid, '%4.2f\r\n', Q); 
fclose(fid);

fid = fopen('ForwardPrice.txt', 'w'); %Open the file with write permission
fprintf(fid, '%4.2f\r\n', F); 
fclose(fid);

fid = fopen('OptionPrice.txt', 'w'); %Open the file with write permission
fprintf(fid, '%4.2f\r\n', C); 
fclose(fid);
