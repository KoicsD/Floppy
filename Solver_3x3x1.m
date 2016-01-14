%Ez a szkript a megold� motorja.
%Ez automatikusan elindul, amikor bel�p�nk a megold�ba.
%Fejleszt�si lehet�s�gek:
%Az UParityTest() f�ggv�nynek van egy hib�ja, ami miatt a program
%bizonyos megoldhatatlan probl�m�kat megoldhat�nak hisz!
%Sz�r�k bevezet�se a megold�si list�ra?
%Ment�s �s bet�lt�s.
Solver=SOL_LAP(Kezelo.Kocka,Kezelo.Nezet);
[Solvable,Message]=Solver.Solvability();
if Solver.TEstimate()>Solver.TimeMax
    TimeProblem=true;
else
    TimeProblem=false;
end
ViewProblem=NezetHiba;
Smenu=1;
while (Smenu)
    clc
    if FID~=-1
        for j=1:i-1
            display(H{j})
        end
    end
    display('Megold� programr�sz.')
    display(' ')
    Solver.Visual()
    display(' ')
    switch Smenu
        case 1
            if ~Solvable || ViewProblem
                disp('! Hiba:')
                if ~Solvable
                    fprintf(1,Message)
                    display(' ')
                end
                if ViewProblem
                    disp('A jelenlegi n�zetet nem t�mogatja a megold�.')
                    disp('Tess�k m�sik probl�m�t bet�lteni!')
                end
            elseif TimeProblem
                disp('! Figyelem:')
                disp('A becs�lt fut�si id� meghaladja')
                disp('a be�ll�tott id�korl�tot!')
                disp(' ')
            end
            Solver.List()
            display('Kezdeti �llapot m�dos�t�sa:')
            display('   H�ts�: w')
            display('   Els�: s')
            display('   Bal: a')
            display('   Jobb: d')
            display('   Elem szab�lytalan hozz�ad�sa: r')
            display('C�l�llapot m�dos�t�sa:')
            display('   H�ts�: i')
            display('   Els�: k')
            display('   Bal: j')
            display('   Jobb: l')
            display('   Elem szab�lytalan hozz�ad�sa/elt�vol�t�sa: u')
            display('N�zetv�lt�sok (2-es�vel is):')
            display('   Megford�t�s X k�r�l: x')
            display('   Megford�t�s Y k�r�l: y')
            display('   Forgat�s a s�kban jobbra: c')
            display('   Forgat�s a s�kban balra: �')
            display('Men�: q')
            if Solvable
                display('Megold� ind�t�sa: start')
            end
            %display('Visszat�r�s a szimul�torhoz: return')
            %display('Visszat�r�s a MATLAB-hoz: exit')
            display(' ')
            entry=input('MK/S>>','s');
            if size(entry,2)==2
                folyt=true;
                for j=1:2
                    switch entry(j)
                        case 'x'
                        case 'y'
                        case 'c'
                        case '�'
                        otherwise
                            folyt=false;
                    end
                end
                if folyt
                    for j=1:2
                        switch entry(j)
                            case 'x'
                                Solver.X()
                            case 'y'
                                Solver.Y()
                            case 'c'
                                Solver.Zm()
                            case '�'
                                Solver.Zp()
                        end
                    end
                end
            else
                switch entry
                    case 'q'
                        Smenu=11;
                    case 'a'
                        Solver.AlfaBal()
                    case 's'
                        Solver.AlfaElso()
                    case 'd'
                        Solver.AlfaJobb()
                    case 'w'
                        Solver.AlfaHatso()
                    case 'r'
                        Smenu=12;
                    case 'j'
                        Solver.OmegaBal()
                    case 'k'
                        Solver.OmegaElso()
                    case 'l'
                        Solver.OmegaJobb()
                    case 'i'
                        Solver.OmegaHatso()
                    case 'u'
                        Smenu=13;
                    case 'x'
                        Solver.X()
                    case 'y'
                        Solver.Y()
                    case 'c'
                        Solver.Zm()
                    case '�'
                        Solver.Zp()
                    case 'start'
                        if Solvable
                            disp('A szolver futtat�sa...')
                            if Solver.Solve()
                                disp('Id�t�ll�p�si hiba.')
                                pause(1)
                            else
                                disp('K�sz.')
                            end
                        end
                    case 'return'
                        Smenu=0;
                    case 'exit'
                        Smenu=0;
                        menu=0;
                end
            end
        case 11
            display('Men�:')
            display('   Folytat�s: c')
            display('   Kirakott kezdeti �llapot: as')
            display('   Kirakott c�l�llapot: os')
            display('   Hat�rozatlan c�l�llapot: ou')
            display('   A kezdetivel megegyez� c�l�llapot: oa')
            display('   Max. l�p�ssz�m �ll�t�sa: sm')
            display('   Max. fut�si id� �ll�t�sa: tm')
            %display('   Ment�s: s')
            %display('   Bet�lt�s: l')
            display('   Vissza a szimul�torhoz: q')
            display('   Vissza a MATLAB-hoz: M')
            entry=input('MK/S>>','s');
            switch entry
                case 'c'
                    Smenu=1;
                case 'as'
                    Solver.SolvedAlfa()
                    Smenu=1;
                case 'os'
                    Solver.SolvedOmega()
                    Smenu=1;
                case 'ou'
                    Solver.UdefOmega()
                    Smenu=1;
                case 'oa'
                    Solver.SetOmegaToAlfa()
                    Smenu=1;
                case 's'
                    
                case 'l'
                    
                case 'sm'
                    entry=input('A l�p�sek sz�ma:','s');
                    try
                        num=str2double(entry);
                        if num>=0 && mod(num,1)==0
                            Solver.StepMax=num;
                            display(['Be�ll�tott maxim�lis l�p�ssz�m: ' ...
                                num2str(Solver.StepMax)])
                            num=Solver.TEstimate();
                            if ~isnan(num)
                                display(['Becs�lt fut�si id�: ' ...
                                    num2str(num) ' m�sodperc'])
                            end
                            if num>Solver.TimeMax
                                TimeProblem=true;
                                disp('! Figyelem:')
                                disp('Ez az �rt�k meghaladja a be�ll�tott')
                                disp('id�korl�tot!')
                            else
                                TimeProblem=false;
                            end
                            pause
                        else
                            display('Hib�s sz�mform�tum!')
                            pause(0.75)
                        end
                    catch ME
                        display('Hib�s sz�mform�tum!')
                        pause(0.75)
                    end
                    Smenu=1;
                case 'tm'
                    entry=input('Az id�korl�t [m�sodperc]:','s');
                    try
                        num=str2double(entry);
                        if num>=0
                            Solver.TimeMax=num;
                            display(['Be�ll�tott max. fut�si id�: ' ...
                                num2str(Solver.TimeMax) ' m�sodperc'])
                            num=Solver.TEstimate();
                            if num>Solver.TimeMax
                                TimeProblem=true;
                                disp('! Figyelem:')
                                disp('Ez az �rt�k kisebb, mint a')
                                disp(['becs�lt fut�si id� (' num2str(num) ' m�sodperc)!'])
                            else
                                TimeProblem=false;
                            end
                            pause
                        else
                            display('Hib�s sz�mform�tum!')
                            pause(0.75)
                        end
                    catch ME
                        display('Hib�s sz�mform�tum!')
                        pause(0.75)
                    end
                    Smenu=1;
                case 'q'
                    Smenu=0;
                case 'M'
                    Smenu=0;
                    menu=0;
            end
        case 12
            display('Elem hozz�ad�sa a kezdeti �llapothoz:')
            display('   Oldalak:')
            display('       Els�: e')
            display('       H�ts�: h')
            display('       Bal: b')
            display('       Jobb: j')
            display('   Cs�csok:')
            display('       Bal els�: be')
            display('       Jobb els�: je')
            display('       Bal h�ts�: bh')
            display('       Jobb h�ts�: jh')
            display('   M�gse: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'e'
                    Where=[0;-1;0];
                    Solver.AddtoAlfa(Where,'def')
                    Smenu=1201;
                case 'h'
                    Where=[0;1;0];
                    Solver.AddtoAlfa(Where,'def')
                    Smenu=1201;
                case 'b'
                    Where=[-1;0;0];
                    Solver.AddtoAlfa(Where,'def')
                    Smenu=1201;
                case 'j'
                    Where=[1;0;0];
                    Solver.AddtoAlfa(Where,'def')
                    Smenu=1201;
                case 'be'
                    Where=[-1;-1;0];
                    Smenu=122;
                case 'je'
                    Where=[1;-1;0];
                    Smenu=122;
                case 'bh'
                    Where=[-1;1;0];
                    Smenu=122;
                case 'jh'
                    Where=[1;1;0];
                    Smenu=122;
                case 'c'
                    Smenu=1;
            end
        case 122
            disp('Sarokelem hozz�ad�sa:')
            disp('  Piros-Z�ld: pz')
            disp('  Z�ld-K�k: zk')
            disp('  K�k-Narancs: kn')
            disp('  Narancs-Piros: np')
            disp('  M�gse: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'pz'
                    Solver.AddtoAlfa(Where,'rg')
                    Smenu=1201;
                case 'zk'
                    Solver.AddtoAlfa(Where,'gb')
                    Smenu=1201;
                case 'kn'
                    Solver.AddtoAlfa(Where,'bo')
                    Smenu=1201;
                case 'np'
                    Solver.AddtoAlfa(Where,'or')
                    Smenu=1201;
                case 'c'
                    Smenu=1;
            end
        case 1201
            display('Elem hozz�ad�s�nak meger�s�t�se:')
            display('   Elem forgat�sa: r')
            display('   V�gleges�t�s: ok')
            display('   Elvet�s: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'ok'
                    Solver.ValidateAlfa(true)
                    disp('A m�dos�t�s t�rolva.')
                    [Solvable,Message]=Solver.Solvability();
                    if ~Solvable
                        disp('!Hiba:')
                    end
                    fprintf(1,Message)
                    pause
                    Smenu=1;
                case 'r'
                    Solver.AddtoAlfa(Where,'roll')
                case 'c'
                    Solver.ValidateAlfa(false)
                    disp('A m�dos�t�s elvetve.')
                    pause
                    Smenu=1;
            end
        case 13
            display('Elem hozz�ad�sa/elt�vol�t�sa a c�l�llapothoz/t�l:')
            display('   Oldalak:')
            display('       Els�: e')
            display('       H�ts�: h')
            display('       Bal: b')
            display('       Jobb: j')
            display('   Cs�csok:')
            display('       Bal els�: be')
            display('       Jobb els�: je')
            display('       Bal h�ts�: bh')
            display('       Jobb h�ts�: jh')
            display('   M�gse: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'e'
                    Where=[0;-1;0];
                    Smenu=131;
                case 'h'
                    Where=[0;1;0];
                    Smenu=131;
                case 'b'
                    Where=[-1;0;0];
                    Smenu=131;
                case 'j'
                    Where=[1;0;0];
                    Smenu=131;
                case 'be'
                    Where=[-1;-1;0];
                    Smenu=132;
                case 'je'
                    Where=[1;-1;0];
                    Smenu=132;
                case 'bh'
                    Where=[-1;1;0];
                    Smenu=132;
                case 'jh'
                    Where=[1;1;0];
                    Smenu=132;
                case 'c'
                    Smenu=1;
            end
        case 131
            disp('Oldalelem hozz�ad�sa/elt�vol�t�sa:')
            disp('  Hozz�ad�s: ht')
            disp('  Elt�vol�t�s: hn')
            disp('  M�gse: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'ht'
                    Solver.AddtoOmega(Where,'def')
                    Smenu=1301;
                case 'hn'
                    Solver.AddtoOmega(Where,'udef')
                    Smenu=1302;
                case 'c'
                    Smenu=1;
            end
        case 132
            disp('Sarokelem hozz�ad�sa/elt�vol�t�sa:')
            disp('  Piros-Z�ld: pz')
            disp('  Z�ld-K�k: zk')
            disp('  K�k-Narancs: kn')
            disp('  Narancs-Piros: np')
            disp('  Elt�vol�t�s: hn')
            disp('  M�gse: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'pz'
                    Solver.AddtoOmega(Where,'rg')
                    Smenu=1301;
                case 'zk'
                    Solver.AddtoOmega(Where,'gb')
                    Smenu=1301;
                case 'kn'
                    Solver.AddtoOmega(Where,'bo')
                    Smenu=1301;
                case 'np'
                    Solver.AddtoOmega(Where,'or')
                    Smenu=1301;
                case 'hn'
                    Solver.AddtoOmega(Where,'udef')
                    Smenu=1302;
                case 'c'
                    Smenu=1;
            end
        case 1301
            display('Elem hozz�ad�s�nak meger�s�t�se:')
            display('   Elem forgat�sa: r')
            display('   V�gleges�t�s: ok')
            display('   Elvet�s: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'ok'
                    Solver.ValidateOmega(true)
                    disp('A m�dos�t�s t�rolva.')
                    [Solvable,Message]=Solver.Solvability();
                    if ~Solvable
                        disp('!Hiba:')
                    end
                    fprintf(1,Message)
                    pause
                    Smenu=1;
                case 'r'
                    Solver.AddtoOmega(Where,'roll')
                case 'c'
                    Solver.ValidateOmega(false)
                    disp('A m�dos�t�s elvetve.')
                    pause
                    Smenu=1;
            end
        case 1302
            disp('Elem elt�vol�t�s�nak meger�s�t�se:')
            disp('  V�gleges�t�s: ok')
            disp('  Elvet�s: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'ok'
                    Solver.ValidateOmega(true)
                    disp('A m�dos�t�s t�rolva.')
                    [Solvable,Message]=Solver.Solvability();
                    if ~Solvable
                        disp('!Hiba:')
                    end
                    fprintf(1,Message)
                    pause
                    Smenu=1;
                case 'c'
                    Solver.ValidateOmega(false)
                    disp('A m�dos�t�s elvetve.')
                    pause
                    Smenu=1;
            end
        otherwise
            Smenu=0;
    end
end
close all
if Solver.Alfa.IsDefinit()
    Kezelo.Kocka=Solver.Alfa;
    Kezelo.Nezet=Solver.Nezet;
    if Kezelo.Kocka.IsLapos()
        if Kezelo.Kocka.ParityTest() || ~isequal(false(2),Kezelo.Kocka.CornerTest())
            KockaHiba=1;
        else
            KockaHiba=0;
        end
    else
        KockaHiba=2;
    end
    if Kezelo.IsLapos()
        NezetHiba=false;
    else
        NezetHiba=true;
    end
end
delete(Solver)
Kezelo.Changed=true;