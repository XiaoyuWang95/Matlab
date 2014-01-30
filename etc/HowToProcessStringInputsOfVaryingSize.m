for ClearScreen= 1:100
  display (' ')
end


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

tic

NameComparator = ' ';

while strcmp (NameComparator,NameNoSpaces) == 0 
  NameComparator = input('Type your name without any spaces.  ','s');  %input indicates user input via keyboard is needed.  's' specifies that the input will be stored as a string aka an array of characters.
  if strcmp (NameComparator,NameNoSpaces) == 0
      display ('Incorrect.  Try again.')
  end 
end

for ClearScreen= 1:100
  display (' ')
end

display ('CORRECT!!! VERY GOOD!!!')


TimeLapsed = toc

display (' seconds')

for ClearScreen= 1:10
  display (' ')
end

display (' ')
display ('Here is another fun game. ')


for i=1:length(Name)              %goal of this loop is to eliminate spaces and numbers from the name and store entire name as one long character. 
    ReverseName(i) =(Name(length(Name)+1-i));       %Is the character a letter?  If so, it is to be included.  If not, it is to be eliminated.
end

tic
NameBackward = ' ';

while strcmp (NameBackward,ReverseName) == 0 
  NameBackward = input('Type your name backwards, including the spaces. ','s');
  if strcmp (NameBackward,ReverseName) == 0
      display ('Incorrect.  Try again.')
  end 
end

for ClearScreen= 1:100
  display (' ')
end

display ('CORRECT!!! VERY GOOD!!!')


TimeLapsed = toc

display (' seconds')

