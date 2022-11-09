%------------------------------------------------------------------
% N                     Time steps
% x(k)=A*x(k-1)+u+w(k)  Model equation
% y(k)=H*x(k)+v(k)      Observation equation
%------------------------------------------------------------------
function kalmanPosition(N)

randn('state', 0);

A=1; H=1;
Q=0.003;   % process noise variance
R=1;       % measurement noise variance
u=.05;     % velocity

X = [];    % true position array
Xhat = []; % estimated position array
Y = [];    % measured position array

%Initial conditions
x = 0;     % initial state

xhat = x;  % initial state estimate
p_pos=Q;
%------------------------------------------------------------------
for k=1:N
    %Model equation
    w=sqrt(Q)*randn; % process noise
    x=A*x+u+w;

    %Observation equation
    v=sqrt(R)*randn; % measurement noise
    y=H*x+v;
    
    %Update equation
    x_prior=A*xhat+u;

    % Innovation
    Inn = y - x_prior;

    %Covariance of Innovation
    p_prior = A*A*p_pos+Q;

    %Gain matrix
    K = H*p_prior/(H*H*p_prior+R);

    %State estimate
    xhat = A * x_prior + K * Inn;

    %Covariance of prediction error
    p_pos=p_prior*(1-H*K);

    %Save some parameters in vectors for plotting later
    X = [X; x];
    Xhat = [Xhat; xhat];
    Y = [Y; y];
end
%------------------------------------------------------------------
plot(
  (1:N)', X,    'k-.',
  (1:N)', Xhat, 'k',
  (1:N)', Y,    'k:'
);

hLegend = legend('$x_k$','$\hat{x}_k$', '$y_k$');
set(hLegend,'FontSize',14, 'interpreter', 'latex');

xlabel('Time', 'FontSize', 16)
ylabel('Position', 'FontSize', 16)
