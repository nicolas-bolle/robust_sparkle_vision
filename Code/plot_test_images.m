%% plot_test_images
% Plot the effects of various A-things on test images

% Parameters
n_plots = 5;
font_size = 10;

% Pick num_plots images
I = randi(Ntest,n_plots,1);

% Plot the results of applying Aplant, Asparkle, Asparkle_t, Arobust, Arobust_t to them
figure

% Aplant
subplot(5,n_plots+1,1)
text(0.5,0.5,'Planted','HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(5,n_plots+1,i+1)
    imagesc(reshape(Xtest(:,i),d1,d2))
end

% Asparkle
subplot(5,n_plots+1,n_plots+2)
text(0.5,0.5,'Sparkle Vision','HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(5,n_plots+1,i+n_plots+2)
    imagesc(reshape(Asparkle * Ytest(:,i),d1,d2))
end

% Asparkle_t
subplot(5,n_plots+1,2*n_plots+3)
text(0.5,0.5,{'Sparkle Vision','thresholded'},'HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(5,n_plots+1,i+2*n_plots+3)
    imagesc(reshape(Asparkle_t * Ytest(:,i),d1,d2))
end

% Arobust
subplot(5,n_plots+1,3*n_plots+4)
text(0.5,0.5,'Robust','HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(5,n_plots+1,i+3*n_plots+4)
    imagesc(reshape(Arobust * Ytest(:,i),d1,d2))
end

% Arobust_t
subplot(5,n_plots+1,4*n_plots+5)
text(0.5,0.5,{'Robust','thresholded'},'HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(5,n_plots+1,i+4*n_plots+5)
    imagesc(reshape(Arobust_t * Ytest(:,i),d1,d2))
end

% Remove axes
for i = 1 : 5 * (n_plots+1)
    subplot(5,n_plots+1,i)
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
end

% Title
sgtitle('Digit recovery')