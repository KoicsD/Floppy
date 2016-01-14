classdef SOL_LAP < SOLVER
    %A 3x3x1-es Rubik-kocka kirak�s�ra k�pes, pr�b�lgat�sokon alapul�
    %megold�objektum. K�t kockaobjektumot �s egy t�jol�s m�trixot foglal
    %mag�ba. Az egyik kocka a kiindul�si �llapotot, a m�sik a c�l�llapotot
    %tartalmazza.
    %A kiindul�si kocka minden eleme hat�rozott kell, hogy legyen, a
    %c�lkock�ban viszont megengedettek a defini�latlan elemek. Ilyen
    %esetben a megold� csak a defini�lt elemeken vizsg�lja az egyez�st.
    %Rekurz�v megold�f�ggv�ny. A maxim�lis l�p�ssz�m �s az id�korl�t el�re
    %megadhat�, s az objektum a l�p�ssz�m alapj�n k�pes el�re fut�si id�t
    %becs�lni.
    %A mez�k a SOLVER sz�l�oszt�lyban vannak deklar�lva/defini�lva. A
    %SOLVER oszt�lyon kereszt�l ez is aloszt�lya a handle oszt�lynak.
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
        %A n�zetet forgat� �s ellen�rz� f�ggv�nyek:
        function X(obj)
            %180�-os forgat�s az X-tengely k�r�l.
            obj.Nezet=[[1;0;0],[0;-1;0],[0;0;-1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function Y(obj)
            %180�-os forgat�s az Y-tengely k�r�l.
            obj.Nezet=[[-1;0;0],[0;1;0],[0;0;-1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function Zp(obj)
            %90�-os forgat�s a Z tengely k�r�l, a Z>0 ir�nyb�l visszan�zve
            %az �ra j�r�s�val ellent�tes ir�nyba.
            obj.Nezet=[[0;1;0],[-1;0;0],[0;0;1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
        end
        function Zm(obj)
            %90�-os forgat�s a Z tengely k�r�l, a Z>0 ir�nyb�l visszan�zve
            %az �ra j�r�s�val egyez� ir�nyba.
            obj.Nezet=[[0;-1;0],[1;0;0],[0;0;1]]*obj.Nezet;
            obj.AlfaChanged=true;
            obj.OmegaChanged=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
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
            end
        end
        %A kezd� �s a v�gkock�t szab�lyosan manipul�l� f�ggv�nyek:
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
        %A kezd� �s a v�gkock�t szab�lytalanul manipul�l� f�ggv�nyek:
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
            elseif isequal(F,[-1;1;0])%balh�ts�--sarok(2,1)
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
            elseif isequal(F,[1;1;0])%jobbh�ts�--sarok(2,2)
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
            elseif isequal(F,[1;-1;0])%jobbels�--sarok(1,2)
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
            elseif isequal(F,[-1;-1;0])%balels�--sarok(1,1)
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
            title('A kezdeti �llapot:')
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
            elseif isequal(F,[-1;1;0])%balh�ts�--sarok(2,1)
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
            elseif isequal(F,[1;1;0])%jobbh�ts�--sarok(2,2)
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
            elseif isequal(F,[1;-1;0])%jobbels�--sarok(1,2)
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
            elseif isequal(F,[-1;-1;0])%balels�--sarok(1,1)
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
            title('A c�l�llapot:')
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
        %A megoldhat�s�got tesztel� f�ggv�ny:
        function [result,message]=Solvability(obj)
            %A f�ggv�ny igazzal t�r vissza a result v�ltozban, ha
            %megoldhat� a probl�ma, hamissal, ha nem. Emellett a message
            %v�ltoz�ban egy �zenetet ad a hiba mivolt�r�l.
            result=false;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            if ~obj.Alfa.IsDefinit()
                message=...
                    'A kiindul�si �llapot nem hat�rozott.\nA szolver csak hat�rozott kezd�felt�tellel dolgozik.\n';
                return
            end
            if ~obj.Alfa.CanbeLapos() || ~obj.Omega.CanbeLapos()
                message='A szolver nem ind�that�, mert\n';
                message=[message 'a kezdeti �s/vagy a c�l�llapot\nism�tl�d� sarokelem(ek)et tartalmaz.\n'];
                return
            end
            CornerProblem=~TestCmp(CornerTest(obj.Alfa),UCornerTest(obj.Omega));
            ParityProblem=~TestCmp(ParityTest(obj.Alfa),UParityTest(obj.Omega));
            if CornerProblem && ~ParityProblem
                message='B�r mind a kiindul�si, mind a c�l�llapot\nk�l�nb�z� sarokelemeket tartalmaz,\n';
                message=[message 'a sarok-teszt szerint a probl�ma\nm�gsem oldhat� meg.\n'];
            elseif ~CornerProblem && ParityProblem
                message='B�r mind a kiindul�si, mind a c�l�llapot\nk�l�nb�z� sarokelemeket tartalmaz,\n';
                message=[message 'a parit�s-teszt szerint a probl�ma\nm�gsem oldhat� meg.\n'];
            elseif CornerProblem && ParityProblem
                message='B�r mind a kiindul�si, mind a c�l�llapot\nk�l�nb�z� sarokelemeket tartalmaz,';
                message=[message 'a probl�ma\nsem a sarok-, sem a parit�s-teszt szerint\nnem oldhat� meg.\n'];
            else
                message='A probl�ma �tment\nmind a sarok-, mind a parit�steszten,\n';
                message=[message '�gy megoldhat�.\n'];
                result=true;
            end
        end
        %A megold�s fut�si idej�t becsl� f�ggv�ny:
        function time=TEstimate(obj)
            try
                time=obj.TEstimateFcn(obj.StepMax);
            catch ME
                time=NaN;
            end
        end
        %A megold� f�ggv�nyek:
        function out=Solve(obj,StepMax)
            %K�zvetlen�l ezt a f�ggv�nyt h�vjuk meg, ez �rja fel�l az
            %objektum Solution v�ltoz�j�t.
            if nargin==1
                StepMax=obj.StepMax;
            end
            out=true;
            obj.ATmpTovalidate=false;
            obj.OTmpTovalidate=false;
            obj.Solved=false;
            obj.Solution=cell(1,1);
            obj.Solution{1}='<Nincs tal�lat.>';
            tic
            i=1;
            if CanbeEqual(obj.Alfa,obj.Omega)
                obj.Solution{1,1}='<A kezdeti �llapotot m�r eleve tartalmazza a c�l�llapot.>';
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
            %A munka nagy r�sz�t azonban ez a rekurz�v f�ggv�ny v�gzi el.
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
        %A tal�latokat list�z� f�ggv�ny:
        function List(obj)
            if obj.Solved
                disp(['A tal�latok sz�ma: ' num2str(obj.NSol)])
                disp(['Fut�si id�: ' num2str(obj.Time) ' m�sodperc'])
                disp('A tal�lati lista:')
                for i=1:size(obj.Solution,1)
                    fprintf(1,[obj.Solution{i,1} '\n'])
                end
                display(' ')
            end
        end
        %�br�zol�s:
        function Visual(obj)
            %Sz�k�z�kb�l �ll� 5x5-�s karakterm�trixok:
            AlfaM=char(double(' ')*ones(5));
            OmegaM=char(double(' ')*ones(5));
            %AlfaM elemeinek egyenk�nt fel�l�r�sa:
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
            
            %OmegaM elemeinek egyenk�nt fel�l�r�sa:
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
            %M�tixok ki�r�sa:
            disp('A kockam�trixok:')
            disp('Alfa:  Omega:')
            for i=1:5
                disp([AlfaM(i,:) '  ' OmegaM(i,:)])
            end
            %T�jol�s ki�r�sa:
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
            %L�p�ssz�m kijelz�s:
            display(['Be�ll�tott maxim�lis l�p�ssz�m: ' num2str(obj.StepMax)])
            %Id�korl�t kijelz�s:
            display(['Be�ll�tott maxim�lis fut�si id�: ' ...
                num2str(obj.TimeMax) ' m�sodperc'])
            %3D plot:
            if obj.ATmpTovalidate
                figure(1)
                obj.AlfaTemp.Visual3(obj.Nezet)
                title('Kezd� �llapot (�meneti):')
            elseif obj.AlfaChanged
                figure(1)
                obj.Alfa.Visual3(obj.Nezet)
                obj.AlfaChanged=false;
                title('Kezd� �llapot:')
            end
            if obj.OTmpTovalidate
                figure(2)
                obj.OmegaTemp.Visual3(obj.Nezet)
                title('C�l�llapot (�tmeneti):')
            elseif obj.OmegaChanged
                figure(2)
                obj.Omega.Visual3(obj.Nezet)
                obj.OmegaChanged=false;
                title('C�l�llapot:')
            end
        end
        %Mindehhez persze sz�ks�g van a n�gy, n�zetm�rtixot is figyelembe
        %vev� teker� f�ggv�nyre:
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