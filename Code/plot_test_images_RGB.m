%% plot_test_images
% Plot the effects of various A-things on test images

% Parameters
n_plots = 6;
font_size = 8;

% Pick num_plots images
I = randperm(Ntest/3,n_plots);

% Plot the results of applying Aplant, Asparkle, Asparkle_t, Arobust, Arobust_t to them
figure

% For holding RGB values
RGB = zeros(d1,d2,3);

% Aplant
subplot(6,n_plots+1,1)
text(0.5,0.5,'Planted','HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(6,n_plots+1,i+1)
    j = 3*(I(i)-1)+1;
    RGB(:,:,1) = reshape(Xtest(:,j  ),d1,d2);
    RGB(:,:,2) = reshape(Xtest(:,j+1),d1,d2);
    RGB(:,:,3) = reshape(Xtest(:,j+2),d1,d2);
    imshow(RGB,'InitialMagnification',1000)
end

% Scrambled
subplot(6,n_plots+1,n_plots+2)
text(0.5,0.5,'Scrambled','HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(6,n_plots+1,i+n_plots+2)
    j = 3*(I(i)-1)+1;
    RGB(:,:,1) = reshape(Ytest(:,j  ),d1,d2);
    RGB(:,:,2) = reshape(Ytest(:,j+1),d1,d2);
    RGB(:,:,3) = reshape(Ytest(:,j+2),d1,d2);
    imshow(RGB,'InitialMagnification',1000)
end

% Asparkle
subplot(6,n_plots+1,2*n_plots+3)
text(0.5,0.5,'Sparkle Vision','HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(6,n_plots+1,i+2*n_plots+3)
    j = 3*(I(i)-1)+1;
    RGB(:,:,1) = reshape(Asparkle * Ytest(:,j  ),d1,d2);
    RGB(:,:,2) = reshape(Asparkle * Ytest(:,j+1),d1,d2);
    RGB(:,:,3) = reshape(Asparkle * Ytest(:,j+2),d1,d2);
    imshow(RGB,'InitialMagnification',1000)
end

% Asparkle_t
subplot(6,n_plots+1,3*n_plots+4)
text(0.5,0.5,{'Sparkle Vision','thresholded'},'HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(6,n_plots+1,i+3*n_plots+4)
    j = 3*(I(i)-1)+1;
    RGB(:,:,1) = reshape(Asparkle_t * Ytest(:,j  ),d1,d2);
    RGB(:,:,2) = reshape(Asparkle_t * Ytest(:,j+1),d1,d2);
    RGB(:,:,3) = reshape(Asparkle_t * Ytest(:,j+2),d1,d2);
    imshow(RGB,'InitialMagnification',1000)
end

% Arobust
subplot(6,n_plots+1,4*n_plots+5)
text(0.5,0.5,'Robust','HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(6,n_plots+1,i+4*n_plots+5)
    j = 3*(I(i)-1)+1;
    RGB(:,:,1) = reshape(Arobust * Ytest(:,j  ),d1,d2);
    RGB(:,:,2) = reshape(Arobust * Ytest(:,j+1),d1,d2);
    RGB(:,:,3) = reshape(Arobust * Ytest(:,j+2),d1,d2);
    imshow(RGB,'InitialMagnification',1000)
end

% Arobust_t
subplot(6,n_plots+1,5*n_plots+6)
text(0.5,0.5,{'Robust','thresholded'},'HorizontalAlignment','center','FontSize',font_size)
set(gca,'visible','off')
for i = 1 : n_plots
    subplot(6,n_plots+1,i+5*n_plots+6)
    j = 3*(I(i)-1)+1;
    RGB(:,:,1) = reshape(Arobust_t * Ytest(:,j  ),d1,d2);
    RGB(:,:,2) = reshape(Arobust_t * Ytest(:,j+1),d1,d2);
    RGB(:,:,3) = reshape(Arobust_t * Ytest(:,j+2),d1,d2);
    imshow(RGB,'InitialMagnification',1000)
end

% Remove axes
for i = 1 : 6 * (n_plots+1)
    subplot(6,n_plots+1,i)
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
end

% Title
sgtitle('Digit recovery')