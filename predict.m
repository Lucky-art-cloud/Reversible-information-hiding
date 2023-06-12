function p=predict(i,j,g)
a=uint16(g(i+1,j));
b=uint16(g(i,j+1));
c=uint16(g(i+1,j+1));

% a=uint16(g(i,j-1));
% b=uint16(g(i-1,j));
% c=uint16(g(i-1,j-1));
k=a+b-c;
if(a>b)
    max=a;
    min=b;
else
    max=b;
    min=a;
end

if(c<=min)
    p=max;    
elseif(c>=max)
    p=min;
else
    p=k;
end


% if(c>=max)
%     p=min;    
% elseif(c<min)
%     p=max;
% else
%     p=a+b-c;
% end


