clear all
clc
close all

%% Power equation on Smith Plot

mag_delta = 0.01;
phase_delta = pi/90;

[MagGamma,PhaseGamma] = meshgrid(0:mag_delta:1, 0:phase_delta:2*pi);
ReGamma = MagGamma .* cos(PhaseGamma);
ImGamma = MagGamma .* sin(PhaseGamma);
gamma = ReGamma + 1i * ImGamma;
z = -(gamma + 1) ./ (gamma - 1);
m1 = real(z);
m2 = imag(z);

power_ratio = 1-MagGamma.^2;
mySmithPlot(ReGamma, ImGamma, power_ratio, 'Power Ratio', true)
colormap(flipud(copper))

%% Current ratio on smith plot
sq_coeff = m2.^2 + (1-m1).^2;
lin_coeff = 4*m2;
const_coeff = m2.^2 + (1+m1).^2;
b_over_a = [-20, -5, -2, -1, 0, 1, 2, 5, 20];

figure(2)
clf
hold on

markers = {'-',':','--','-.','--*'};

for i = 1:length(b_over_a)
    b_a = b_over_a(i);
    sqrt_term = b_a^2 * sq_coeff + b_a * lin_coeff + const_coeff;
    sqrt_term(sqrt_term<0) = 1e-16;
    currentRatio = 2 ./ sqrt(sqrt_term);
    currentTitle = ['Current Ratio $\frac{|I_L|}{|I_L^m|}$, for $\alpha = ', num2str(b_a), '$'];
    showColorbar = b_a == b_over_a(end); % only show colorbar on last plot
    [Z1_non_dom, Z2_non_dom] = mySmithPlot(ReGamma, ImGamma, currentRatio, currentTitle, showColorbar, power_ratio, 'm');
    if b_a >= 0 % only plot positive because pos and neg are the same
        figure(2)
        plot(Z1_non_dom,Z2_non_dom,['m',markers{i-4}],'DisplayName',['|\alpha|=',num2str(b_a)])
    end
end

figure(2)
xlabel('Current Ratio |I_L|/|I_L^m|')
ylabel('Power Ratio P_L/P_L^m')
title('Pareto Front')
legend
improvePlot

%% Voltage Ratio on smith plot

for i = 1:length(b_over_a)
    b_a = b_over_a(i);
    complex_term = z * (1 - b_a * 1i) ./ (1 + z + (1 - z)*b_a*1i);
    voltageRatio = 2/sqrt(1 + b_a^2) * abs(complex_term);
    voltageTitle = ['Voltage Ratio $\frac{|V_L|}{|V_L^m|}$, for $\alpha = ', num2str(b_a),'$'];
    showColorbar = b_a == b_over_a(end); % only show colorbar on last plot
    [Z1_non_dom, Z2_non_dom] = mySmithPlot(ReGamma, ImGamma, voltageRatio, voltageTitle, showColorbar, power_ratio, 'g');
    if b_a >= 0 % only plot positive because pos and neg are the same
        figure(2)
        plot(Z1_non_dom,Z2_non_dom,['g',markers{i-4}],'DisplayName',['|\alpha|=',num2str(b_a)])
    end
end

figure(2)
xlabel('Voltage Ratio |V_L|/|V_L^m|')
ylabel('Power Ratio P_L/P_L^m')
title('Pareto Front')
legend
improvePlot

%% Optimal voltage and current, but symbolic instead of numerical optimum
syms P_ratio real positive
syms alpha real
GamMag = sqrt(1-P_ratio);
num = alpha^2 * GamMag^2 - sqrt( (alpha^2+1)*(alpha^2*GamMag^4 + 1) ) + 1;
den_V = alpha * (1 - GamMag)^2;
den_I = alpha * (1 + GamMag)^2;
V_ratio_opt = 2*atan(num/den_V);
I_ratio_opt = 2*atan(num/den_I);

figure
for i=1:length(b_over_a)
    b_a = b_over_a(i);
    V = subs(V_ratio_opt,alpha,b_a);
    I = subs(I_ratio_opt,alpha,b_a);
    fplot(V,[0 1],'-','DisplayName',['voltage',num2str(b_a)])
    hold on
    fplot(I,[0 1],'--','DisplayName',['current',num2str(b_a)])
    legend
    xlabel('Power Ratio')
    ylabel('Current/Voltage Ratio')
end

%% Pareto tradeoff of voltage and current and power
close all
b_a_pos = [0, 1, 2, 5, 20];

sq_coeff = m2.^2 + (1-m1).^2;
lin_coeff = 4*m2;
const_coeff = m2.^2 + (1+m1).^2;

Gammas = unique(MagGamma);
for j = 1:length(b_a_pos)
    b_a = b_a_pos(j);

    sqrt_term = b_a^2 * sq_coeff + b_a * lin_coeff + const_coeff;
    sqrt_term(sqrt_term<0) = 1e-16;
    currentRatio = 2 ./ sqrt(sqrt_term);

    complex_term = z * (1 - b_a * 1i) ./ (1 + z + (1 - z)*b_a*1i);
    voltageRatio = 2/sqrt(1 + b_a^2) * abs(complex_term);

    p = [-voltageRatio(:), -currentRatio(:), power_ratio(:)]; % assumes max Z is better
    [~, non_dom_idxs] = paretoFront(p);

    vol_opt_path = zeros(length(Gammas),2);
    cur_opt_path = zeros(length(Gammas),2);

    figure
    hold on

    % pink, green shaded patches
    patch([0,2,2,0],[1,1,2,2],'m','FaceAlpha',0.2,'DisplayName','Current Exceeds z=1 Baseline');
    hold on
    patch([1,2,2,1],[0,0,2,2],'g','FaceAlpha',0.2,'DisplayName','Voltage Exceeds z=1 Baseline');

    % Pareto plots for different gamma
    colors = copper(length(Gammas));
    for i=1:length(Gammas)
        idx = non_dom_idxs(ismember(non_dom_idxs, find(MagGamma == Gammas(i))));
        vol = voltageRatio(idx);
        cur = currentRatio(idx);
        [vol_sorted, sort_idx] = sort(vol);
        cur_sorted = cur(sort_idx);
        vol_opt_path(i,:) = [vol_sorted(1), cur_sorted(1)];
        cur_opt_path(i,:) = [vol_sorted(end), cur_sorted(end)];
        plot(vol_sorted,cur_sorted,'HandleVisibility','off','Color',colors(i,:),'LineWidth',1.5)
    end

    % optimal paths
    plot(vol_opt_path(:,1),vol_opt_path(:,2),'g:','DisplayName','Voltage Optimal Path','LineWidth',2.5)
    plot(cur_opt_path(:,1),cur_opt_path(:,2),'m-.','DisplayName','Current Optimal Path','LineWidth',2.5)

    % dummy pareto for legend
    middleIdx = round(length(Gammas)/2);
    plot(NaN,NaN,'DisplayName','Pareto front','Color',colors(middleIdx,:))

    xlabel('Voltage Ratio')
    ylabel('Current Ratio')
    title(['|\alpha| = ',num2str(b_a)])

    xlim([0 2])
    ylim([0 2])
    % plot([0 1],[1 1],'k--','HandleVisibility','off')
    % plot([1 1],[0 1],'k--','HandleVisibility','off')
    legend

    showColorbar = j == length(b_a_pos); % only show colorbar on last plot
    if showColorbar
        % color bar for gamma
        cb = colorbar;
        colormap('copper')
        
        % second color bar for power ratio
        % see https://www.mathworks.com/matlabcentral/answers/475762-colormap-utility-two-axes-in-colorbar
        power_ratio_evenly_spaced = 1 : -0.1 : 0;
        gamma_for_equally_spaced_power_ratio = sqrt(1 - power_ratio_evenly_spaced);
        ax = gca;
        cb2 = axes('Position',cb.Position,'color','none');  % add new axes at same posn
        cb2.XAxis.Visible = 'off';                          % hide the x axis of new
        posn = ax.Position;                                 % get main axes location
        posn(3) = 0.8 * posn(3);                            % cut down width
        ax.Position = posn;           % resize main axes to make room for colorbar labels
        yticks(cb2,gamma_for_equally_spaced_power_ratio);
        yticklabels(cb2, cellstr(string(power_ratio_evenly_spaced)) );
    
        ylabel(cb,'Reflection Coefficient Magnitude |\Gamma|')
        ylabel(cb2,'Power Ratio P_L/P_L^m')
        cb.Position = cb2.Position;  % put the colorbar back to overlay second axeix
    end
    
    improvePlot

    if showColorbar
        set(cb2,'FontWeight','normal','LineWidth',0.5)
        box off
        set(gcf,'Pos',[100 100 850 600]) % make plot wider
    end
end

%% smith plot function
function [Z1_nondom_sorted, Z2_nondom_sorted] = mySmithPlot(X,Y,Z,titleString,showColorbar,Z_pareto_compare,col)
% Z pareto compare and col (color) are optional arguments to trace out an optimal path

    figure('Color',[1 1 1])
    smithplot('TitleTop',titleString,'TitleTopTextInterpreter','latex', ...
        'TitleTopFontSizeMultiplier',1.5)
    hold on
    levs = 0:0.1:1;
    Z_capped = Z;
    Z_capped(Z>1) = NaN;
    contour(X, Y, Z_capped, levs, 'HandleVisibility','off','LineWidth',3);

    grey = [.3 .3 .3];
    red = [.5 .1 .1];

    % colored shading where Z>1
    if max(Z,[],'all') > 1
        Z_caps = Z;
        Z_caps(Z<=1) = NaN;
        contourf(X, Y, Z_caps,0,'FaceColor',col,'FaceAlpha',0.2,'HandleVisibility','off')
        patch(NaN,NaN,col,'FaceAlpha',0.2,'DisplayName','Exceeds z=1 Baseline') % dummy patch for legend
    end

    if showColorbar
        cb = colorbar;
        scale = 0.8; % smaller colorbar to fit smith chart
        cb.Position = [cb.Position(1), cb.Position(2)+0.1, ...
            cb.Position(3)*scale cb.Position(4)*scale];
    end

    if nargin>5
        Z_capped(X==1) = NaN; % don't include far right point because it has 
        % the same value as the far left point (0,0) and will mess up the optimum curve
        p = [-Z_capped(:), Z_pareto_compare(:)]; % assumes max Z is better
        [~, non_dom_idxs] = paretoFront(p);
        non_dom_idxs(ismember(non_dom_idxs, find(isnan(Z_capped)))) = []; % remove nans from pareto front
        Z1_nondom = Z_capped(non_dom_idxs);
        Z2_nondom = Z_pareto_compare(non_dom_idxs);
        [Z1_nondom_sorted,sort_idxs] = sort(Z1_nondom);
        Z2_nondom_sorted = Z2_nondom(sort_idxs);
        
        % red shading where dominated
%         Z_dom = Z_capped;
%         Z_dom(non_dom_idxs) = NaN;
%         contourf(X,Y,Z_dom,0,'FaceColor',red,'HandleVisibility','off')
%         patch(NaN,NaN,red, 'DisplayName','Dominated by other z') % dummy patches for the sake of legend
        
        % trace out nondominated points
        X_opt = X(non_dom_idxs);
        Y_opt = Y(non_dom_idxs);
        plot(X_opt(sort_idxs),Y_opt(sort_idxs),[col '--'],'DisplayName','Optimal','LineWidth',3)
        legend('location','southeast')

        % pareto front with dom and non dom points
        % figure
        % scatter(Z_capped(:),Z_pareto_compare(:),'HandleVisibility','off')
        % hold on
        % 
        % scatter(Z1_nondom, Z2_nondom,'s','Filled','DisplayName',titleString)
        % xlabel(titleString)
        % ylabel('Power Ratio')
        % title('Pareto Front')
        % legend('Interpreter','latex')   
    end
end

