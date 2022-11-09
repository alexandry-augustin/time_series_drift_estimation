function [X_hat, Epsilon]=estimate(sigma_implied, Sigma_c, Theta, S, r, C, F, q, dt, N)

% Theta(1)=kappa
% Theta(2)=lambda_bar
% Theta(3)=sigma_lambda

Q=[0.001; 0.001; 0.001]; %3x1
a=Theta(1)*Theta(2)*dt;    %1x1
B=1-Theta(1)*dt;       %1x1
R=Theta(3)*sqrt(dt); %1x1
%---------------------------------------------------------------------------------------
X = []; %True state array
X_hat = []; %Estimated state array
Y = []; %Measured state array

Epsilon = []; %Measured state array

%Initial conditions
x = 1; % initial state

x_hat = x; %Initial state estimate
p_pos=dt;

for k=1:N
    H=[sigma_implied(k); sigma_implied(k); Sigma_c(k)]*sqrt(dt);
    d=[(r-q-sigma_implied(k)^2/2); -sigma_implied(k)^2/2; (r-Sigma_c(k)^2/2)]*dt;
    D=H*sqrt(dt);
    G=H';

    %Model equation
    epsilon=randn; %process noise
    x=a+B*x+R*epsilon;

    %Observation equation
    eta=randn;
    v=H*epsilon+Q*eta; %measurement noise
    y=d+D*x+v;

    %
    x_prior=a+B*x_hat;

    % Innovation
    Inn = y - D*x_prior-d;

    % Covariance of Innovation
    p_prior = B*p_pos*B'+R*R';

    % Kalman Gain
    F=D*p_prior*D'+D*R*G+G'*R'*D'+H*H'+Q*Q';
    K = (p_pos*D'+R*G)*pinv(F); %pseudoinverse

    % State estimate
    x_hat = x_prior + K * Inn;

    % Covariance of prediction error
    p_pos=(1-K*D)*p_prior+K*G'*R;
    
    % Save some parameters in vectors for plotting later
    X = [X; x];
    Y = [Y; y'];
    X_hat = [X_hat; x_hat];
    Epsilon=[Epsilon; epsilon];
end
