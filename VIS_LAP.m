classdef VIS_LAP < VISUAL
    %A 3x3x1-es kock�t objektum�t kezel�, �s a kocka t�rbeli
    %elhelyezked�s�t le�r� ortogon�lis m�trixot ismer� objektum.
    %A mez�k a VISUAL sz�l�oszt�lyban vannak deklar�lva. Mivel az oszt�ly a
    %VISUAL oszt�lyon kereszt�l a Handle oszt�lynak is aloszt�lya, az
    %�rt�keket m�dos�t� tagf�ggv�nyeknek nincs sz�ks�g�k a m�dos�tott
    %objektummal val� visszat�r�sre.
    methods
        function obj=VIS_LAP()
            obj.Kocka=LAPOS();
        end
        %A kock�t teker� f�ggv�nyek a t�jol�st k�dol� m�trixt�l f�gg�en
        %h�v�dnak meg:
        function elso(obj)
            F=obj.Nezet'*[0;-1;0];
            if isequal(F,[1;0;0])
                obj.Kocka=obj.Kocka.jobb();
            elseif isequal(F,[0;1;0])
                obj.Kocka=obj.Kocka.fenti();
            elseif isequal(F,[-1;0;0])
                obj.Kocka=obj.Kocka.bal();
            elseif isequal(F,[0;-1;0])
                obj.Kocka=obj.Kocka.lenti();
            end
            obj.Changed=true;
        end
        function hatso(obj)
            F=obj.Nezet'*[0;1;0];
            if isequal(F,[1;0;0])
                obj.Kocka=obj.Kocka.jobb();
            elseif isequal(F,[0;1;0])
                obj.Kocka=obj.Kocka.fenti();
            elseif isequal(F,[-1;0;0])
                obj.Kocka=obj.Kocka.bal();
            elseif isequal(F,[0;-1;0])
                obj.Kocka=obj.Kocka.lenti();
            end
            obj.Changed=true;
        end
        function bal(obj)
            F=obj.Nezet'*[-1;0;0];
            if isequal(F,[1;0;0])
                obj.Kocka=obj.Kocka.jobb();
            elseif isequal(F,[0;1;0])
                obj.Kocka=obj.Kocka.fenti();
            elseif isequal(F,[-1;0;0])
                obj.Kocka=obj.Kocka.bal();
            elseif isequal(F,[0;-1;0])
                obj.Kocka=obj.Kocka.lenti();
            end
            obj.Changed=true;
        end
        function jobb(obj)
            F=obj.Nezet'*[1;0;0];
            if isequal(F,[1;0;0])
                obj.Kocka=obj.Kocka.jobb();
            elseif isequal(F,[0;1;0])
                obj.Kocka=obj.Kocka.fenti();
            elseif isequal(F,[-1;0;0])
                obj.Kocka=obj.Kocka.bal();
            elseif isequal(F,[0;-1;0])
                obj.Kocka=obj.Kocka.lenti();
            end
            obj.Changed=true;
        end
        %Itt is van kever� f�ggv�ny, mely megh�vja LAPOS kever�j�t:
        function kever(obj,lepesszam)
            obj.Kocka=obj.Kocka.kever(lepesszam);
            obj.Changed=true;
        end
        %S vannak a t�jol�st megv�ltoztat� f�ggv�nyek:
        function X(obj)
            %180�-os forgat�s az X-tengely k�r�l.
            obj.Nezet=[[1;0;0],[0;-1;0],[0;0;-1]]*obj.Nezet;
            obj.Changed=true;
        end
        function Y(obj)
            %180�-os forgat�s az Y-tengely k�r�l.
            obj.Nezet=[[-1;0;0],[0;1;0],[0;0;-1]]*obj.Nezet;
            obj.Changed=true;
        end
        function Zp(obj)
            %90�-os forgat�s a Z tengely k�r�l, a Z>0 ir�nyb�l visszan�zve
            %az �ra j�r�s�val ellent�tes ir�nyba.
            obj.Nezet=[[0;1;0],[-1;0;0],[0;0;1]]*obj.Nezet;
            obj.Changed=true;
        end
        function Zm(obj)
            %90�-os forgat�s a Z tengely k�r�l, a Z>0 ir�nyb�l visszan�zve
            %az �ra j�r�s�val egyez� ir�nyba.
            obj.Nezet=[[0;-1;0],[1;0;0],[0;0;1]]*obj.Nezet;
            obj.Changed=true;
        end
        %�s persze van vissza�ll�t� f�ggv�ny:
        function reset(obj)
            obj.Nezet=eye(3);
            obj.Kocka=LAPOS();
            obj.Changed=true;
        end
        function out=IsLapos(obj)
            %A t�jol�st k�dol� m�trix validit�s�nak ellen�rz�se.
            out=obj.IsOrtog();
            if out
                F=obj.Nezet'*[1;0;0];
                if ~isequal(F,[1;0;0]) && ~isequal(F,[0;1;0]) && ~isequal(F,[-1;0;0]) && ~isequal(F,[0;-1;0])
                    out=0;
                end
                F=obj.Nezet'*[0;1;0];
                if ~isequal(F,[1;0;0]) && ~isequal(F,[0;1;0]) && ~isequal(F,[-1;0;0]) && ~isequal(F,[0;-1;0])
                    out=0;
                end
                F=obj.Nezet'*[-1;0;0];
                if ~isequal(F,[1;0;0]) && ~isequal(F,[0;1;0]) && ~isequal(F,[-1;0;0]) && ~isequal(F,[0;-1;0])
                    out=0;
                end
                F=obj.Nezet'*[0;-1;0];
                if ~isequal(F,[1;0;0]) && ~isequal(F,[0;1;0]) && ~isequal(F,[-1;0;0]) && ~isequal(F,[0;-1;0])
                    out=0;
                end
                %if obj.Nezet(3,1) || obj.Nezet(3,2)
                %    out=0;
                %elseif obj.Nezet(2,3) || obj.Nezet(1,3)
                %    out=0;
                %elseif obj.Nezet(1,1)~=1 && obj.Nezet(1,1)~=-1 && obj.Nezet(1,1)~=0
                %    out=0;
                %elseif obj.Nezet(1,2)~=1 && obj.Nezet(1,2)~=-1 && obj.Nezet(1,2)~=0
                %    out=0;
                %elseif obj.Nezet(2,1)~=1 && obj.Nezet(2,1)~=-1 && obj.Nezet(2,1)~=0
                %    out=0;
                %elseif obj.Nezet(2,2)~=1 && obj.Nezet(2,2)~=-1 && obj.Nezet(2,2)~=0
                %    out=0;
                %elseif obj.Nezet(3,3)~=1 && obj.Nezet(3,3)~=-1
                %    out=0;
                %else
                %    prod=1;
                %    for i=1:3
                %        for j=1:3
                %            if obj.Nezet(i,j)
                %                prod=prod*obj.Nezet(i,j);
                %            end
                %        end
                %    end
                %    if prod==-1
                %        out=0;
                %    end
                %end
            end
        end
        function Visual(obj)
            %A kock�t szeml�ltet� f�ggv�nyek megh�v�sa.
            %A 3D fel�leti plotol� csak akkor h�v�dik meg, ha az utols�
            %�br�zol�s �ta v�ltozott ak�r a kockam�trix, ak�r a t�jol�s.
            %A megv�ltozotts�got tartalmaz� objektum szint�n a VISUAL
            %oszt�lyb�l �r�kl�dik.
            display('A kockam�trix:')
            obj.Kocka.writeM(1)
            todisp='[';
            for i=1:3
                if isequal(obj.Nezet(:,i),[1;0;0])
                    todisp=[todisp 'x'];
                elseif isequal(obj.Nezet(:,i),[-1;0;0])
                    todisp=[todisp '-x'];
                elseif isequal(obj.Nezet(:,i),[0;1;0])
                    todisp=[todisp 'y'];
                elseif isequal(obj.Nezet(:,i),[0;-1;0])
                    todisp=[todisp '-y'];
                elseif isequal(obj.Nezet(:,i),[0;0;1])
                    todisp=[todisp 'z'];
                elseif isequal(obj.Nezet(:,i),[0;0;-1])
                    todisp=[todisp '-z'];
                end
                if i==3
                    todisp=[todisp ']'];
                else
                    todisp=[todisp ','];
                end
            end
            display(['A t�jol�s: ' todisp])
            if obj.Changed
                obj.Kocka.Visual3(obj.Nezet)
                obj.Changed=false;
            end
        end
        %Ment�s �s bet�lt�s f�ggv�ny:
        function out=Ment(obj,Nev)
            Nev=[Nev '.dan'];
            FID=fopen(Nev,'w');
            out=1;
            if FID==-1
                return
            end
            try
                obj.Kocka.writeM(FID)
                todisp='[';
                for i=1:3
                    if isequal(obj.Nezet(:,i),[1;0;0])
                        todisp=[todisp '+x'];
                    elseif isequal(obj.Nezet(:,i),[-1;0;0])
                        todisp=[todisp '-x'];
                    elseif isequal(obj.Nezet(:,i),[0;1;0])
                        todisp=[todisp '+y'];
                    elseif isequal(obj.Nezet(:,i),[0;-1;0])
                        todisp=[todisp '-y'];
                    elseif isequal(obj.Nezet(:,i),[0;0;1])
                        todisp=[todisp '+z'];
                    elseif isequal(obj.Nezet(:,i),[0;0;-1])
                        todisp=[todisp '-z'];
                    end
                    if i==3
                        todisp=[todisp ']'];
                    else
                        todisp=[todisp ','];
                    end
                end
                fprintf(FID,todisp);
            catch ME
                fclose(FID);
                return
            end
            fclose(FID);
            out=0;
        end
        function out=Tolt(obj,Nev)
            out=1;
            FID=fopen(Nev,'r');
            if FID==-1
                return
            end
            i=1;
            try
                while ~feof(FID)
                    Line{i,1}=fgetl(FID);
                    i=i+1;
                end
                fclose(FID);
            catch ME
                fclose(FID);
                return
            end
            %try
                if size(Line,1)~=6 || size(Line,2)~=1
                    return
                end
                if size(Line{1},1)~=1 || size(Line{1},2)~=4
                    return
                elseif size(Line{3},1)~=1 || size(Line{3},2)~=4
                    return
                elseif size(Line{5},1)~=1 || size(Line{5},2)~=4
                    return
                elseif size(Line{2},1)~=1 || size(Line{2},2)~=5
                    return
                elseif size(Line{4},1)~=1 || size(Line{4},2)~=5
                    return
                elseif size(Line{6},1)~=1 || size(Line{6},2)~=10
                    return
                end
                if Line{1}(1)~=' '
                    return
                elseif Line{1}(3)~=' '
                    return
                elseif Line{3}(1)~=' '
                    return
                elseif Line{3}(3)~=' '
                    return
                elseif Line{5}(1)~=' '
                    return
                elseif Line{5}(3)~=' '
                    return
                end
                if Line{1}(2)~='0' && Line{1}(2)~='1'
                    return
                elseif Line{1}(4)~='0' && Line{1}(4)~='1'
                    return
                elseif Line{3}(2)~='0' && Line{3}(2)~='1'
                    return
                elseif Line{3}(4)~='0' && Line{3}(4)~='1'
                    return
                elseif Line{5}(2)~='0' && Line{5}(2)~='1'
                    return
                elseif Line{5}(4)~='0' && Line{5}(4)~='1'
                    return
                end
                for i=1:5
                    if Line{2}(i)~='0' && Line{2}(i)~='1'
                        return
                    elseif Line{4}(i)~='0' && Line{4}(i)~='1'
                        return
                    end
                end
                if Line{6}(1)~='['
                    return
                elseif Line{6}(10)~=']'
                    return
                elseif Line{6}(4)~=','
                    return
                elseif Line{6}(7)~=','
                    return
                end
                if Line{6}(3)~='x' && Line{6}(3)~='y' && Line{6}(3)~='z'
                    return
                elseif Line{6}(6)~='x' && Line{6}(6)~='y' && Line{6}(6)~='z'
                    return
                elseif Line{6}(9)~='x' && Line{6}(9)~='y' && Line{6}(9)~='z'
                    return
                elseif Line{6}(2)~='+' && Line{6}(2)~='-'
                    return
                elseif Line{6}(5)~='+' && Line{6}(5)~='-'
                    return
                elseif Line{6}(8)~='+' && Line{6}(8)~='-'
                    return
                end
                for i=1:3
                    if strcmp(Line{6}(3*i-1:3*i),'+x')
                        obj.Nezet(:,i)=[1;0;0];
                    elseif strcmp(Line{6}(3*i-1:3*i),'+y')
                        obj.Nezet(:,i)=[0;1;0];
                    elseif strcmp(Line{6}(3*i-1:3*i),'+z')
                        obj.Nezet(:,i)=[0;0;1];
                    elseif strcmp(Line{6}(3*i-1:3*i),'-x')
                        obj.Nezet(:,i)=[-1;0;0];
                    elseif strcmp(Line{6}(3*i-1:3*i),'-y')
                        obj.Nezet(:,i)=[0;-1;0];
                    elseif strcmp(Line{6}(3*i-1:3*i),'-z')
                        obj.Nezet(:,i)=[0;0;-1];
                    end
                end
                obj.Kocka.oldalak.fenti.forgatas=logical(str2double(Line{2}(3)));
                obj.Kocka.oldalak.lenti.forgatas=logical(str2double(Line{4}(3)));
                obj.Kocka.oldalak.bal.forgatas=logical(str2double(Line{3}(2)));
                obj.Kocka.oldalak.jobb.forgatas=logical(str2double(Line{3}(4)));
                obj.Kocka.sarkak(2,1).forgatas=logical(str2double(Line{2}(2)));
                obj.Kocka.sarkak(2,1).eltolas(1)=logical(str2double(Line{1}(2)));
                obj.Kocka.sarkak(2,1).eltolas(2)=logical(str2double(Line{2}(1)));
                obj.Kocka.sarkak(2,2).forgatas=logical(str2double(Line{2}(4)));
                obj.Kocka.sarkak(2,2).eltolas(1)=logical(str2double(Line{1}(4)));
                obj.Kocka.sarkak(2,2).eltolas(2)=logical(str2double(Line{2}(5)));
                obj.Kocka.sarkak(1,1).forgatas=logical(str2double(Line{4}(2)));
                obj.Kocka.sarkak(1,1).eltolas(1)=logical(str2double(Line{5}(2)));
                obj.Kocka.sarkak(1,1).eltolas(2)=logical(str2double(Line{4}(1)));
                obj.Kocka.sarkak(1,2).forgatas=logical(str2double(Line{4}(4)));
                obj.Kocka.sarkak(1,2).eltolas(1)=logical(str2double(Line{5}(4)));
                obj.Kocka.sarkak(1,2).eltolas(2)=logical(str2double(Line{4}(5)));
                obj.Kocka.Visual3(obj.Nezet)
                out=0;
            %catch ME
            %    return
            %end
        end
    end
end