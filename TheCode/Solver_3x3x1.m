%Ez a szkript a megoldó motorja.
%Ez automatikusan elindul, amikor belépünk a megoldóba.
%Fejlesztési lehetõségek:
%Az UParityTest() függvénynek van egy hibája, ami miatt a program
%bizonyos megoldhatatlan problémákat megoldhatónak hisz!
%Szûrõk bevezetése a megoldási listára?
%Mentés és betöltés.
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
    display('Megoldó programrész.')
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
                    disp('A jelenlegi nézetet nem támogatja a megoldó.')
                    disp('Tessék másik problémát betölteni!')
                end
            elseif TimeProblem
                disp('! Figyelem:')
                disp('A becsült futási idõ meghaladja')
                disp('a beállított idõkorlátot!')
                disp(' ')
            end
            Solver.List()
            display('Kezdeti állapot módosítása:')
            display('   Hátsó: w')
            display('   Elsõ: s')
            display('   Bal: a')
            display('   Jobb: d')
            display('   Elem szabálytalan hozzáadása: r')
            display('Célállapot módosítása:')
            display('   Hátsó: i')
            display('   Elsõ: k')
            display('   Bal: j')
            display('   Jobb: l')
            display('   Elem szabálytalan hozzáadása/eltávolítása: u')
            display('Nézetváltások (2-esével is):')
            display('   Megfordítás X körül: x')
            display('   Megfordítás Y körül: y')
            display('   Forgatás a síkban jobbra: c')
            display('   Forgatás a síkban balra: í')
            display('Menü: q')
            if Solvable
                display('Megoldó indítása: start')
            end
            %display('Visszatérés a szimulátorhoz: return')
            %display('Visszatérés a MATLAB-hoz: exit')
            display(' ')
            entry=input('MK/S>>','s');
            if size(entry,2)==2
                folyt=true;
                for j=1:2
                    switch entry(j)
                        case 'x'
                        case 'y'
                        case 'c'
                        case 'í'
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
                            case 'í'
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
                    case 'í'
                        Solver.Zp()
                    case 'start'
                        if Solvable
                            disp('A szolver futtatása...')
                            if Solver.Solve()
                                disp('Idõtúllépési hiba.')
                                pause(1)
                            else
                                disp('Kész.')
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
            display('Menü:')
            display('   Folytatás: c')
            display('   Kirakott kezdeti állapot: as')
            display('   Kirakott célállapot: os')
            display('   Határozatlan célállapot: ou')
            display('   A kezdetivel megegyezõ célállapot: oa')
            display('   Max. lépésszám állítása: sm')
            display('   Max. futási idõ állítása: tm')
            %display('   Mentés: s')
            %display('   Betöltés: l')
            display('   Vissza a szimulátorhoz: q')
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
                    entry=input('A lépések száma:','s');
                    try
                        num=str2double(entry);
                        if num>=0 && mod(num,1)==0
                            Solver.StepMax=num;
                            display(['Beállított maximális lépésszám: ' ...
                                num2str(Solver.StepMax)])
                            num=Solver.TEstimate();
                            if ~isnan(num)
                                display(['Becsült futási idõ: ' ...
                                    num2str(num) ' másodperc'])
                            end
                            if num>Solver.TimeMax
                                TimeProblem=true;
                                disp('! Figyelem:')
                                disp('Ez az érték meghaladja a beállított')
                                disp('idõkorlátot!')
                            else
                                TimeProblem=false;
                            end
                            pause
                        else
                            display('Hibás számformátum!')
                            pause(0.75)
                        end
                    catch ME
                        display('Hibás számformátum!')
                        pause(0.75)
                    end
                    Smenu=1;
                case 'tm'
                    entry=input('Az idõkorlát [másodperc]:','s');
                    try
                        num=str2double(entry);
                        if num>=0
                            Solver.TimeMax=num;
                            display(['Beállított max. futási idõ: ' ...
                                num2str(Solver.TimeMax) ' másodperc'])
                            num=Solver.TEstimate();
                            if num>Solver.TimeMax
                                TimeProblem=true;
                                disp('! Figyelem:')
                                disp('Ez az érték kisebb, mint a')
                                disp(['becsült futási idõ (' num2str(num) ' másodperc)!'])
                            else
                                TimeProblem=false;
                            end
                            pause
                        else
                            display('Hibás számformátum!')
                            pause(0.75)
                        end
                    catch ME
                        display('Hibás számformátum!')
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
            display('Elem hozzáadása a kezdeti állapothoz:')
            display('   Oldalak:')
            display('       Elsõ: e')
            display('       Hátsó: h')
            display('       Bal: b')
            display('       Jobb: j')
            display('   Csúcsok:')
            display('       Bal elsõ: be')
            display('       Jobb elsõ: je')
            display('       Bal hátsó: bh')
            display('       Jobb hátsó: jh')
            display('   Mégse: c')
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
            disp('Sarokelem hozzáadása:')
            disp('  Piros-Zöld: pz')
            disp('  Zöld-Kék: zk')
            disp('  Kék-Narancs: kn')
            disp('  Narancs-Piros: np')
            disp('  Mégse: c')
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
            display('Elem hozzáadásának megerõsítése:')
            display('   Elem forgatása: r')
            display('   Véglegesítés: ok')
            display('   Elvetés: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'ok'
                    Solver.ValidateAlfa(true)
                    disp('A módosítás tárolva.')
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
                    disp('A módosítás elvetve.')
                    pause
                    Smenu=1;
            end
        case 13
            display('Elem hozzáadása/eltávolítása a célállapothoz/tól:')
            display('   Oldalak:')
            display('       Elsõ: e')
            display('       Hátsó: h')
            display('       Bal: b')
            display('       Jobb: j')
            display('   Csúcsok:')
            display('       Bal elsõ: be')
            display('       Jobb elsõ: je')
            display('       Bal hátsó: bh')
            display('       Jobb hátsó: jh')
            display('   Mégse: c')
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
            disp('Oldalelem hozzáadása/eltávolítása:')
            disp('  Hozzáadás: ht')
            disp('  Eltávolítás: hn')
            disp('  Mégse: c')
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
            disp('Sarokelem hozzáadása/eltávolítása:')
            disp('  Piros-Zöld: pz')
            disp('  Zöld-Kék: zk')
            disp('  Kék-Narancs: kn')
            disp('  Narancs-Piros: np')
            disp('  Eltávolítás: hn')
            disp('  Mégse: c')
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
            display('Elem hozzáadásának megerõsítése:')
            display('   Elem forgatása: r')
            display('   Véglegesítés: ok')
            display('   Elvetés: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'ok'
                    Solver.ValidateOmega(true)
                    disp('A módosítás tárolva.')
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
                    disp('A módosítás elvetve.')
                    pause
                    Smenu=1;
            end
        case 1302
            disp('Elem eltávolításának megerõsítése:')
            disp('  Véglegesítés: ok')
            disp('  Elvetés: c')
            entry=input('MK/S>>','s');
            switch entry
                case 'ok'
                    Solver.ValidateOmega(true)
                    disp('A módosítás tárolva.')
                    [Solvable,Message]=Solver.Solvability();
                    if ~Solvable
                        disp('!Hiba:')
                    end
                    fprintf(1,Message)
                    pause
                    Smenu=1;
                case 'c'
                    Solver.ValidateOmega(false)
                    disp('A módosítás elvetve.')
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