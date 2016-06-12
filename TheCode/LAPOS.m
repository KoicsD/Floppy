classdef LAPOS
    %A 3x3x1-es kocka "mátrixát" tároló objektum.
    %"16 bites" ábrázolásmód
    %4 db tömbbe foglalt sarok, és 4 db -- szintén közös objektumba
    %foglalt -- oldal objektum.
    %Az oldalaknak egyik mezõjük a forgatottságot jelzõ bit, mely azt
    %mutatja meg, hogy az adott kockarész az alját mutatja-e fölfelé.
    %A sarokobjektumok a forgatottságon kívül egy eltolás mezõt is
    %tartalmaznak. Ez egy 2 elemû vektor, elemei azt adják meg, hogy az
    %adott sarok az átellenes oszlopból ill. sorból származik-e.
    %Mind az oldalaknak, mind a sarkaknak van még egy "definit" nevû
    %logikai változójuk. Ez azt mutatja meg, hogy az adott elem részt
    %vesz-e a szimulációban. Így nem kell a kocka minden elemét megadni, s
    %ezáltal modellezhetõ több kockaállapot uniója.
    properties
       sarkak=[[SAROK() SAROK()];[SAROK() SAROK()]]
       oldalak=OLDALAK()
    end
    methods
        %A 4 forgatófüggvény:
        % A megfelelõ oldalt forgatják, a mellette levõ két sarkat pedig
        % egymás forgatva eltoltjára cserélik.
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
            %Összekeverõ függvény.
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
        %    %Helyreállító függvény.
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
        %Tesztfüggvények a kocka kirakhatóságára:
        function out=IsDefinit(obj)
            %Annak ellenõrzése, hogy a kocka minden eleme definiálva van-e.
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
            %Annak ellenõrzése, hogy egy (nem feltétlenül határozott) kocka
            %sarokelemei különböznek-e, vagyis lehet-e benne 4 különbözõ
            %sarokelem.
            %(Ha hamissal tér vissza, bármik is legyenek a
            %határozatlan elemek, a kockát összekeverés közben biztos,
            %hogy szétcsavarozták, s elemeit egy másik szétcsavaroztott
            %kocka elemeivel összekeverték.)
            out=false;
            %ELõször veszünk egy 2x2-es hamis mátrixot:
            M=false(2);
            %Majd végighaladunk a 4 sarkon,
            for i=1:2
                for j=1:2
                    if obj.sarkak(i,j).definit
                        %megnézzük, hogy a határozott sarkak honnan jöttek,
                        ind=mod(obj.sarkak(i,j).eltolas+[i j]+1,2)+1;
                        %s a mátrix megfelelõ elemeit igazzá tesszük, feltéve,
                        %hogy még nem azok:
                        if ~M(ind(1),ind(2))
                            M(ind(1),ind(2))=true;
                        else
                            %Ha az adott elem már igaz volt, akkor már
                            %nincs értelme tovább vizsgálógni, hisz
                            %találtunk 2 egyforma sarkat:
                            return
                        end
                    end
                end
            end
            %Ha nem volt két egyforma sarok, a kocka átment a teszten:
            out=true;
        end
        function out=IsLapos(obj)
            %Annyival bõvebb az elõzõ függvénynél, hogy elõször az
            %IsDefinit() függvény segítségével ellenõrzi, hogy minden elem
            %határozott-e. (Viszont maga a teszt egy másik, csak határozott
            %kockákon alkalmazható módszert használ).
            out=true;
            if ~IsDefinit(obj)
                out=false;
                return
            end
            % A teszt alapja a tömegközéppont megmaradásának törvénye:
            % a sarkak eltolásvektorainak összege invariáns a sarkak
            % permutálására (mindig nullvektor):
            sum=[0 0];
            for i=1:2
                for j=1:2
                    %Persze az eltolásvektorok összege az eltolásbitek
                    %elõjeles összegét jelenti:
                    sum=sum+[(-1)^i (-1)^j].*double(obj.sarkak(i,j).eltolas);
                end
            end
            if sum(1) || sum(2)
                out=false;
                return
            end
            % A tömegközépponti módszer azonban csak azt garantálja, hogy
            % pontosan 2 lenti, 2 fenti, 2 bal és 2 jobb sarok van.
            % Azt már nem garantálja, hogy a 2 fenti/lenti sarok közül 1 jobb
            % és 1 bal. Ezt külön meg kell vizsgálni:
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
            %Egy kirakható kocka egyes sarkainak forgatottsági állapotát
            %egyértelmûen meghatározza azok elhelyezkedése. Ez a függvény
            %azt ellenõrzi, mely sarokelemek nem engedelmeskednek ennek a
            %törvénynek.
            %A visszatérési érték egy 2x2-es logikai mátrix. Ha mátrixnak
            %van igaz eleme, a kocka nem rakható ki.
            %Figyelem: A függvényt csak akkor használjuk, ha meggyõzõdtünk
            %róla, hogy a kocka teljesen határozott, és 4 különbözõ
            %sarokeleme van (IsLapos()==true)! (A függvény nem tartalmaz
            %vonatkozó ellenõrzést.)
            out= false(2);
            %Végigmegyünk a sarkakon:
            for i=1:2
                for j=1:2
                    %Ha az adott saroknál eltolás és forgatás
                    %közt nincs összhang,
                    if (obj.sarkak(i,j).forgatas)~=...
                            (obj.sarkak(i,j).eltolas(1)~=obj.sarkak(i,j).eltolas(2))
                        %megnézzük, honnan jött a sarok,
                        ind=mod([i j]+obj.sarkak(i,j).eltolas+1,2)+1;
                        %s a kimenet megfelelõ elemét igazzá tesszük:
                        out(ind(1),ind(2))=true;
                    end
                end
            end
        end
        function out=UCornerTest(obj)
            %Sarokteszt nem feltétlenül határozott kockára.
            %Most azonban logikai változók helyett 8 bites integerekbõl áll
            %a visszatérõ mátrix, mely (a double típusnál jóval kisebb
            %memóriaterület használatával) lehetõvé teszi, a
            %határozatlan sarkak -1 értékkel történõ megjelölését.
            %Figyelem: A teszt eredménye csak akkor használható, ha a
            %határozott sarokelemek különböznek (CanbeLapos()==1)!
            out= int8(-ones(2));
            %Végigmegyünk a sarkakon:
            for i=1:2
                for j=1:2
                    if obj.sarkak(i,j).definit
                        %Megnézzük, honnan jött a sarok:
                        ind=mod([i j]+obj.sarkak(i,j).eltolas+1,2)+1;
                        if (obj.sarkak(i,j).forgatas)~=...
                                (obj.sarkak(i,j).eltolas(1)~=obj.sarkak(i,j).eltolas(2))
                            %Ha az aktív sarkaknál eltolás és forgatás
                            %közt nincs összhang,
                            %a kimenet megfelelõ elemét 1-gyé
                            %tesszük:
                            out(ind(1),ind(2))=1;
                        else
                            %Ha van összhang, akkor 0-vá:
                            out(ind(1),ind(2))=0;
                        end
                    end
                end
            end
        end
        function out=ParityTest(obj)
            %Paritás-teszt.
            %Annak ellenõrzése, hogy a sarkak permutációjának
            %és a felfordított oldalelemek számának paritása eltérõ-e.
            %Ha a két paritás eltér (a függvény igazzal tér vissza),
            %a kocka nem rakható ki (összekeverés közben szétcsavarozták).
            %Figyelem: A függvényt csak akkor használjuk, ha meggyõzõdtünk
            %róla, hogy a kocka teljesen határozott, és 4 különbözõ
            %sarokeleme van (IsLapos()==true)! (A függvény nem tartalmaz
            %vonatkozó ellenõrzést.)
            out=false;
            eredet=zeros(2);
            k=1;
            %Egy perm nevû 4-es vektorba kifejtjük a sarkok permutációját:
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
            %Megvizsgáljuk az inverziói szám paritását:
            tolpar=1;
            for i=1:3
                for j=i:4
                    if perm(i)>perm(j)
                        tolpar=tolpar*(-1);
                    end
                end
            end
            %Majd a felforditott oldalak számának paritását:
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
            %Végül a két paritás összehasonlítása:
            if forgpar~=tolpar
                out=true;
            end
        end
        function out=UParityTest(obj)
            %Paritásteszt nem feltétlenül határozott kockára.
            %Ez a függvény is 1-el jelzi a kiszûrt, és 0-val az átment
            %kockát. Ha azonban a kockának van határozatlan eleme, -1-gyel
            %tér vissza (olyankor a paritás-teszt nem végezhetõ el).
            %A visszatérési érték típusa 8 bites integer.
            %Figyelem: A teszt eredménye csak akkor használható, ha a
            %határozott sarokelemek különböznek (CanbeLapos()==1)!
            out=int8(-1);
            eredet=zeros(2);
            k=1;
            %Egy perm nevû 4-es vektorba kifejtjük a sarkok permutációját:
            for i=1:2
                for j=1:2
                    %Ha az (i,j) sarok határozatlan, vége a vizsgálatnak:
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
            %Megvizsgáljuk az inverziói szám paritását:
            tolpar=1;
            for i=1:3
                for j=i:4
                    if perm(i)>perm(j)
                        tolpar=tolpar*(-1);
                    end
                end
            end
            %Majd a felforditott oldalak számának paritását:
            forgpar=1;
            if ~obj.oldalak.jobb.definit
                %Persze ha az adott oldal határozatlan, akkor vége:
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
            %Végül a két paritás összehasonlítása:
            if forgpar~=tolpar
                out=int8(1);
            else
                out=int8(0);
            end
        end
        function out=CanbeSolvable(obj)
            %Annak vizsgálata, hogy a kockát kiegészítve a határozatlan
            %elemekkel kaphatunk-e kirakható kockát.
            %Amennyiben kaphatunk kirakható kockát, úgy a függvény logikai
            %igazzal, ellenkezõ esetben hamissal tér vissza.
            %A függvény meghívja a CanbeLapos(), s annak igazzal történõ
            %visszatérése esetén az UParityTest() és az UCornerTest()
            %függvényeket is.
            out=false;
            if obj.CanbeLapos()
                if TestCmp(obj.UCornerTest(),false(2)) &&...
                        obj.UParityTest()==0
                    out=true;
                end
            end
            %Másik út:
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
            %Annak ellenõrzése, hogy a kocka határozott és kirakható-e.
            %Kirakható kocka esetén igazzal, nem kirakható kocka esetén
            %hamissal tér vissza a függvény.
            %A függvény meghívja az IsLapos(), s annak igazzal történõ
            %visszatérése esetén a ParityTest() és a CornerTest()
            %függvényeket is.
            out=false;
            if obj.IsLapos()
                if isequal(obj.CornerTest(),false(2)) &&...
                        ~obj.ParityTest()
                    out=true;
                end
            end
        end
        function out=CanbeSolved(obj)
            %Annak vizsgálata, hogy a kockát kiegészítve a határozatlan
            %elemekkel kaphatunk-e kirakott kockát. (A határozott elemek
            %forgatás és eltolás bitjei hamisak-e.)
            %Amennyiben kaphatunk kirakott kockát, úgy a függvény logikai
            %igazzal, ellenkezõ esetben hamissal tér vissza.
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
            %Annak ellenõrzése, hogy a kocka határozott-e és ki van-e rakva
            %(minden elem definit bitje igaz-e, eltolás és forgatás bitje
            %pedig hamis-e). Kirakott kocka esetén logikai igazzal,
            %ellenkezõ esetben hamissal tér vissza.
            %A függvény meghívja az IsDefinit() függvényt is!
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
        %Megjelenítõ függvények:
        function writeM(obj,FID)
            %A kockamátrix parancssorba vagy fájlba írása.
            if nargin==1
                FID=1;
            end
            %Szóközökbõl álló 5x5-ös karaktermátrix:
            M=char(double(' ')*ones(5));
            %Majd az elemek egyenként felülírása:
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
            %Végül fájlba/parancssorra küldés:
            fprintf(FID,[M(1,1:4) '\n'])
            fprintf(FID,[M(2,1:5) '\n'])
            fprintf(FID,[M(3,1:4) '\n'])
            fprintf(FID,[M(4,1:5) '\n'])
            fprintf(FID,[M(5,1:4) '\n'])
        end
        function Visual3(obj,Nezet)
           %A kocka perspektivikus megjelenítése.
           %A függvény vár egy (ortogonális) mátrixot is, mely a kocka
           %térbeli tájolásáról ad információt.
           %Ha nem kap mátrixot, 3x3-as egységmátrix az alapértelmezett:
           if nargin==1
               Nezet=eye(3);
           end
           % Színkódok:
           P=56;
           N=48;
           S=40;
           Z=32;
           K=8;
           F=64;
           % A középpontja az origo, mérete 3x3x1, a lépésköz 0.1:
           x=-1.5:0.1:1.5;
           y=x;
           z=-0.5:0.1:0.5;
           % Felsõ lap (Z=1.5):
           X=zeros(size(y,2),size(x,2));%X koordináták a 3D felületplothoz
           Y=zeros(size(y,2),size(x,2));%Y koordináták a 3D felületplothoz
           H=zeros(size(y,2),size(x,2));%Z koordináták a 3D felületplothoz
           C=ones(size(y,2),size(x,2));%Színek a 3D felületplothoz
           for i=1:size(y,2)
               %A 3x3 négyzet indexelése a SW változó és a switch parancs
               %segítségével a színek meghatározásához:
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
                   %Közben a koordináták meghatározása
                   %Saját rendszer -- Z=0.5 sík:
                   xx=x(j);
                   yy=y(i);
                   hh=0.5;
                   Sajat=[xx;yy;hh];
                   %Labor rendszer -- Transzformáció a kapott mátrixszal:
                   Labor=Nezet*Sajat;
                   X(i,j)=Labor(1);
                   Y(i,j)=Labor(2);
                   H(i,j)=Labor(3);
                   switch SW
                       %A színek meghatározása:
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
           % Az ábrázolás:
           surf(X,Y,H,C)
           hold on
           % Alsó lap (Z=-1.5):
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
           % Hátsó (fenti) lap (Y=1.5):
           X=zeros(size(z,2),size(x,2));
           Y=zeros(size(z,2),size(x,2));
           H=zeros(size(z,2),size(x,2));
           C=ones(size(z,2),size(x,2));
           for i=1:size(z,2)
               %Itt (és a továbbiakban) már csak 1x3 négyzet van:
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
                   %Saját rendszerben az Y=1.5 síkról van szó:
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
           % Elsõ (lenti) lap (Y=-1.5):
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
           % Tengelyek egységes skálázása:
           axis([-1.5 1.5 -1.5 1.5 -1.5 1.5])
           hold off
        end
        %Összehasonlító függvény
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
        %Csoportmûveletek (ezt már nem használja a szkript):
        %Az egységelem a kirakott kocka.
        %Figyelem: A csoport tulajdonságok csak IsLapos()==1 esetben
        %garantálhatóak, s erre vonatkozó ellenõrzés az alábbi függvényekbe
        %nincs beépítve!
        function C=mtimes(A,B)
            %Csoportszorzás.
            C=LAPOS();
            for i=1:2
                for j=1:2
                    %Megnézzük, honnan jött A (i,j) helyen lévõ sarka, s a
                    % helyet ind-nek nevezzük:
                    ind=mod(A.sarkak(i,j).eltolas+[i j]+1,2)+1;
                    %az ind helyen ülõ B-beli elemet tesszük az (i,j)
                    %helyre C-ben:
                    delta=logical([i j]-ind);
                    C.sarkak(i,j)=B.sarkak(ind(1),ind(2)).eltol(delta);
                    %Ha az A(i,j) sarok forgatottsága abnormális, az új
                    %C(i,j) sarkat megfordítjuk:
                    if A.sarkak(i,j).forgatas~=...
                            (A.sarkak(i,j).eltolas(1)~=A.sarkak(i,j).eltolas(2))
                        C.sarkak(i,j).forgatas=~C.sarkak(i,j).forgatas;
                    end
                end
            end
            %A szorzat kocka oldalainak forgatottsága a két kocka
            %oldalforgatottságának "kizáró vagy" mûvelete által kapható
            %meg:
            C.oldalak.fenti.forgatas=xor(A.oldalak.fenti.forgatas,B.oldalak.fenti.forgatas);
            C.oldalak.lenti.forgatas=xor(A.oldalak.lenti.forgatas,B.oldalak.lenti.forgatas);
            C.oldalak.bal.forgatas=xor(A.oldalak.bal.forgatas,B.oldalak.bal.forgatas);
            C.oldalak.jobb.forgatas=xor(A.oldalak.jobb.forgatas,B.oldalak.jobb.forgatas);
        end
        function C=inv(A)
            %Invertálás:
            C=A;
            for i=1:2
                for j=1:2
                    %Megnézzük, honnan jött A (i,j) helyen lévõ sarka és
                    %ezt a helyet ind-nek nevezzük:
                    ind=mod(A.sarkak(i,j).eltolas+[i j]+1,2)+1;
                    %Megkeressük az eredetileg (i,j) helyen lévõ sarkat:
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
                    %S a megtalált, (k,l) helyen lévõ elemet az ind helyre
                    %küldjük:
                    deltakl=logical([i j]-[k l]);
                    deltaind=logical([i j]-ind);
                    C.sarkak(ind(1),ind(2))=...
                        A.sarkak(k,l).eltol(deltakl).eltol(deltaind);
                end
            end
            %Az inverz kocka az eredeti kocka oldalait örökli, amit az A=C
            %parancs már teljesített.
        end
        function C=mrdivide(A,B)
            %Osztás jobbról: A/B=C <=> A=C*B
            C=LAPOS();
            for i=1:2
                for j=1:2
                    %Megnézzük, hogy az A-ban az (i,j) helyen lévõ sarok
                    %merre van B-ben, s a helyet (k,l)-nek nevezzük:
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
                    %A kirakott kocka (k,l) sarkát (i,j) helyre tesszük
                    %C-ben:
                    delta=logical([i j]-[k l]);
                    C.sarkak(i,j)=SAROK().eltol(delta);
                    %Ha az A(i,j) és a B(k,l) csúcsok egymásba vitele a
                    %forgatást nem vinné egymásba, akkor C(i,j)-t
                    %megfordítjuk:
                    if A.sarkak(i,j).forgatas~=...
                            B.sarkak(k,l).eltol(delta).forgatas
                        C.sarkak(i,j).forgatas=~C.sarkak(i,j).forgatas;
                    end
                end
            end
            %Az oldalak meghatározásához a szorzáskor használt "kizáró
            %vagy" mûvelet inverze szükséges, ami szintén "kizáró vagy":
            C.oldalak.fenti.forgatas=xor(A.oldalak.fenti.forgatas,B.oldalak.fenti.forgatas);
            C.oldalak.lenti.forgatas=xor(A.oldalak.lenti.forgatas,B.oldalak.lenti.forgatas);
            C.oldalak.bal.forgatas=xor(A.oldalak.bal.forgatas,B.oldalak.bal.forgatas);
            C.oldalak.jobb.forgatas=xor(A.oldalak.jobb.forgatas,B.oldalak.jobb.forgatas);
        end
        function C=mldivide(A,B)
            %Osztás balról: A\B=C <=> B=A*C
            C=LAPOS();
            for i=1:2
                for j=1:2
                    %Megnézzük, honnan jött A-ban az (i,j) helyen lévõ
                    %sarok, s a helyet elnevezzük ind-nek:
                    ind=mod(A.sarkak(i,j).eltolas+[i j]+1,2)+1;
                    %A B-beli (i,j) helyen lévõ sarkat betesszük C-be az
                    %ind helyre:
                    delta=logical([i j]-ind);
                    C.sarkak(ind(1),ind(2))=B.sarkak(i,j).eltol(delta);
                    %Ha az A(i,j) sarok forgatottsága abnormális, akkor a
                    %C(ind) sarkat megfordítjuk:
                    if A.sarkak(i,j).forgatas~=...
                            (A.sarkak(i,j).eltolas(1)~=A.sarkak(i,j).eltolas(2))
                        C.sarkak(ind(1),ind(2)).forgatas=~C.sarkak(ind(1),ind(2)).forgatas;
                    end
                end
            end
            %Az oldalak meghatározása most is "kizáró vagy" által történik:
            C.oldalak.fenti.forgatas=xor(A.oldalak.fenti.forgatas,B.oldalak.fenti.forgatas);
            C.oldalak.lenti.forgatas=xor(A.oldalak.lenti.forgatas,B.oldalak.lenti.forgatas);
            C.oldalak.bal.forgatas=xor(A.oldalak.bal.forgatas,B.oldalak.bal.forgatas);
            C.oldalak.jobb.forgatas=xor(A.oldalak.jobb.forgatas,B.oldalak.jobb.forgatas);
        end
        function C=mpower(A,N)
            %Hatványozás: Csak egész kitevõre!
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