import math
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(0)
N=100
#------------------------------------------------------------------
# N Time steps  
# x(k)=A*x(k-1)+u+w(k) Model equation  
# y(k)=H*x(k)+v(k) Observation equation
#------------------------------------------------------------------
A=1
H=1
Q=0.003 #process noise variance
R=1    #measurement noise variance
u=.05  #velocity

X = [] # true position array
Xhat = [] # estimated position array
Y = [] # measured position array

#Initial conditions
x = 0 # initial state

xhat = x # initial state estimate
p_pos=Q
#------------------------------------------------------------------
for k in range(1, N):
    #Model equation
    w=math.sqrt(Q)*np.random.standard_normal() #process noise
    x=A*x+u+w

    #Observation equation
    v=math.sqrt(R)*np.random.standard_normal() #measurement noise
    y=H*x+v

    #Update equation
    x_prior=A*xhat+u

    # Innovation
    Inn = y - x_prior

    #Covariance of Innovation
    p_prior = A*A*p_pos+Q

    #Gain matrix
    K = H*p_prior/(H*H*p_prior+R)

    #State estimate
    xhat = A * x_prior + K * Inn

    #Covariance of prediction error
    p_pos=p_prior*(1-H*K)

    #Save some parameters in vectors for plotting later
    X.append(x)
    Xhat.append(xhat)
    Y.append(y)
#------------------------------------------------------------------
plt.figure()

plt.plot(range(1, N), X, 'k-.',label='x_k')
plt.plot(range(1, N), Xhat, 'k',label=r'$\hat{x}_k$')
plt.plot(range(1, N), Y, 'k:',label='y_k')

plt.xlabel('Time', fontsize=16)
plt.ylabel('Position', fontsize=16)
plt.legend(fontsize=14)
plt.show(block=True)
