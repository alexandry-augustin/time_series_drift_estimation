%------------------------------------------------------------------
% beta(k+1)=beta(k)+w(k)        Model equation
% y(k)=x(k)*beta(k)+v(k)        Observation equation
%------------------------------------------------------------------
function pair_trading

y=load('../../data/pair_trading/KO.txt');  %Load Coca-Cola prices from file
y=flipud(y);

x=load('../../data/pair_trading/PEP.txt'); %Load Pepsico prices from file
x=flipud(x);

N=min(size(x), size(y));        %Sample size

Q=0.003;                        %Process noise covariance
R=1;                            %Measurement noise covariance
%------------------------------------------------------------------
%Initial conditions
beta = ones(1, N);              %State
P = ones(1, N);                 %Estimation covariance

M = ones(1, N);                 %Prediction covariance
K = ones(1, N);                 %Kalmna Gain
%------------------------------------------------------------------
for k=1:N-1,
    M(k+1)=P(k)+Q;
    K(k+1)=M(k+1)*x(k+1)'*inv(x(k+1)*M(k+1)*x(k+1)'+R);
    P(k+1)=M(k+1)-K(k+1)*x(k+1)*M(k+1);
    beta(k+1)=beta(k)+K(k+1)*(y(k+1)-x(k)*beta(k));
end
%------------------------------------------------------------------
clf;                             % Clear current figure window
plot((1:N), beta, 'k-');         % Plot the graph of beta
%------------------------------------------------------------------
fid = fopen('beta.txt', 'w');    % Open output file with write permission
fprintf(fid, '%4.2f\r\n', beta); % Write the data
fclose(fid);                     % Close output file
