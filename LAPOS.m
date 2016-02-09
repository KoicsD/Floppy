classdef LAPOS
    %A 3x3x1-es kocka "m�trix�t" t�rol� objektum.
    %"16 bites" �br�zol�sm�d
    %4 db t�mbbe foglalt sarok, �s 4 db -- szint�n k�z�s objektumba
    %foglalt -- oldal objektum.
    %Az oldalaknak egyik mez�j�k a forgatotts�got jelz� bit, mely azt
    %mutatja meg, hogy az adott kockar�sz az alj�t mutatja-e f�lfel�.
    %A sarokobjektumok a forgatotts�gon k�v�l egy eltol�s mez�t is
    %tartalmaznak. Ez egy 2 elem� vektor, elemei azt adj�k meg, hogy az
    %adott sarok az �tellenes oszlopb�l ill. sorb�l sz�rmazik-e.
    %Mind az oldalaknak, mind a sarkaknak van m�g egy "definit" nev�
    %logikai v�ltoz�juk. Ez azt mutatja meg, hogy az adott elem r�szt
    %vesz-e a szimul�ci�ban. �gy nem kell a kocka minden elem�t megadni, s
    %ez�ltal modellezhet� t�bb kocka�llapot uni�ja.
    properties
       sarkak=[[SAROK() SAROK()];[SAROK() SAROK()]]
       oldalak=OLDALAK()
    end
    methods
        %A 4 forgat�f�ggv�ny:
        % A megfelel� oldalt forgatj�k, a mellette lev� k�t sarkat pedig
        % egym�s forgatva eltoltj�ra cser�lik.
        function obj=bal(obj)
            obj.oldalak.bal=obj.oldalak.bal.forog();
            mem=obj.sarkak(1,1).eltol([true false]);
            obj.sarkak(1,1)=obj.sarkak(2,1).eltol([true false]);
            obj.sarkak(2,1)=mem;
        end
        function obj=jobb(obj)
            obj.oldalak.jobb=obj.oldalak.jobb.forog();
            mem=obj.sarkak(1,2).eltol([true false]);
            obj.sarkak(1,2)=obj.sarkak(2,2).eltol([true false]);
            obj.sarkak(2,2)=mem;
        end
        function obj=fenti(obj)
            obj.oldalak.fenti=obj.oldalak.fenti.forog();
            mem=obj.sarkak(2,1).eltol([false true]);
            obj.sarkak(2,1)=obj.sarkak(2,2).eltol([false true]);
            obj.sarkak(2,2)=mem;
        end
        function obj=lenti(obj)
            obj.oldalak.lenti=obj.oldalak.lenti.forog();
            mem=obj.sarkak(1,1).eltol([false true]);
            obj.sarkak(1,1)=obj.sarkak(1,2).eltol([false true]);
            obj.sarkak(1,2)=mem;
        end
        function obj=kever(obj,N)
            %�sszekever� f�ggv�ny.
            regi=0;
            for n=1:N
                R=rand(1);
                for ind=1:4
                    if R<ind/4
                        uj=ind;
                        break
                    end
                end
                if regi==uj
                    R=1-ind+4*R;
                    for indke=1:3
                        if R<indke/3
                            uj=indke;
                            break
                        end
                    end
                    if uj>=ind
                        uj=uj+1;
                    end
                end
                switch uj
                    case 1
                        obj=obj.fenti();
                    case 2
                        obj=obj.lenti();
                    case 3
                        obj=obj.bal();
                    case 4
                        obj=obj.jobb();
                end
                regi=uj;
            end
        end
        %function obj=reset(obj)
        %    %Helyre�ll�t� f�ggv�ny.
        %    for i=1:2
        %        for j=1:2
        %            obj.sarkak(i,j).eltolas=[false false];
        %            obj.sarkak(i,j).forgatas=false;
        %        end
        %    end
        %    obj.oldalak.fenti.forgatas=false;
        %    obj.oldalak.lenti.forgatas=false;
        %    obj.oldalak.bal.forgatas=false;
        %    obj.oldalak.jobb.forgatas=false;
        %end
        %Tesztf�ggv�nyek a kocka kirakhat�s�g�ra:
        function out=IsDefinit(obj)
            %Annak ellen�rz�se, hogy a kocka minden eleme defini�lva van-e.
            out=true;
            for i=1:2
                for j=1:2
                    if ~obj.sarkak(i,j).definit
                        out=false;
                        return
                    end
                end
            end
            if ~obj.oldalak.fenti.definit || ~obj.oldalak.lenti.definit || ...
                    ~obj.oldalak.bal.definit || ~obj.oldalak.jobb.definit
                out=false;
                return
            end
        end
        function out=CanbeLapos(obj)
            %Annak ellen�rz�se, hogy egy (nem felt�tlen�l hat�rozott) kocka
            %sarokelemei k�l�nb�znek-e, vagyis lehet-e benne 4 k�l�nb�z�
            %sarokelem.
            %(Ha hamissal t�r vissza, b�rmik is legyenek a
            %hat�rozatlan elemek, a kock�t �sszekever�s k�zben biztos,
            %hogy sz�tcsavarozt�k, s elemeit egy m�sik sz�tcsavaroztott
            %kocka elemeivel �sszekevert�k.)
            out=false;
            %EL�sz�r vesz�nk egy 2x2-es hamis m�trixot:
            M=false(2);
            %Majd v�gighaladunk a 4 sarkon,
            for i=1:2
                for j=1:2
                    if obj.sarkak(i,j).definit
                        %megn�zz�k, hogy a hat�rozott sarkak honnan j�ttek,
                        ind=mod(obj.sarkak(i,j).eltolas+[i j]+1,2)+1;
                        %s a m�trix megfelel� elemeit igazz� tessz�k, felt�ve,
                        %hogy m�g nem azok:
                        if ~M(ind(1),ind(2))
                            M(ind(1),ind(2))=true;
                        else
                            %Ha az adott elem m�r igaz volt, akkor m�r
                            %nincs �rtelme tov�bb vizsg�l�gni, hisz
                            %tal�ltunk 2 egyforma sarkat:
                            return
                        end
                    end
                end
            end
            %Ha nem volt k�t egyforma sarok, a kocka �tment a teszten:
            out=true;
        end
        function out=IsLapos(obj)
            %Annyival b�vebb az el�z� f�ggv�nyn�l, hogy el�sz�r az
            %IsDefinit() f�ggv�ny seg�ts�g�vel ellen�rzi, hogy minden elem
            %hat�rozott-e. (Viszont maga a teszt egy m�sik, csak hat�rozott
            %kock�kon alkalmazhat� m�dszert haszn�l).
            out=true;
            if ~IsDefinit(obj)
                out=false;
                return
            end
            % A teszt alapja a t�megk�z�ppont megmarad�s�nak t�rv�nye:
            % a sarkak eltol�svektorainak �sszege invari�ns a sarkak
            % permut�l�s�ra (mindig nullvektor):
            sum=[0 0];
            for i=1:2
                for j=1:2
                    %Persze az eltol�svektorok �sszege az eltol�sbitek
                    %el�jeles �sszeg�t jelenti:
                    sum=sum+[(-1)^i (-1)^j].*double(obj.sarkak(i,j).eltolas);
                end
            end
            if sum(1) || sum(2)
                out=false;
                return
            end
            % A t�megk�z�pponti m�dszer azonban csak azt garant�lja, hogy
            % pontosan 2 lenti, 2 fenti, 2 bal �s 2 jobb sarok van.
            % Azt m�r nem garant�lja, hogy a 2 fenti/lenti sarok k�z�l 1 jobb
            % �s 1 bal. Ezt k�l�n meg kell vizsg�lni:
            for i=1:2
                if obj.sarkak(i,1).eltolas(1)==obj.sarkak(i,2).eltolas(1)...
                        && obj.sarkak(i,1).eltolas(2)~=obj.sarkak(i,2).eltolas(2)
                    out=false;
                    return
                end
            end
        end
        function out=CornerTest(obj)
            %Sarok-teszt.
            %Egy kirakhat� kocka egyes sarkainak forgatotts�gi �llapot�t
            %egy�rtelm�en meghat�rozza azok elhelyezked�se. Ez a f�ggv�ny
            %azt ellen�rzi, mely sarokelemek nem engedelmeskednek ennek a
            %t�rv�nynek.
            %A visszat�r�si �rt�k egy 2x2-es logikai m�trix. Ha m�trixnak
            %van igaz eleme, a kocka nem rakhat� ki.
            %Figyelem: A f�ggv�nyt csak akkor haszn�ljuk, ha meggy�z�dt�nk
            %r�la, hogy a kocka teljesen hat�rozott, �s 4 k�l�nb�z�
            %sarokeleme van (IsLapos()==true)! (A f�ggv�ny nem tartalmaz
            %vonatkoz� ellen�rz�st.)
            out= false(2);
            %V�gigmegy�nk a sarkakon:
            for i=1:2
                for j=1:2
                    %Ha az adott sarokn�l eltol�s �s forgat�s
                    %k�zt nincs �sszhang,
                    if (obj.sarkak(i,j).forgatas)~=...
                            (obj.sarkak(i,j).eltolas(1)~=obj.sarkak(i,j).eltolas(2))
                        %megn�zz�k, honnan j�tt a sarok,
                        ind=mod([i j]+obj.sarkak(i,j).eltolas+1,2)+1;
                        %s a kimenet megfelel� elem�t igazz� tessz�k:
                        out(ind(1),ind(2))=true;
                    end
                end
            end
        end
        function out=UCornerTest(obj)
            %Sarokteszt nem felt�tlen�l hat�rozott kock�ra.
            %Most azonban logikai v�ltoz�k helyett 8 bites integerekb�l �ll
            %a visszat�r� m�trix, mely (a double t�pusn�l j�val kisebb
            %mem�riater�let haszn�lat�val) lehet�v� teszi, a
            %hat�rozatlan sarkak -1 �rt�kkel t�rt�n� megjel�l�s�t.
            %Figyelem: A teszt eredm�nye csak akkor haszn�lhat�, ha a
            %hat�rozott sarokelemek k�l�nb�znek (CanbeLapos()==1)!
            out= int8(-ones(2));
            %V�gigmegy�nk a sarkakon:
            for i=1:2
                for j=1:2
                    if obj.sarkak(i,j).definit
                        %Megn�zz�k, honnan j�tt a sarok:
                        ind=mod([i j]+obj.sarkak(i,j).eltolas+1,2)+1;
                        if (obj.sarkak(i,j).forgatas)~=...
                                (obj.sarkak(i,j).eltolas(1)~=obj.sarkak(i,j).eltolas(2))
                            %Ha az akt�v sarkakn�l eltol�s �s forgat�s
                            %k�zt nincs �sszhang,
                            %a kimenet megfelel� elem�t 1-gy�
                            %tessz�k:
                            out(ind(1),ind(2))=1;
                        else
                            %Ha van �sszhang, akkor 0-v�:
                            out(ind(1),ind(2))=0;
                        end
                    end
                end
            end
        end
        function out=ParityTest(obj)
            %Parit�s-teszt.
            %Annak ellen�rz�se, hogy a sarkak permut�ci�j�nak
            %�s a felford�tott oldalelemek sz�m�nak parit�sa elt�r�-e.
            %Ha a k�t parit�s elt�r (a f�ggv�ny igazzal t�r vissza),
            %a kocka nem rakhat� ki (�sszekever�s k�zben sz�tcsavarozt�k).
            %Figyelem: A f�ggv�nyt csak akkor haszn�ljuk, ha meggy�z�dt�nk
            %r�la, hogy a kocka teljesen hat�rozott, �s 4 k�l�nb�z�
            %sarokeleme van (IsLapos()==true)! (A f�ggv�ny nem tartalmaz
            %vonatkoz� ellen�rz�st.)
            out=false;
            eredet=zeros(2);
            k=1;
            %Egy perm nev� 4-es vektorba kifejtj�k a sarkok permut�ci�j�t:
            for i=1:2
                for j=1:2
                    eredet(mod(i+obj.sarkak(i,j).eltolas(1)-1,2)+1,...
                        mod(j+obj.sarkak(i,j).eltolas(2)-1,2)+1)=k;
                    k=k+1;
                end
            end
            perm=zeros(1,4);
            k=1;
            for i=1:2
                for j=1:2
                    perm(k)=eredet(i,j);
                    k=k+1;
                end
            end
            %Megvizsg�ljuk az inverzi�i sz�m parit�s�t:
            tolpar=1;
            for i=1:3
                for j=i:4
                    if perm(i)>perm(j)
                        tolpar=tolpar*(-1);
                    end
                end
            end
            %Majd a felforditott oldalak sz�m�nak parit�s�t:
            forgpar=1;
            if obj.oldalak.jobb.forgatas
                forgpar=forgpar*(-1);
            end
            if obj.oldalak.bal.forgatas
                forgpar=forgpar*(-1);
            end
            if obj.oldalak.fenti.forgatas
                forgpar=forgpar*(-1);
            end
            if obj.oldalak.lenti.forgatas
                forgpar=forgpar*(-1);
            end
            %V�g�l a k�t parit�s �sszehasonl�t�sa:
            if forgpar~=tolpar
                out=true;
            end
        end
        function out=UParityTest(obj)
            %Parit�steszt nem felt�tlen�l hat�rozott kock�ra.
            %Ez a f�ggv�ny is 1-el jelzi a kisz�rt, �s 0-val az �tment
            %kock�t. Ha azonban a kock�nak van hat�rozatlan eleme, -1-gyel
            %t�r vissza (olyankor a parit�s-teszt nem v�gezhet� el).
            %A visszat�r�si �rt�k t�pusa 8 bites integer.
            %Figyelem: A teszt eredm�nye csak akkor haszn�lhat�, ha a
            %hat�rozott sarokelemek k�l�nb�znek (CanbeLapos()==1)!
            out=int8(-1);
            eredet=zeros(2);
            k=1;
            %Egy perm nev� 4-es vektorba kifejtj�k a sarkok permut�ci�j�t:
            for i=1:2
                for j=1:2
                    %Ha az (i,j) sarok hat�rozatlan, v�ge a vizsg�latnak:
                    if ~obj.sarkak(i,j).definit
                        return
                    end
                    eredet(mod(i+obj.sarkak(i,j).eltolas(1)-1,2)+1,...
                        mod(j+obj.sarkak(i,j).eltolas(2)-1,2)+1)=k;
                    k=k+1;
                end
            end
            perm=zeros(1,4);
            k=1;
            for i=1:2
                for j=1:2
                    perm(k)=eredet(i,j);
                    k=k+1;
                end
            end
            %Megvizsg�ljuk az inverzi�i sz�m parit�s�t:
            tolpar=1;
            for i=1:3
                for j=i:4
                    if perm(i)>perm(j)
                        tolpar=tolpar*(-1);
                    end
                end
            end
            %Majd a felforditott oldalak sz�m�nak parit�s�t:
            forgpar=1;
            if ~obj.oldalak.jobb.definit
                %Persze ha az adott oldal hat�rozatlan, akkor v�ge:
                return
            elseif obj.oldalak.jobb.forgatas
                forgpar=forgpar*(-1);
            end
            if ~obj.oldalak.bal.definit
                return
            elseif obj.oldalak.bal.forgatas
                forgpar=forgpar*(-1);
            end
            if ~obj.oldalak.fenti.definit
                return
            elseif obj.oldalak.fenti.forgatas
                forgpar=forgpar*(-1);
            end
            if ~obj.oldalak.lenti.definit
                return
            elseif obj.oldalak.lenti.forgatas
                forgpar=forgpar*(-1);
            end
            %V�g�l a k�t parit�s �sszehasonl�t�sa:
            if forgpar~=tolpar
                out=int8(1);
            else
                out=int8(0);
            end
        end
        function out=CanbeSolvable(obj)
            %Annak vizsg�lata, hogy a kock�t kieg�sz�tve a hat�rozatlan
            %elemekkel kaphatunk-e kirakhat� kock�t.
            %Amennyiben kaphatunk kirakhat� kock�t, �gy a f�ggv�ny logikai
            %igazzal, ellenkez� esetben hamissal t�r vissza.
            %A f�ggv�ny megh�vja a CanbeLapos(), s annak igazzal t�rt�n�
            %visszat�r�se eset�n az UParityTest() �s az UCornerTest()
            %f�ggv�nyeket is.
            out=false;
            if obj.CanbeLapos()
                if TestCmp(obj.UCornerTest(),false(2)) &&...
                        obj.UParityTest()==0
                    out=true;
                end
            end
            %M�sik �t:
            %out=false;
            %if ~obj.CanbeLapos()
            %    return
            %end
            %if obj.UParityTest()==1
            %    return
            %end
            %M=obj.UCornerTest();
            %for i=1:2
            %    for j=1:2
            %        if M(i,j)==1
            %            return
            %        end
            %    end
            %end
            %out=true;
        end
        function out=IsSolvable(obj)
            %Annak ellen�rz�se, hogy a kocka hat�rozott �s kirakhat�-e.
            %Kirakhat� kocka eset�n igazzal, nem kirakhat� kocka eset�n
            %hamissal t�r vissza a f�ggv�ny.
            %A f�ggv�ny megh�vja az IsLapos(), s annak igazzal t�rt�n�
            %visszat�r�se eset�n a ParityTest() �s a CornerTest()
            %f�ggv�nyeket is.
            out=false;
            if obj.IsLapos()
                if isequal(obj.CornerTest(),false(2)) &&...
                        ~obj.ParityTest()
                    out=true;
                end
            end
        end
        function out=CanbeSolved(obj)
            %Annak vizsg�lata, hogy a kock�t kieg�sz�tve a hat�rozatlan
            %elemekkel kaphatunk-e kirakott kock�t. (A hat�rozott elemek
            %forgat�s �s eltol�s bitjei hamisak-e.)
            %Amennyiben kaphatunk kirakott kock�t, �gy a f�ggv�ny logikai
            %igazzal, ellenkez� esetben hamissal t�r vissza.
            out=false;
            for i=1:2
                for j=1:2
                    if obj.sarkak(i,j).definit
                        if obj.sarkak(i,j).eltolas(1) || ...
                                obj.sarkak(i,j).eltolas(2) || obj.sarkak(i,j).forgatas
                            return
                        end
                    end
                end
            end
            if obj.oldalak.fenti.definit && obj.oldalak.fenti.forgatas
                return
            end
            if obj.oldalak.lenti.definit && obj.oldalak.lenti.forgatas
                return
            end
            if obj.oldalak.bal.definit && obj.oldalak.bal.forgatas
                return
            end
            if obj.oldalak.jobb.definit && obj.oldalak.jobb.forgatas
                return
            end
            out=true;
        end
        function out=IsSolved(obj)
            %Annak ellen�rz�se, hogy a kocka hat�rozott-e �s ki van-e rakva
            %(minden elem definit bitje igaz-e, eltol�s �s forgat�s bitje
            %pedig hamis-e). Kirakott kocka eset�n logikai igazzal,
            %ellenkez� esetben hamissal t�r vissza.
            %A f�ggv�ny megh�vja az IsDefinit() f�ggv�nyt is!
            out=false;
            if ~obj.IsDefinit()
                return
            end
            for i=1:2
                for j=1:2
                    if obj.sarkak(i,j).eltolas(1) || obj.sarkak(i,j).eltolas(2) ...
                            || obj.sarkak(i,j).forgatas
                        return
                    end
                end
            end
            if obj.oldalak.fenti.forgatas || obj.oldalak.lenti.forgatas ...
                    || obj.oldalak.bal.forgatas || obj.oldalak.jobb.forgatas
                return
            end
            out=true;
        end
        %Megjelen�t� f�ggv�nyek:
        function writeM(obj,FID)
            %A kockam�trix parancssorba vagy f�jlba �r�sa.
            if nargin==1
                FID=1;
            end
            %Sz�k�z�kb�l �ll� 5x5-�s karakterm�trix:
            M=char(double(' ')*ones(5));
            %Majd az elemek egyenk�nt fel�l�r�sa:
            if obj.sarkak(1,1).definit
                M(4,2)=num2str(obj.sarkak(1,1).forgatas);
                M(5,2)=num2str(obj.sarkak(1,1).eltolas(1));
                M(4,1)=num2str(obj.sarkak(1,1).eltolas(2));
            else
                M(4,2)='u';
            end
            if obj.sarkak(1,2).definit
                M(4,4)=num2str(obj.sarkak(1,2).forgatas);
                M(5,4)=num2str(obj.sarkak(1,2).eltolas(1));
                M(4,5)=num2str(obj.sarkak(1,2).eltolas(2));
            else
                M(4,4)='u';
            end
            if obj.sarkak(2,1).definit
                M(2,2)=num2str(obj.sarkak(2,1).forgatas);
                M(1,2)=num2str(obj.sarkak(2,1).eltolas(1));
                M(2,1)=num2str(obj.sarkak(2,1).eltolas(2));
            else
                M(2,2)='u';
            end
            if obj.sarkak(2,2).definit
                M(2,4)=num2str(obj.sarkak(2,2).forgatas);
                M(1,4)=num2str(obj.sarkak(2,2).eltolas(1));
                M(2,5)=num2str(obj.sarkak(2,2).eltolas(2));
            else
                M(2,4)='u';
            end
            if obj.oldalak.lenti.definit
                M(4,3)=num2str(obj.oldalak.lenti.forgatas);
            else
                M(4,3)='u';
            end
            if obj.oldalak.fenti.definit
                M(2,3)=num2str(obj.oldalak.fenti.forgatas);
            else
                M(2,3)='u';
            end
            if obj.oldalak.bal.definit
                M(3,2)=num2str(obj.oldalak.bal.forgatas);
            else
                M(3,2)='u';
            end
            if obj.oldalak.jobb.definit
                M(3,4)=num2str(obj.oldalak.jobb.forgatas);
            else
                M(3,4)='u';
            end
            %V�g�l f�jlba/parancssorra k�ld�s:
            fprintf(FID,[M(1,1:4) '\n'])
            fprintf(FID,[M(2,1:5) '\n'])
            fprintf(FID,[M(3,1:4) '\n'])
            fprintf(FID,[M(4,1:5) '\n'])
            fprintf(FID,[M(5,1:4) '\n'])
        end
        function Visual3(obj,Nezet)
           %A kocka perspektivikus megjelen�t�se.
           %A f�ggv�ny v�r egy (ortogon�lis) m�trixot is, mely a kocka
           %t�rbeli t�jol�s�r�l ad inform�ci�t.
           %Ha nem kap m�trixot, 3x3-as egys�gm�trix az alap�rtelmezett:
           if nargin==1
               Nezet=eye(3);
           end
           % Sz�nk�dok:
           P=56;
           N=48;
           S=40;
           Z=32;
           K=8;
           F=64;
           % A k�z�ppontja az origo, m�rete 3x3x1, a l�p�sk�z 0.1:
           x=-1.5:0.1:1.5;
           y=x;
           z=-0.5:0.1:0.5;
           % Fels� lap (Z=1.5):
           X=zeros(size(y,2),size(x,2));%X koordin�t�k a 3D fel�letplothoz
           Y=zeros(size(y,2),size(x,2));%Y koordin�t�k a 3D fel�letplothoz
           H=zeros(size(y,2),size(x,2));%Z koordin�t�k a 3D fel�letplothoz
           C=ones(size(y,2),size(x,2));%Sz�nek a 3D fel�letplothoz
           for i=1:size(y,2)
               %A 3x3 n�gyzet indexel�se a SW v�ltoz� �s a switch parancs
               %seg�ts�g�vel a sz�nek meghat�roz�s�hoz:
               if y(i)<-0.5
                   sw='l';
               elseif y(i)>-0.5 && y(i)<0.5
                   sw='k';
               elseif y(i)>0.5
                   sw='f';
               else
                   sw='v';
               end
               for j=1:size(x,2)
                   if x(j)<-0.5
                       SW=[sw 'l'];
                   elseif x(j)>-0.5 && x(j)<0.5
                       SW=[sw 'k'];
                   elseif x(j)>0.5
                       SW=[sw 'f'];
                   else
                       SW=[sw 'v'];
                   end
                   %K�zben a koordin�t�k meghat�roz�sa
                   %Saj�t rendszer -- Z=0.5 s�k:
                   xx=x(j);
                   yy=y(i);
                   hh=0.5;
                   Sajat=[xx;yy;hh];
                   %Labor rendszer -- Transzform�ci� a kapott m�trixszal:
                   Labor=Nezet*Sajat;
                   X(i,j)=Labor(1);
                   Y(i,j)=Labor(2);
                   H(i,j)=Labor(3);
                   switch SW
                       %A sz�nek meghat�roz�sa:
                       case 'll'
                           if obj.sarkak(1,1).definit
                               if obj.sarkak(1,1).forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                       case 'lk'
                           if obj.oldalak.lenti.definit
                               if obj.oldalak.lenti.forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                       case 'lf'
                           if obj.sarkak(1,2).definit
                               if obj.sarkak(1,2).forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                       case 'kl'
                           if obj.oldalak.bal.definit
                               if obj.oldalak.bal.forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                       case 'kk'
                           C(i,j)=S;
                       case 'kf'
                           if obj.oldalak.jobb.definit
                               if obj.oldalak.jobb.forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                       case 'fl'
                           if obj.sarkak(2,1).definit
                               if obj.sarkak(2,1).forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                       case 'fk'
                           if obj.oldalak.fenti.definit
                               if obj.oldalak.fenti.forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                       case 'ff'
                           if obj.sarkak(2,2).definit
                               if obj.sarkak(2,2).forgatas
                                   C(i,j)=F;
                               else
                                   C(i,j)=S;
                               end
                           end
                   end
               end
           end
           % Az �br�zol�s:
           surf(X,Y,H,C)
           hold on
           % Als� lap (Z=-1.5):
           X=zeros(size(y,2),size(x,2));
           Y=zeros(size(y,2),size(x,2));
           H=zeros(size(y,2),size(x,2));
           C=ones(size(y,2),size(x,2));
           for i=1:size(y,2)
               if y(i)<-0.5
                   sw='l';
               elseif y(i)>-0.5 && y(i)<0.5
                   sw='k';
               elseif y(i)>0.5
                   sw='f';
               else
                   sw='v';
               end
               for j=1:size(x,2)
                   if x(j)<-0.5
                       SW=[sw 'l'];
                   elseif x(j)>-0.5 && x(j)<0.5
                       SW=[sw 'k'];
                   elseif x(j)>0.5
                       SW=[sw 'f'];
                   else
                       SW=[sw 'v'];
                   end
                   xx=x(j);
                   yy=y(i);
                   hh=-0.5;
                   Sajat=[xx;yy;hh];
                   Labor=Nezet*Sajat;
                   X(i,j)=Labor(1);
                   Y(i,j)=Labor(2);
                   H(i,j)=Labor(3);
                   switch SW
                       case 'll'
                           if obj.sarkak(1,1).definit
                               if obj.sarkak(1,1).forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                       case 'lk'
                           if obj.oldalak.lenti.definit
                               if obj.oldalak.lenti.forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                       case 'lf'
                           if obj.sarkak(1,2).definit
                               if obj.sarkak(1,2).forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                       case 'kl'
                           if obj.oldalak.bal.definit
                               if obj.oldalak.bal.forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                       case 'kk'
                           C(i,j)=F;
                       case 'kf'
                           if obj.oldalak.jobb.definit
                               if obj.oldalak.jobb.forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                       case 'fl'
                           if obj.sarkak(2,1).definit
                               if obj.sarkak(2,1).forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                       case 'fk'
                           if obj.oldalak.fenti.definit
                               if obj.oldalak.fenti.forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                       case 'ff'
                           if obj.sarkak(2,2).definit
                               if obj.sarkak(2,2).forgatas
                                   C(i,j)=S;
                               else
                                   C(i,j)=F;
                               end
                           end
                   end
               end
           end
           surf(X,Y,H,C)
           % H�ts� (fenti) lap (Y=1.5):
           X=zeros(size(z,2),size(x,2));
           Y=zeros(size(z,2),size(x,2));
           H=zeros(size(z,2),size(x,2));
           C=ones(size(z,2),size(x,2));
           for i=1:size(z,2)
               %Itt (�s a tov�bbiakban) m�r csak 1x3 n�gyzet van:
               if z(i)>-0.5 && z(i)<0.5
                   sw='k';
               else
                   sw='v';
               end
               for j=1:size(x,2)
                   if x(j)<-0.5
                       SW=[sw 'l'];
                   elseif x(j)>-0.5 && x(j)<0.5
                       SW=[sw 'k'];
                   elseif x(j)>0.5
                       SW=[sw 'f'];
                   else
                       SW=[sw 'v'];
                   end
                   %Saj�t rendszerben az Y=1.5 s�kr�l van sz�:
                   xx=x(j);
                   yy=1.5;
                   hh=z(i);
                   Sajat=[xx;yy;hh];
                   Labor=Nezet*Sajat;
                   X(i,j)=Labor(1);
                   Y(i,j)=Labor(2);
                   H(i,j)=Labor(3);
                   switch SW
                       case 'kl'
                           if obj.sarkak(2,1).definit
                               if obj.sarkak(2,1).forgatas
                                   if obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=N;
                                   elseif obj.sarkak(2,1).eltolas(1) && ~obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=K;
                                   elseif ~obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=P;
                                   else
                                       C(i,j)=Z;
                                   end
                               else
                                   if obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=K;
                                   elseif obj.sarkak(2,1).eltolas(1) && ~obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=Z;
                                   elseif ~obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=N;
                                   else
                                       C(i,j)=P;
                                   end
                               end
                           end
                       case 'kk'
                           C(i,j)=P;
                       case 'kf'
                           if obj.sarkak(2,2).definit
                               if obj.sarkak(2,2).forgatas
                                   if obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=Z;
                                   elseif obj.sarkak(2,2).eltolas(1) && ~obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=K;
                                   elseif ~obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=P;
                                   else
                                       C(i,j)=N;
                                   end
                               else
                                   if obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=K;
                                   elseif obj.sarkak(2,2).eltolas(1) && ~obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=N;
                                   elseif ~obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=Z;
                                   else
                                       C(i,j)=P;
                                   end
                               end
                           end
                   end
               end
           end
           surf(X,Y,H,C)
           % Jobb lap (X=1.5):
           X=zeros(size(z,2),size(y,2));
           Y=zeros(size(z,2),size(y,2));
           H=zeros(size(z,2),size(y,2));
           C=ones(size(z,2),size(y,2));
           for i=1:size(z,2)
               if z(i)>-0.5 && z(i)<0.5
                   sw='k';
               else
                   sw='v';
               end
               for j=1:size(x,2)
                   if y(j)<-0.5
                       SW=[sw 'l'];
                   elseif y(j)>-0.5 && y(j)<0.5
                       SW=[sw 'k'];
                   elseif y(j)>0.5
                       SW=[sw 'f'];
                   else
                       SW=[sw 'v'];
                   end
                   xx=1.5;
                   yy=y(j);
                   hh=z(i);
                   Sajat=[xx;yy;hh];
                   Labor=Nezet*Sajat;
                   X(i,j)=Labor(1);
                   Y(i,j)=Labor(2);
                   H(i,j)=Labor(3);
                   switch SW
                       case 'kl'
                           if obj.sarkak(1,2).definit
                               if obj.sarkak(1,2).forgatas
                                   if obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=P;
                                   elseif obj.sarkak(1,2).eltolas(1) && ~obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=N;
                                   elseif ~obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=Z;
                                   else
                                       C(i,j)=K;
                                   end
                               else
                                   if obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=Z;
                                   elseif obj.sarkak(1,2).eltolas(1) && ~obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=P;
                                   elseif ~obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=K;
                                   else
                                       C(i,j)=N;
                                   end
                               end
                           end
                       case 'kk'
                           C(i,j)=N;
                       case 'kf'
                           if obj.sarkak(2,2).definit
                               if obj.sarkak(2,2).forgatas
                                   if obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=K;
                                   elseif obj.sarkak(2,2).eltolas(1) && ~obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=N;
                                   elseif ~obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=Z;
                                   else
                                       C(i,j)=P;
                                   end
                               else
                                   if obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=Z;
                                   elseif obj.sarkak(2,2).eltolas(1) && ~obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=K;
                                   elseif ~obj.sarkak(2,2).eltolas(1) && obj.sarkak(2,2).eltolas(2)
                                       C(i,j)=P;
                                   else
                                       C(i,j)=N;
                                   end
                               end
                           end
                   end
               end
           end
           surf(X,Y,H,C)
           % Bal lap (X=-1.5):
           X=zeros(size(z,2),size(y,2));
           Y=zeros(size(z,2),size(y,2));
           H=zeros(size(z,2),size(y,2));
           C=ones(size(z,2),size(y,2));
           for i=1:size(z,2)
               if z(i)>-0.5 && z(i)<0.5
                   sw='k';
               else
                   sw='v';
               end
               for j=1:size(y,2)
                   if y(j)<-0.5
                       SW=[sw 'l'];
                   elseif y(j)>-0.5 && y(j)<0.5
                       SW=[sw 'k'];
                   elseif y(j)>0.5
                       SW=[sw 'f'];
                   else
                       SW=[sw 'v'];
                   end
                   xx=-1.5;
                   yy=y(j);
                   hh=z(i);
                   Sajat=[xx;yy;hh];
                   Labor=Nezet*Sajat;
                   X(i,j)=Labor(1);
                   Y(i,j)=Labor(2);
                   H(i,j)=Labor(3);
                   switch SW
                       case 'kl'
                           if obj.sarkak(1,1).definit
                               if obj.sarkak(1,1).forgatas
                                   if obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=P;
                                   elseif obj.sarkak(1,1).eltolas(1) && ~obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=Z;
                                   elseif ~obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=N;
                                   else
                                       C(i,j)=K;
                                   end
                               else
                                   if obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=N;
                                   elseif obj.sarkak(1,1).eltolas(1) && ~obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=P;
                                   elseif ~obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=K;
                                   else
                                       C(i,j)=Z;
                                   end
                               end
                           end
                       case 'kk'
                           C(i,j)=Z;
                       case 'kf'
                           if obj.sarkak(2,1).definit
                               if obj.sarkak(2,1).forgatas
                                   if obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=K;
                                   elseif obj.sarkak(2,1).eltolas(1) && ~obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=Z;
                                   elseif ~obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=N;
                                   else
                                       C(i,j)=P;
                                   end
                               else
                                   if obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=N;
                                   elseif obj.sarkak(2,1).eltolas(1) && ~obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=K;
                                   elseif ~obj.sarkak(2,1).eltolas(1) && obj.sarkak(2,1).eltolas(2)
                                       C(i,j)=P;
                                   else
                                       C(i,j)=Z;
                                   end
                               end
                           end
                   end
               end
           end
           surf(X,Y,H,C)
           % Els� (lenti) lap (Y=-1.5):
           X=zeros(size(z,2),size(x,2));
           Y=zeros(size(z,2),size(x,2));
           H=zeros(size(z,2),size(x,2));
           C=ones(size(z,2),size(x,2));
           for i=1:size(z,2)
               if z(i)>-0.5 && z(i)<0.5
                   sw='k';
               else
                   sw='v';
               end
               for j=1:size(x,2)
                   if x(j)<-0.5
                       SW=[sw 'l'];
                   elseif x(j)>-0.5 && x(j)<0.5
                       SW=[sw 'k'];
                   elseif x(j)>0.5
                       SW=[sw 'f'];
                   else
                       SW=[sw 'v'];
                   end
                   xx=x(j);
                   yy=-1.5;
                   hh=z(i);
                   Sajat=[xx;yy;hh];
                   Labor=Nezet*Sajat;
                   X(i,j)=Labor(1);
                   Y(i,j)=Labor(2);
                   H(i,j)=Labor(3);
                   switch SW
                       case 'kl'
                           if obj.sarkak(1,1).definit
                               if obj.sarkak(1,1).forgatas
                                   if obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=N;
                                   elseif obj.sarkak(1,1).eltolas(1) && ~obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=P;
                                   elseif ~obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=K;
                                   else
                                       C(i,j)=Z;
                                   end
                               else
                                   if obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=P;
                                   elseif obj.sarkak(1,1).eltolas(1) && ~obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=Z;
                                   elseif ~obj.sarkak(1,1).eltolas(1) && obj.sarkak(1,1).eltolas(2)
                                       C(i,j)=N;
                                   else
                                       C(i,j)=K;
                                   end
                               end
                           end
                       case 'kk'
                           C(i,j)=K;
                       case 'kf'
                           if obj.sarkak(1,2).definit
                               if obj.sarkak(1,2).forgatas
                                   if obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=Z;
                                   elseif obj.sarkak(1,2).eltolas(1) && ~obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=P;
                                   elseif ~obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=K;
                                   else
                                       C(i,j)=N;
                                   end
                               else
                                   if obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=P;
                                   elseif obj.sarkak(1,2).eltolas(1) && ~obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=N;
                                   elseif ~obj.sarkak(1,2).eltolas(1) && obj.sarkak(1,2).eltolas(2)
                                       C(i,j)=Z;
                                   else
                                       C(i,j)=K;
                                   end
                               end
                           end
                   end
               end
           end
           surf(X,Y,H,C)
           % Tengelyek egys�ges sk�l�z�sa:
           axis([-1.5 1.5 -1.5 1.5 -1.5 1.5])
           hold off
        end
        %�sszehasonl�t� f�ggv�ny
        function out=CanbeEqual(A,B)
            out=false;
            for i=1:2
                for j=1:2
                    if A.sarkak(i,j).definit && B.sarkak(i,j).definit
                        if ~isequal(A.sarkak(i,j).eltolas,B.sarkak(i,j).eltolas)
                            return
                        end
                        if A.sarkak(i,j).forgatas~=B.sarkak(i,j).forgatas
                            return
                        end
                    end
                end
            end
            if A.oldalak.fenti.definit && B.oldalak.fenti.definit
                if A.oldalak.fenti.forgatas~=B.oldalak.fenti.forgatas
                    return
                end
            end
            if A.oldalak.lenti.definit && B.oldalak.lenti.definit
                if A.oldalak.lenti.forgatas~=B.oldalak.lenti.forgatas
                    return
                end
            end
            if A.oldalak.bal.definit && B.oldalak.bal.definit
                if A.oldalak.bal.forgatas~=B.oldalak.bal.forgatas
                    return
                end
            end
            if A.oldalak.jobb.definit && B.oldalak.jobb.definit
                if A.oldalak.jobb.forgatas~=B.oldalak.jobb.forgatas
                    return
                end
            end
            out=true;
        end
        %Csoportm�veletek (ezt m�r nem haszn�lja a szkript):
        %Az egys�gelem a kirakott kocka.
        %Figyelem: A csoport tulajdons�gok csak IsLapos()==1 esetben
        %garant�lhat�ak, s erre vonatkoz� ellen�rz�s az al�bbi f�ggv�nyekbe
        %nincs be�p�tve!
        function C=mtimes(A,B)
            %Csoportszorz�s.
            C=LAPOS();
            for i=1:2
                for j=1:2
                    %Megn�zz�k, honnan j�tt A (i,j) helyen l�v� sarka, s a
                    % helyet ind-nek nevezz�k:
                    ind=mod(A.sarkak(i,j).eltolas+[i j]+1,2)+1;
                    %az ind helyen �l� B-beli elemet tessz�k az (i,j)
                    %helyre C-ben:
                    delta=logical([i j]-ind);
                    C.sarkak(i,j)=B.sarkak(ind(1),ind(2)).eltol(delta);
                    %Ha az A(i,j) sarok forgatotts�ga abnorm�lis, az �j
                    %C(i,j) sarkat megford�tjuk:
                    if A.sarkak(i,j).forgatas~=...
                            (A.sarkak(i,j).eltolas(1)~=A.sarkak(i,j).eltolas(2))
                        C.sarkak(i,j).forgatas=~C.sarkak(i,j).forgatas;
                    end
                end
            end
            %A szorzat kocka oldalainak forgatotts�ga a k�t kocka
            %oldalforgatotts�g�nak "kiz�r� vagy" m�velete �ltal kaphat�
            %meg:
            C.oldalak.fenti.forgatas=xor(A.oldalak.fenti.forgatas,B.oldalak.fenti.forgatas);
            C.oldalak.lenti.forgatas=xor(A.oldalak.lenti.forgatas,B.oldalak.lenti.forgatas);
            C.oldalak.bal.forgatas=xor(A.oldalak.bal.forgatas,B.oldalak.bal.forgatas);
            C.oldalak.jobb.forgatas=xor(A.oldalak.jobb.forgatas,B.oldalak.jobb.forgatas);
        end
        function C=inv(A)
            %Invert�l�s:
            C=A;
            for i=1:2
                for j=1:2
                    %Megn�zz�k, honnan j�tt A (i,j) helyen l�v� sarka �s
                    %ezt a helyet ind-nek nevezz�k:
                    ind=mod(A.sarkak(i,j).eltolas+[i j]+1,2)+1;
                    %Megkeress�k az eredetileg (i,j) helyen l�v� sarkat:
                    b=false;
                    for k=1:2
                        for l=1:2
                            b=isequal([k l],mod(A.sarkak(k,l).eltolas+[i j]+1,2)+1);
                            if b
                                break
                            end
                        end
                        if b
                            break
                        end
                    end
                    %S a megtal�lt, (k,l) helyen l�v� elemet az ind helyre
                    %k�ldj�k:
                    deltakl=logical([i j]-[k l]);
                    deltaind=logical([i j]-ind);
                    C.sarkak(ind(1),ind(2))=...
                        A.sarkak(k,l).eltol(deltakl).eltol(deltaind);
                end
            end
            %Az inverz kocka az eredeti kocka oldalait �r�kli, amit az A=C
            %parancs m�r teljes�tett.
        end
        function C=mrdivide(A,B)
            %Oszt�s jobbr�l: A/B=C <=> A=C*B
            C=LAPOS();
            for i=1:2
                for j=1:2
                    %Megn�zz�k, hogy az A-ban az (i,j) helyen l�v� sarok
                    %merre van B-ben, s a helyet (k,l)-nek nevezz�k:
                    b=false;
                    for k=1:2
                        for l=1:2
                            b=isequal(mod(A.sarkak(i,j).eltolas+[i j]+1,2)+1,...
                                mod(B.sarkak(k,l).eltolas+[k l]+1,2)+1);
                            if b
                                break
                            end
                        end
                        if b
                            break
                        end
                    end
                    %A kirakott kocka (k,l) sark�t (i,j) helyre tessz�k
                    %C-ben:
                    delta=logical([i j]-[k l]);
                    C.sarkak(i,j)=SAROK().eltol(delta);
                    %Ha az A(i,j) �s a B(k,l) cs�csok egym�sba vitele a
                    %forgat�st nem vinn� egym�sba, akkor C(i,j)-t
                    %megford�tjuk:
                    if A.sarkak(i,j).forgatas~=...
                            B.sarkak(k,l).eltol(delta).forgatas
                        C.sarkak(i,j).forgatas=~C.sarkak(i,j).forgatas;
                    end
                end
            end
            %Az oldalak meghat�roz�s�hoz a szorz�skor haszn�lt "kiz�r�
            %vagy" m�velet inverze sz�ks�ges, ami szint�n "kiz�r� vagy":
            C.oldalak.fenti.forgatas=xor(A.oldalak.fenti.forgatas,B.oldalak.fenti.forgatas);
            C.oldalak.lenti.forgatas=xor(A.oldalak.lenti.forgatas,B.oldalak.lenti.forgatas);
            C.oldalak.bal.forgatas=xor(A.oldalak.bal.forgatas,B.oldalak.bal.forgatas);
            C.oldalak.jobb.forgatas=xor(A.oldalak.jobb.forgatas,B.oldalak.jobb.forgatas);
        end
        function C=mldivide(A,B)
            %Oszt�s balr�l: A\B=C <=> B=A*C
            C=LAPOS();
            for i=1:2
                for j=1:2
                    %Megn�zz�k, honnan j�tt A-ban az (i,j) helyen l�v�
                    %sarok, s a helyet elnevezz�k ind-nek:
                    ind=mod(A.sarkak(i,j).eltolas+[i j]+1,2)+1;
                    %A B-beli (i,j) helyen l�v� sarkat betessz�k C-be az
                    %ind helyre:
                    delta=logical([i j]-ind);
                    C.sarkak(ind(1),ind(2))=B.sarkak(i,j).eltol(delta);
                    %Ha az A(i,j) sarok forgatotts�ga abnorm�lis, akkor a
                    %C(ind) sarkat megford�tjuk:
                    if A.sarkak(i,j).forgatas~=...
                            (A.sarkak(i,j).eltolas(1)~=A.sarkak(i,j).eltolas(2))
                        C.sarkak(ind(1),ind(2)).forgatas=~C.sarkak(ind(1),ind(2)).forgatas;
                    end
                end
            end
            %Az oldalak meghat�roz�sa most is "kiz�r� vagy" �ltal t�rt�nik:
            C.oldalak.fenti.forgatas=xor(A.oldalak.fenti.forgatas,B.oldalak.fenti.forgatas);
            C.oldalak.lenti.forgatas=xor(A.oldalak.lenti.forgatas,B.oldalak.lenti.forgatas);
            C.oldalak.bal.forgatas=xor(A.oldalak.bal.forgatas,B.oldalak.bal.forgatas);
            C.oldalak.jobb.forgatas=xor(A.oldalak.jobb.forgatas,B.oldalak.jobb.forgatas);
        end
        function C=mpower(A,N)
            %Hatv�nyoz�s: Csak eg�sz kitev�re!
            C=LAPOS();
            if N>0
                for n=1:N
                    C=A*C;
                end
            elseif N<0
                for n=-1:-1:N
                    C=A\C;
                end
            end
        end
    end
end