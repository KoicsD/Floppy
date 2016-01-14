classdef SOL_LAP < SOLVER
    %A 3x3x1-es Rubik-kocka kirakására képes, próbálgatásokon alapuló
    %megoldóobjektum. Két kockaobjektumot és egy tájolás mátrixot foglal
    %magába. Az egyik kocka a kiindulási állapotot, a másik a célállapotot
    %tartalmazza.
    %A kiindulási kocka minden eleme határozott kell, hogy legyen, a
    %célkockában viszont megengedettek a definiálatlan elemek. Ilyen
    %esetben a megoldó csak a definiált elemeken vizsgálja az egyezést.
    %Rekurzív megoldófüggvény. A maximális lépésszám és az idõkorlát elõre
    %megadható, s az objektum a lépésszám alapján képes elõre futási idõt
    %becsülni.
    %A mezõk a SOLVER szülõosztályban vannak deklarálva/definiálva. A
    %SOLVER osztályon keresztül ez is alosztálya a handle osztálynak.
    methods
        function obj=SOL_LAP(Kocka,Nezet)
            obj.Alfa=Kocka;
            obj.Omega=LAPOS();
            if nargin==2
                obj.Nezet=Nezet;
            end
            obj.StepMax=5;
            obj.TimeMax=5;
            try
                load Timer.mat
                obj.TEstimateFcn=FO;
            catch ME
                
            end
        end
        %A nézetet forgató és ellenõrzõ függvények:
        function X(obj)
            %180°-os forgatás az X-tengely körül.
            obj.Nezet=[[1;0;0],[0;-1;0],[0;0;-1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function Y(obj)
            %180°-os forgatás az Y-tengely körül.
            obj.Nezet=[[-1;0;0],[0;1;0],[0;0;-1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function Zp(obj)
            %90°-os forgatás a Z tengely körül, a Z>0 irányból visszanézve
            %az óra járásával ellentétes irányba.
            obj.Nezet=[[0;1;0],[-1;0;0],[0;0;1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function Zm(obj)
            %90°-os forgatás a Z tengely körül, a Z>0 irányból visszanézve
            %az óra járásával egyezõ irányba.
            obj.Nezet=[[0;-1;0],[1;0;0],[0;0;1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function out=IsLapos(obj)
            %A tájolást kódoló mátrix validitásának ellenõrzése.
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
            end
        end
        %A kezdõ és a végkockát szabályosan manipuláló függvények:
        function AlfaElso(obj)
            obj.Alfa=obj.elso(obj.Alfa);
            obj.AlfaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function AlfaHatso(obj)
            obj.Alfa=obj.hatso(obj.Alfa);
            obj.AlfaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function AlfaBal(obj)
            obj.Alfa=obj.bal(obj.Alfa);
            obj.AlfaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function AlfaJobb(obj)
            obj.Alfa=obj.jobb(obj.Alfa);
            obj.AlfaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function OmegaElso(obj)
            obj.Omega=obj.elso(obj.Omega);
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function OmegaHatso(obj)
            obj.Omega=obj.hatso(obj.Omega);
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function OmegaBal(obj)
            obj.Omega=obj.bal(obj.Omega);
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function OmegaJobb(obj)
            obj.Omega=obj.jobb(obj.Omega);
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        %A kezdõ és a végkockát szabálytalanul manipuláló függvények:
        function AddtoAlfa(obj,where,what)
            if ~obj.ATmpTovalidate
                obj.AlfaTemp=obj.Alfa;
            end
            F=obj.Nezet'*where;
            if isequal(F,[1;0;0])%jobb
                switch what
                    case 'def'
                        obj.AlfaTemp.oldalak.jobb=OLDAL();
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.oldalak.jobb.forgatas=...
                            ~obj.AlfaTemp.oldalak.jobb.forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            elseif isequal(F,[0;1;0])%fenti
                switch what
                    case 'def'
                        obj.AlfaTemp.oldalak.fenti=OLDAL();
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.oldalak.fenti.forgatas=...
                            ~obj.AlfaTemp.oldalak.fenti.forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            elseif isequal(F,[-1;0;0])%bal
                switch what
                    case 'def'
                        obj.AlfaTemp.oldalak.bal=OLDAL();
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.oldalak.bal.forgatas=...
                            ~obj.AlfaTemp.oldalak.bal.forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            elseif isequal(F,[0;-1;0])%lenti
                switch what
                    case 'def'
                        obj.AlfaTemp.oldalak.lenti=OLDAL();
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.oldalak.lenti.forgatas=...
                            ~obj.AlfaTemp.oldalak.lenti.forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            elseif isequal(F,[-1;1;0])%balhátsó--sarok(2,1)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[2 1]);
                        obj.AlfaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[1 1]);
                        obj.AlfaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[1 2]);
                        obj.AlfaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[2 2]);
                        obj.AlfaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.sarkak(2,1).forgatas=...
                            ~obj.AlfaTemp.sarkak(2,1).forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            elseif isequal(F,[1;1;0])%jobbhátsó--sarok(2,2)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[2 1]);
                        obj.AlfaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[1 1]);
                        obj.AlfaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[1 2]);
                        obj.AlfaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[2 2]);
                        obj.AlfaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.sarkak(2,2).forgatas=...
                            ~obj.AlfaTemp.sarkak(2,2).forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            elseif isequal(F,[1;-1;0])%jobbelsõ--sarok(1,2)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[2 1]);
                        obj.AlfaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[1 1]);
                        obj.AlfaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[1 2]);
                        obj.AlfaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[2 2]);
                        obj.AlfaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.sarkak(1,2).forgatas=...
                            ~obj.AlfaTemp.sarkak(1,2).forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            elseif isequal(F,[-1;-1;0])%balelsõ--sarok(1,1)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[2 1]);
                        obj.AlfaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[1 1]);
                        obj.AlfaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[1 2]);
                        obj.AlfaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[2 2]);
                        obj.AlfaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                    case 'roll'
                        obj.AlfaTemp.sarkak(1,1).forgatas=...
                            ~obj.AlfaTemp.sarkak(1,1).forgatas;
                        obj.ATmpTovalidate=true;
                        obj.OTmpTovalidate=false;
                end
            end
        end
        function ValidateAlfa(obj,decision)
            if obj.ATmpTovalidate && decision
                obj.Alfa=obj.AlfaTemp;
                obj.Solved=false;
            end
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            figure(1)
            obj.Alfa.Visual3(obj.Nezet);
            title('A kezdeti állapot:')
        end
        function AddtoOmega(obj,where,what)
            if ~obj.OTmpTovalidate
                obj.OmegaTemp=obj.Omega;
            end
            F=obj.Nezet'*where;
            if isequal(F,[1;0;0])%jobb
                switch what
                    case 'def'
                        obj.OmegaTemp.oldalak.jobb=OLDAL();
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.oldalak.jobb.forgatas=...
                            ~obj.OmegaTemp.oldalak.jobb.forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.oldalak.jobb.definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            elseif isequal(F,[0;1;0])%fenti
                switch what
                    case 'def'
                        obj.OmegaTemp.oldalak.fenti=OLDAL();
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.oldalak.fenti.forgatas=...
                            ~obj.OmegaTemp.oldalak.fenti.forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.oldalak.fenti.definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            elseif isequal(F,[-1;0;0])%bal
                switch what
                    case 'def'
                        obj.OmegaTemp.oldalak.bal=OLDAL();
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.oldalak.bal.forgatas=...
                            ~obj.OmegaTemp.oldalak.bal.forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.oldalak.bal.definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            elseif isequal(F,[0;-1;0])%lenti
                switch what
                    case 'def'
                        obj.OmegaTemp.oldalak.lenti=OLDAL();
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.oldalak.lenti.forgatas=...
                            ~obj.OmegaTemp.oldalak.lenti.forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.oldalak.lenti.definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            elseif isequal(F,[-1;1;0])%balhátsó--sarok(2,1)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[2 1]);
                        obj.OmegaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[1 1]);
                        obj.OmegaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[1 2]);
                        obj.OmegaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([2 1]-[2 2]);
                        obj.OmegaTemp.sarkak(2,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.sarkak(2,1).forgatas=...
                            ~obj.OmegaTemp.sarkak(2,1).forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.sarkak(2,1).definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            elseif isequal(F,[1;1;0])%jobbhátsó--sarok(2,2)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[2 1]);
                        obj.OmegaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[1 1]);
                        obj.OmegaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[1 2]);
                        obj.OmegaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([2 2]-[2 2]);
                        obj.OmegaTemp.sarkak(2,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.sarkak(2,2).forgatas=...
                            ~obj.OmegaTemp.sarkak(2,2).forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.sarkak(2,2).definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            elseif isequal(F,[1;-1;0])%jobbelsõ--sarok(1,2)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[2 1]);
                        obj.OmegaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[1 1]);
                        obj.OmegaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[1 2]);
                        obj.OmegaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([1 2]-[2 2]);
                        obj.OmegaTemp.sarkak(1,2)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.sarkak(1,2).forgatas=...
                            ~obj.OmegaTemp.sarkak(1,2).forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.sarkak(1,2).definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            elseif isequal(F,[-1;-1;0])%balelsõ--sarok(1,1)
                switch what
                    case 'rg'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[2 1]);
                        obj.OmegaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'gb'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[1 1]);
                        obj.OmegaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'bo'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[1 2]);
                        obj.OmegaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'or'
                        s=SAROK();
                        s.eltolas=logical([1 1]-[2 2]);
                        obj.OmegaTemp.sarkak(1,1)=s;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'roll'
                        obj.OmegaTemp.sarkak(1,1).forgatas=...
                            ~obj.OmegaTemp.sarkak(1,1).forgatas;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                    case 'udef'
                        obj.OmegaTemp.sarkak(1,1).definit=false;
                        obj.ATmpTovalidate=false;
                        obj.OTmpTovalidate=true;
                end
            end
        end
        function ValidateOmega(obj,decision)
            if obj.OTmpTovalidate && decision
                obj.Omega=obj.OmegaTemp;
                obj.Solved=false;
            end
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            figure(2)
            obj.Omega.Visual3(obj.Nezet);
            title('A célállapot:')
        end
        function SolvedAlfa(obj)
            obj.Alfa=LAPOS();
            obj.AlfaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function SolvedOmega(obj)
            obj.Omega=LAPOS();
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function SetOmegaToAlfa(obj)
            obj.Omega=obj.Alfa;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function UdefOmega(obj)
            for i=1:2
                for j=1:2
                    obj.Omega.sarkak(i,j).definit=false;
                end
            end
            obj.Omega.oldalak.fenti.definit=false;
            obj.Omega.oldalak.lenti.definit=false;
            obj.Omega.oldalak.bal.definit=false;
            obj.Omega.oldalak.jobb.definit=false;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        %A megoldhatóságot tesztelõ függvény:
        function [result,message]=Solvability(obj)
            %A függvény igazzal tér vissza a result változban, ha
            %megoldható a probléma, hamissal, ha nem. Emellett a message
            %változóban egy üzenetet ad a hiba mivoltáról.
            result=false;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            if ~obj.Alfa.IsDefinit()
                message=...
                    'A kiindulási állapot nem határozott.\nA szolver csak határozott kezdõfeltétellel dolgozik.\n';
                return
            end
            if ~obj.Alfa.CanbeLapos() || ~obj.Omega.CanbeLapos()
                message='A szolver nem indítható, mert\n';
                message=[message 'a kezdeti és/vagy a célállapot\nismétlõdõ sarokelem(ek)et tartalmaz.\n'];
                return
            end
            CornerProblem=~TestCmp(CornerTest(obj.Alfa),UCornerTest(obj.Omega));
            ParityProblem=~TestCmp(ParityTest(obj.Alfa),UParityTest(obj.Omega));
            if CornerProblem && ~ParityProblem
                message='Bár mind a kiindulási, mind a célállapot\nkülönbözõ sarokelemeket tartalmaz,\n';
                message=[message 'a sarok-teszt szerint a probléma\nmégsem oldható meg.\n'];
            elseif ~CornerProblem && ParityProblem
                message='Bár mind a kiindulási, mind a célállapot\nkülönbözõ sarokelemeket tartalmaz,\n';
                message=[message 'a paritás-teszt szerint a probléma\nmégsem oldható meg.\n'];
            elseif CornerProblem && ParityProblem
                message='Bár mind a kiindulási, mind a célállapot\nkülönbözõ sarokelemeket tartalmaz,';
                message=[message 'a probléma\nsem a sarok-, sem a paritás-teszt szerint\nnem oldható meg.\n'];
            else
                message='A probléma átment\nmind a sarok-, mind a paritásteszten,\n';
                message=[message 'így megoldható.\n'];
                result=true;
            end
        end
        %A megoldás futási idejét becslõ függvény:
        function time=TEstimate(obj)
            try
                time=obj.TEstimateFcn(obj.StepMax);
            catch ME
                time=NaN;
            end
        end
        %A megoldó függvények:
        function out=Solve(obj,StepMax)
            %Közvetlenül ezt a függvényt hívjuk meg, ez írja felül az
            %objektum Solution változóját.
            if nargin==1
                StepMax=obj.StepMax;
            end
            out=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
            obj.Solution=cell(1,1);
            obj.Solution{1}='<Nincs találat.>';
            tic
            i=1;
            if CanbeEqual(obj.Alfa,obj.Omega)
                obj.Solution{1,1}='<A kezdeti állapotot már eleve tartalmazza a célállapot.>';
                i=2;
            end
            if StepMax>0
                Kocka=bal(obj,obj.Alfa);
                Subsol=Iterate(obj,Kocka,'a',StepMax-1);
                Subsize=size(Subsol,1);
                if Subsize>0
                    if strcmp(Subsol{1,1},'#runtime')
                        return
                    end
                    for j=1:Subsize
                        obj.Solution{i,1}=['a' Subsol{j,1}];
                        i=i+1;
                    end
                end
                Kocka=jobb(obj,obj.Alfa);
                Subsol=Iterate(obj,Kocka,'d',StepMax-1);
                Subsize=size(Subsol,1);
                if Subsize>0
                    if strcmp(Subsol{1,1},'#runtime')
                        return
                    end
                    for j=1:Subsize
                        obj.Solution{i,1}=['d' Subsol{j,1}];
                        i=i+1;
                    end
                end
                Kocka=elso(obj,obj.Alfa);
                Subsol=Iterate(obj,Kocka,'s',StepMax-1);
                Subsize=size(Subsol,1);
                if Subsize>0
                    if strcmp(Subsol{1,1},'#runtime')
                        return
                    end
                    for j=1:Subsize
                        obj.Solution{i,1}=['s' Subsol{j,1}];
                        i=i+1;
                    end
                end
                Kocka=hatso(obj,obj.Alfa);
                Subsol=Iterate(obj,Kocka,'w',StepMax-1);
                Subsize=size(Subsol,1);
                if Subsize>0
                    if strcmp(Subsol{1,1},'#runtime')
                        return
                    end
                    for j=1:Subsize
                        obj.Solution{i,1}=['w' Subsol{j,1}];
                        i=i+1;
                    end
                end
            end
            obj.Time=toc;
            obj.NSol=i-1;
            obj.Solved=true;
            out=false;
        end
        function out=Iterate(obj,Alfa,StepDisa,StepMax)
            %A munka nagy részét azonban ez a rekurzív függvény végzi el.
            out=cell(0,1);
            if toc>obj.TimeMax
                out{1,1}='#runtime';
                return
            end
            if CanbeEqual(Alfa,obj.Omega)
                out{1,1}='';
            elseif StepMax>0
                i=1;
                if ~strcmp(StepDisa,'a')
                    Kocka=bal(obj,Alfa);
                    Subsol=Iterate(obj,Kocka,'a',StepMax-1);
                    Subsize=size(Subsol,1);
                    if Subsize>0
                        if strcmp(Subsol{1,1},'#runtime')
                            out{1,1}='#runtime';
                            return
                        end
                        for j=1:Subsize
                            out{i,1}=['a' Subsol{j,1}];
                            i=i+1;
                        end
                    end
                end
                if ~strcmp(StepDisa,'d')
                    Kocka=jobb(obj,Alfa);
                    Subsol=Iterate(obj,Kocka,'d',StepMax-1);
                    Subsize=size(Subsol,1);
                    if Subsize>0
                        if strcmp(Subsol{1,1},'#runtime')
                            out{1,1}='#runtime';
                            return
                        end
                        for j=1:Subsize
                            out{i,1}=['d' Subsol{j,1}];
                            i=i+1;
                        end
                    end
                end
                if ~strcmp(StepDisa,'s')
                    Kocka=elso(obj,Alfa);
                    Subsol=Iterate(obj,Kocka,'s',StepMax-1);
                    Subsize=size(Subsol,1);
                    if Subsize>0
                        if strcmp(Subsol{1,1},'#runtime')
                            out{1,1}='#runtime';
                            return
                        end
                        for j=1:Subsize
                            out{i,1}=['s' Subsol{j,1}];
                            i=i+1;
                        end
                    end
                end
                if ~strcmp(StepDisa,'w')
                    Kocka=hatso(obj,Alfa);
                    Subsol=Iterate(obj,Kocka,'w',StepMax-1);
                    Subsize=size(Subsol,1);
                    if Subsize>0
                        if strcmp(Subsol{1,1},'#runtime')
                            out{1,1}='#runtime';
                            return
                        end
                        for j=1:Subsize
                            out{i,1}=['w' Subsol{j,1}];
                            i=i+1;
                        end
                    end
                end
            end
        end
        %A találatokat listázó függvény:
        function List(obj)
            if obj.Solved
                disp(['A találatok száma: ' num2str(obj.NSol)])
                disp(['Futási idõ: ' num2str(obj.Time) ' másodperc'])
                disp('A találati lista:')
                for i=1:size(obj.Solution,1)
                    fprintf(1,[obj.Solution{i,1} '\n'])
                end
                display(' ')
            end
        end
        %Ábrázolás:
        function Visual(obj)
            %Szóközökbõl álló 5x5-ös karaktermátrixok:
            AlfaM=char(double(' ')*ones(5));
            OmegaM=char(double(' ')*ones(5));
            %AlfaM elemeinek egyenként felülírása:
            if obj.Alfa.sarkak(1,1).definit
                AlfaM(4,2)=num2str(obj.Alfa.sarkak(1,1).forgatas);
                AlfaM(5,2)=num2str(obj.Alfa.sarkak(1,1).eltolas(1));
                AlfaM(4,1)=num2str(obj.Alfa.sarkak(1,1).eltolas(2));
            else
                AlfaM(4,2)='u';
            end
            if obj.Alfa.sarkak(1,2).definit
                AlfaM(4,4)=num2str(obj.Alfa.sarkak(1,2).forgatas);
                AlfaM(5,4)=num2str(obj.Alfa.sarkak(1,2).eltolas(1));
                AlfaM(4,5)=num2str(obj.Alfa.sarkak(1,2).eltolas(2));
            else
                AlfaM(4,4)='u';
            end
            if obj.Alfa.sarkak(2,1).definit
                AlfaM(2,2)=num2str(obj.Alfa.sarkak(2,1).forgatas);
                AlfaM(1,2)=num2str(obj.Alfa.sarkak(2,1).eltolas(1));
                AlfaM(2,1)=num2str(obj.Alfa.sarkak(2,1).eltolas(2));
            else
                AlfaM(2,2)='u';
            end
            if obj.Alfa.sarkak(2,2).definit
                AlfaM(2,4)=num2str(obj.Alfa.sarkak(2,2).forgatas);
                AlfaM(1,4)=num2str(obj.Alfa.sarkak(2,2).eltolas(1));
                AlfaM(2,5)=num2str(obj.Alfa.sarkak(2,2).eltolas(2));
            else
                AlfaM(2,4)='u';
            end
            if obj.Alfa.oldalak.lenti.definit
                AlfaM(4,3)=num2str(obj.Alfa.oldalak.lenti.forgatas);
            else
                AlfaM(4,3)='u';
            end
            if obj.Alfa.oldalak.fenti.definit
                AlfaM(2,3)=num2str(obj.Alfa.oldalak.fenti.forgatas);
            else
                AlfaM(2,3)='u';
            end
            if obj.Alfa.oldalak.bal.definit
                AlfaM(3,2)=num2str(obj.Alfa.oldalak.bal.forgatas);
            else
                AlfaM(3,2)='u';
            end
            if obj.Alfa.oldalak.jobb.definit
                AlfaM(3,4)=num2str(obj.Alfa.oldalak.jobb.forgatas);
            else
                AlfaM(3,4)='u';
            end
            
            %OmegaM elemeinek egyenként felülírása:
            if obj.Omega.sarkak(1,1).definit
                OmegaM(4,2)=num2str(obj.Omega.sarkak(1,1).forgatas);
                OmegaM(5,2)=num2str(obj.Omega.sarkak(1,1).eltolas(1));
                OmegaM(4,1)=num2str(obj.Omega.sarkak(1,1).eltolas(2));
            else
                OmegaM(4,2)='u';
            end
            if obj.Omega.sarkak(1,2).definit
                OmegaM(4,4)=num2str(obj.Omega.sarkak(1,2).forgatas);
                OmegaM(5,4)=num2str(obj.Omega.sarkak(1,2).eltolas(1));
                OmegaM(4,5)=num2str(obj.Omega.sarkak(1,2).eltolas(2));
            else
                OmegaM(4,4)='u';
            end
            if obj.Omega.sarkak(2,1).definit
                OmegaM(2,2)=num2str(obj.Omega.sarkak(2,1).forgatas);
                OmegaM(1,2)=num2str(obj.Omega.sarkak(2,1).eltolas(1));
                OmegaM(2,1)=num2str(obj.Omega.sarkak(2,1).eltolas(2));
            else
                OmegaM(2,2)='u';
            end
            if obj.Omega.sarkak(2,2).definit
                OmegaM(2,4)=num2str(obj.Omega.sarkak(2,2).forgatas);
                OmegaM(1,4)=num2str(obj.Omega.sarkak(2,2).eltolas(1));
                OmegaM(2,5)=num2str(obj.Omega.sarkak(2,2).eltolas(2));
            else
                OmegaM(2,4)='u';
            end
            if obj.Omega.oldalak.lenti.definit
                OmegaM(4,3)=num2str(obj.Omega.oldalak.lenti.forgatas);
            else
                OmegaM(4,3)='u';
            end
            if obj.Omega.oldalak.fenti.definit
                OmegaM(2,3)=num2str(obj.Omega.oldalak.fenti.forgatas);
            else
                OmegaM(2,3)='u';
            end
            if obj.Omega.oldalak.bal.definit
                OmegaM(3,2)=num2str(obj.Omega.oldalak.bal.forgatas);
            else
                OmegaM(3,2)='u';
            end
            if obj.Omega.oldalak.jobb.definit
                OmegaM(3,4)=num2str(obj.Omega.oldalak.jobb.forgatas);
            else
                OmegaM(3,4)='u';
            end
            %Mátixok kiírása:
            disp('A kockamátrixok:')
            disp('Alfa:  Omega:')
            for i=1:5
                disp([AlfaM(i,:) '  ' OmegaM(i,:)])
            end
            %Tájolás kiírása:
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
            display(['A tájolás: ' todisp])
            %Lépésszám kijelzés:
            display(['Beállított maximális lépésszám: ' num2str(obj.StepMax)])
            %Idõkorlát kijelzés:
            display(['Beállított maximális futási idõ: ' ...
                num2str(obj.TimeMax) ' másodperc'])
            %3D plot:
            if obj.ATmpTovalidate
                figure(1)
                obj.AlfaTemp.Visual3(obj.Nezet)
                title('Kezdõ állapot (ámeneti):')
            elseif obj.AlfaChanged
                figure(1)
                obj.Alfa.Visual3(obj.Nezet)
                obj.AlfaChanged=false;
                title('Kezdõ állapot:')
            end
            if obj.OTmpTovalidate
                figure(2)
                obj.OmegaTemp.Visual3(obj.Nezet)
                title('Célállapot (átmeneti):')
            elseif obj.OmegaChanged
                figure(2)
                obj.Omega.Visual3(obj.Nezet)
                obj.OmegaChanged=false;
                title('Célállapot:')
            end
        end
        %Mindehhez persze szükség van a négy, nézetmártixot is figyelembe
        %vevõ tekerõ függvényre:
        function out=elso(obj,in)
            F=obj.Nezet'*[0;-1;0];
            if isequal(F,[1;0;0])
                out=in.jobb();
            elseif isequal(F,[0;1;0])
                out=in.fenti();
            elseif isequal(F,[-1;0;0])
                out=in.bal();
            elseif isequal(F,[0;-1;0])
                out=in.lenti();
            end
        end
        function out=hatso(obj,in)
            F=obj.Nezet'*[0;1;0];
            if isequal(F,[1;0;0])
                out=in.jobb();
            elseif isequal(F,[0;1;0])
                out=in.fenti();
            elseif isequal(F,[-1;0;0])
                out=in.bal();
            elseif isequal(F,[0;-1;0])
                out=in.lenti();
            end
        end
        function out=bal(obj,in)
            F=obj.Nezet'*[-1;0;0];
            if isequal(F,[1;0;0])
                out=in.jobb();
            elseif isequal(F,[0;1;0])
                out=in.fenti();
            elseif isequal(F,[-1;0;0])
                out=in.bal();
            elseif isequal(F,[0;-1;0])
                out=in.lenti();
            end
        end
        function out=jobb(obj,in)
            F=obj.Nezet'*[1;0;0];
            if isequal(F,[1;0;0])
                out=in.jobb();
            elseif isequal(F,[0;1;0])
                out=in.fenti();
            elseif isequal(F,[-1;0;0])
                out=in.bal();
            elseif isequal(F,[0;-1;0])
                out=in.lenti();
            end
        end
        
    end
end