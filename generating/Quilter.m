figure
                     %plot (x,y,'color','#')  # signifies one of 6 colors:
                     %r=red,b=blue,b=black,c=cyan,w=white,g=green
x=0:0.1:20
y=sin(x)
k=1;
while k < 75
    QUILT1(1,:)=x;
    QUILT2(1,:)=y
    QUILT1(2,:)=x;
    QUILT2(2,:)=-y;
    QUILT1(3,:)=-x;
    QUILT2(3,:)=y;
    QUILT1(4,:)=-x;
    QUILT2(4,:)=-y;
    
    hold on
    for count4=1:4 
        plot (QUILT1(count4,:),QUILT2(count4,:),'color','r')
        %pause
    end
    
    for count4=1:4 
        plot (QUILT2(count4,:),QUILT1(count4,:),'color','g')
        %pause
    end
    
    y = y+0.25
    k=k+1
end
    
    
