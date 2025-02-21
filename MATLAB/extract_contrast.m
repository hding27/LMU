%% get the contast data from the figure

fig = open('contrast.fig');
h = gcf; % Get the handle to the current figure
axesObjs = get(h, 'Children');
dataObjs = get(axesObjs, 'Children');
secondObj = dataObjs{2};
sequoia_t = get(secondObj(1), 'xdata');
sequoia_i = get(secondObj(1), 'ydata');
tundra_t = get(secondObj(2), 'xdata');
tundra_i = get(secondObj(2), 'ydata');

%% make a new plot to verify the data
figure(67)
plot(sequoia_t, sequoia_i, '-r', 'DisplayName','Sequoia')
hold on
plot(tundra_t, tundra_i,  '-b', 'DisplayName', 'Tundra')
hold off
set(gca, 'YScale', 'log')
legend('show')