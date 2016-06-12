function out=TestCmp(a,b)
%Ez a függvény képes a nem feltétlenül határozott kockákra vonatkozó
%teszteredmények összehasonlítására.
S=size(a);
if S~=size(b)
    error('The size of input arguments must agree.')
end
out=false;
for i=1:S(1)
    for j=1:S(2)
        if a(i,j)==1 && b(i,j)==0
            return
        elseif a(i,j)==0 && b(i,j)==1
            return
        end
    end
end
out=true;
end