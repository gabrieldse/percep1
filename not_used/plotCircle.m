function [] = plotCircle(centers_x, centers_y, radii)
center = [centers_x,centers_y];
viscircles(center, radii, 'EdgeColor', 'r')
txt = ['  (R,x,y) : (  ',num2str(centers_x),'  ,  ',num2str(centers_y),'  ,  ', num2str(radii),'  )'];
hold on
text(centers_x,centers_y,txt);
plot(centers_x, centers_y, 'r+', 'MarkerSize', 10, 'LineWidth', 2)
text(centers_x,centers_y,txt,'Color','White','FontSize',10)

end