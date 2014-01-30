
for i = 1:40
    display (' ')
end

display ('It is time to play the alphabet soup game. ')
display (' ')
display ('You have to find all the letters of your name in a bowl full of other letters.')

%So now we have a 6X6 matrix of random upper case letters and a 6X6 matrix of lower case letters. We can choose one or the other for our purposes. 

Name = ' ';
NameNoSpaces = ' ';
Name = input('What is your name?  ','s');  %input indicates user input via keyboard is needed.  's' specifies that the input will be stored as a string aka an array of characters.

k=1;  
for i=1:length(Name)              %goal of this loop is to eliminate spaces and numbers from the name and store entire name as one long character. 
    if isletter(Name(i))==1       %Is the character a letter?  If so, it is to be included.  If not, it is to be eliminated.
        NameNoSpaces(k)=Name(i);    %If a letter, add to the 'NameNoSpaces' array.;
        k= k+1;                     %increment k so that it will store next ltter in next char position within array.
    end
end

                                
for i=1:length(NameNoSpaces)
  display (NameNoSpaces)

    
  Mixer= randi (26,6); % makes a 6X6 matrix of random numbers between 1 and 26 inclusive. 
  if (NameNoSpaces(i)-0) > 96 
    UpperCaseMixer = char ((Mixer)+64);  %char is the array of all ascii characters.  Here, we are making a matrix of 6X6 characters derived from the ascii codes encoded in Mixer.
                              % We add 64 to each value in mixer so that all are random values between 65 and 90, the ascii codes for upper case letters. 
    for RowNum = 1:6
        for ColNum = 1:6
          while UpperCaseMixer((7-ColNum),(7-RowNum)) == NameNoSpaces(i)-32 
            UpperCaseMixer ((7-ColNum),(7-RowNum)) = char(randi(26,1)+64);
          end
        end
    end
    
    
    UpperCaseMixer (1,1) = ' ';
    UpperCaseMixer (1,2) = ' ';
    UpperCaseMixer (1,5) = ' ';
    UpperCaseMixer (1,6) = ' ';
    UpperCaseMixer (2,6) = ' ';
    UpperCaseMixer (2,1) = ' ';
    UpperCaseMixer (5,1) = ' ';
    UpperCaseMixer (5,6) = ' ';
    UpperCaseMixer (6,1) = ' ';
    UpperCaseMixer (6,2) = ' ';
    UpperCaseMixer (6,5) = ' ';
    UpperCaseMixer (6,6) = ' ';
    ColumnTarget = randi(6,1);
    RowTarget = randi(6,1);
    UpperCaseMixer (ColumnTarget,RowTarget) = NameNoSpaces(i);
    
    SoupBowl = figure;
    hold on;
    xlim([0.5,6.5]);  %establishes axis range for x axis
    ylim([0.5,6.5]);  %establishes axis range for y axis
    ColumnSpot = 0;
    RowSpot = 0;
    
    for RowNum = 1:6
      for ColNum = 1:6
        SoupLetter= UpperCaseMixer(RowNum,ColNum);  
        SoupColor=text(RowNum,(7-ColNum),SoupLetter);
        set(SoupColor,'color','r','fontsize',20,'FontName','Times');
      end
    end

    
    
    while abs(ColumnSpot-ColumnTarget) > 0.5 | abs(RowSpot-(7-RowTarget)) > 0.5
      pointlocation=ginput(1);  %ginput is a function that allows a mouse-controlled input  of 4 points 
                  %via the graphical interface.  Just click on the graph 4
                %times.  Each click is recorded as a row of 2 values (x
                  %and y coordinates) in the 4 X 2  matrix known as 'a'.
      ColumnSpot = pointlocation(1)
      RowSpot = pointlocation(2)
       if abs(ColumnSpot-ColumnTarget) > 0.5 | abs(RowSpot-(7-RowTarget)) > 0.5
          load laughter
          sound (y)
      end   
    end
    
    
    load chirp
    sound  (y)
    close all
     
  else
    LowerCaseMixer = char ((Mixer)+96);  %char is the array of all ascii characters.  Here, we are making a matrix of 6X6 characters derived from the ascii codes encoded in Mixer.
                              % We add 96 to each value in mixer so that all are random values between 97 and 122, the ascii codes for lower case letters. 
    
    for RowNum = 1:6
        for ColNum = 1:6
          while LowerCaseMixer((7-ColNum),(7-RowNum)) == NameNoSpaces(i)+32 
            LowerCaseMixer ((7-ColNum),(7-RowNum)) = char(randi(26,1)+96);
          end
        end
    end
    
    LowerCaseMixer (1,1) = ' ';
    LowerCaseMixer (1,2) = ' ';
    LowerCaseMixer (1,5) = ' ';
    LowerCaseMixer (1,6) = ' ';
    LowerCaseMixer (2,6) = ' ';
    LowerCaseMixer (2,1) = ' ';
    LowerCaseMixer (5,1) = ' ';
    LowerCaseMixer (5,6) = ' ';
    LowerCaseMixer (6,1) = ' ';
    LowerCaseMixer (6,2) = ' ';
    LowerCaseMixer (6,5) = ' ';
    LowerCaseMixer (6,6) = ' ';
    ColumnTarget = randi(6,1)
    RowTarget = randi(6,1)
    LowerCaseMixer (ColumnTarget,RowTarget) = NameNoSpaces(i);
    
    xlim([0.5,6.5]);  %establishes axis range for x axis
    ylim([0.5,6.5]);  %establishes axis range for y axis
    ColumnSpot = 0;
    RowSpot = 0;

    for RowNum = 1:6
      for ColNum = 1:6
        SoupLetter= LowerCaseMixer(RowNum,ColNum);  
        SoupColor=text(RowNum,(7-ColNum),SoupLetter);
        set(SoupColor,'color','r','fontsize',20,'FontName','Times');
      end
    end

    while abs(ColumnSpot-ColumnTarget) > 0.5 | abs(RowSpot-(7-RowTarget)) > 0.5
      pointlocation=ginput(1);  %ginput is a function that allows a mouse-controlled input  of 4 points 
                  %via the graphical interface.  Just click on the graph 4
                %times.  Each click is recorded as a row of 2 values (x
                  %and y coordinates) in the 4 X 2  matrix known as 'a'.
      ColumnSpot = pointlocation(1)
      RowSpot = pointlocation(2)
      if abs(ColumnSpot-ColumnTarget) > 0.5 | abs(RowSpot-(7-RowTarget)) > 0.5
          load laughter
          sound (y)
      end   
    end
    
    
    load chirp
    sound  (y)
    close all
  end
end

load handel
sound (y)
   
%Other things that need to happen include:
%Use command window to let user know what letter he/she is looking for.
%Turn the mixer matrix into a graph.  
%Hide all axes, ticks and grids.

