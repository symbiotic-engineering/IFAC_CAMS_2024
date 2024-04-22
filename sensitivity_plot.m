clear; close all
Hs = linspace(0,3);

e1 = 1;
e2 = 1;
e3 = 4/pi;

P_matched = e2 * Hs.^2;

P_linear_mismatch = (1 - (1 - e1./Hs).^2) .* P_matched;
P_linear_mismatch(Hs < 1) = P_matched(Hs < 1);

P_nonlinear_mismatch = (1 - (1 - e3./Hs).^2) .* P_matched;
P_nonlinear_mismatch(Hs < 4/pi) = P_matched(Hs < 4/pi);

figure
plot(Hs,P_matched,'g-',Hs,P_linear_mismatch,'r--',Hs,P_nonlinear_mismatch,':b')
hold on 
plot(1,1,'rd',4/pi,(4/pi)^2,'bd')
xlabel('Normalized Wave Excitation Force $F_e$','interpreter','latex')
ylabel('Normalized Average Power $\bar{P}_L$','interpreter','latex')
legend('Match: $\bar{P}_L = F_e^2$', ...
    'Linear Mismatch: $\bar{P}_L = 2 F_e - 1$', ...
    'Nonlinear Saturation: $\bar{P}_L = \frac{4}{\pi}(2 F_e - \frac{4}{\pi})$','interpreter','latex')
improvePlot
grid on
