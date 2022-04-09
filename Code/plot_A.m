%% plot_A
% Plots A and the Sparkle Vision and robust estimates of it

figure

subplot(1,3,1)
imagesc(Aplant)
colorbar
title('Planted')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])

subplot(1,3,2)
imagesc(Asparkle)
colorbar
title('Sparkle Vision')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])

subplot(1,3,3)
imagesc(Arobust)
colorbar
title('Robust')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])

sgtitle('A')