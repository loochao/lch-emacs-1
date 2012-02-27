x  = 0:0.2:12;
y1 = BesselJ(1,x);
y2 = BesselJ(2,x);
y3 = BesselJ(3,x);

figure(1);
subplot(2,1,1);
h = plot(x,y1,x,y2,x,y3);
set(h, 'LineWidth', 2, {'LineStyle'}, {'--'; ':'; '-.'});
set(h, {'Color'}, {'r';'g';'b'});
axis([0 12 -0.5 1]);
grid on;
xlabel('Time');
ylabel('Amplitude');
legend(h, 'First', 'Second', 'Third');
[y, ix] = min(y1);
text(x(ix), y, 'First Min \rightarrow', 'HorizontalAlignment', 'right');
