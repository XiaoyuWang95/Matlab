h=@sin;

h (0:0.1:2);
feval (h,[0 pi/2 pi pi*3/2 2*pi]);
fplot(h,[0 2*pi]);

quad (h,0,pi);
quad (h,0,2*pi);
quad (h,0,pi/2);

figure;
hold on;

q=@(x) x.^5-9.*x^4+8.*x^3-2.*x.^2+x+500;
fplot(q,[0 10])


 