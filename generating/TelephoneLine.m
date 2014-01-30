fr = [697 770 852 941];
fc = [1209 1336 1477];
Fs = 32768;


for k=1:4
    for j=1:3
        
        t = 0:1/Fs:0.25;
        y1 = sin(2*pi*fr(k)*t);
        y2 = sin(2*pi*fc(j)*t);
        y = (y1 + y2)/2;
        sound(y,Fs)
        plot (y,Fs)
    end
end
