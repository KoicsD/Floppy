%Ez a szkript a 3x3x1-es kocka szimulációjának "motorja". Ezt hívd meg a
%parancssorból!
%sorfolytonos, kódolt fájlokat használó mentés és betöltés írása.
close all
clear all
FID=fopen('Header_3x3x1.txt','r');
if FID~=-1
    i=1;
    while ~feof(FID)
        H{i}=fgetl(FID);
        i=i+1;
    end
    fclose(FID);
end
Kezelo=VIS_LAP();
WasSolved=true;
menu=1;
KockaHiba=0;
NezetHiba=false;
while (menu)
    clc
    if FID~=-1
        for j=1:i-1
            display(H{j})
        end
    end
    display(' ')
    Kezelo.Visual()
    display(' ')
    switch menu
        case 1
            if (KockaHiba==0) && Kezelo.Kocka.IsSolved()
                if ~WasSolved
                    disp('A kockát sikerült kirakni!')
                    display(' ')
                    WasSolved=true;
                end
            else
                WasSolved=false;
            end
            if KockaHiba || NezetHiba
                disp('! Figyelmeztetés:')
                if KockaHiba==1
                    disp('Bár a kocka 4 különbözõ sarokelemet tartalmaz,')
                    disp('a sarok- és/vagy a paritás-teszt szerint')
                    disp('mégsem rakható ki.')
                elseif KockaHiba==2
                    disp('A kocka nem rakható ki, mivel')
                    disp('nem tartalmaz 4 különbözõ sarokelemet.')
                end
                if NezetHiba
                    disp('A program nem támogatja a jelenlegi nézetet, emiatt')
                    disp('a lenti ''a'', ''s'', ''d'' és ''w'' parancsok')
                    disp('nem mindegyike mûködik.')
                    disp('Ez a probléma csak új állapot betöltésével,')
                    disp('vagy az alapállapot visszaállításával orvosolható,')
                    disp('ami csak a menübõl (''q'' parancs) érhetõ el.')
                end
                display(' ')
            end
            display('Lépések (folytonosan is):')
            display('   Hátsó: w')
            display('   Elsõ: s')
            display('   Bal: a')
            display('   Jobb: d')
            display('Nézetváltások (folytonosan is):')
            display('   Megfordítás X körül: x')
            display('   Megfordítás Y körül: y')
            display('   Forgatás a síkban jobbra: c')
            display('   Forgatás a síkban balra: í')
            display('Menü: q')
            display(' ')
            entry=input('MK>>','s');
            if length(entry)>1
                folyt=true;
                for k=1:length(entry)
                    switch entry(k)
                        case 'w'
                        case 's'
                        case 'a'
                        case 'd'
                        case 'x'
                        case 'y'
                        case 'c'
                        case 'í'
                        otherwise
                            folyt=false;
                    end
                end
                if folyt
                    for k=1:length(entry)
                        switch entry(k)
                            case 'w'
                                Kezelo.hatso()
                            case 's'
                                Kezelo.elso()
                            case 'a'
                                Kezelo.bal()
                            case 'd'
                                Kezelo.jobb()
                            case 'x'
                                Kezelo.X()
                            case 'y'
                                Kezelo.Y()
                            case 'c'
                                Kezelo.Zm()
                            case 'í'
                                Kezelo.Zp()
                        end
                    end
                end
            else
                switch entry
                    case 'q'
                        menu=11;
                    case 'w'
                        Kezelo.hatso()
                    case 's'
                        Kezelo.elso()
                    case 'a'
                        Kezelo.bal()
                    case 'd'
                        Kezelo.jobb()
                    case 'x'
                        Kezelo.X()
                    case 'y'
                        Kezelo.Y()
                    case 'c'
                        Kezelo.Zm()
                    case 'í'
                        Kezelo.Zp()
                end
            end
        case 11
            display('Menü:')
            display('   Folytatás: c')
            display('   Mentés: s')
            display('   Betöltés: l')
            display('   Keverés: x')
            display('   Visszaállítsás: r')
            display('   Megoldó: d')
            display('   Kilépés: q')
            entry=input('MK>>','s');
            switch entry
                case 'c'
                    menu=1;
                case 'x'
                    menu=1;
                    entry=input('A lépések száma:','s');
                    try
                        num=str2double(entry);
                        if num>=0 && mod(num,1)==0
                            Kezelo.kever(num)
                        else
                            display('Hibás számformátum.')
                            pause(0.75)
                        end
                    catch ME
                        display('Hibás számformátum.')
                        pause(0.75)
                    end
                case 'r'
                    menu=1;
                    Kezelo.reset()
                    KockaHiba=0;
                    NezetHiba=false;
                    WasSolved=true;
                case 's'
                    entry=input('A file neve (automatikusan ''.dan'' végzõdést kap): ','s');
                    if Kezelo.Ment(entry)
                        display('A mentés sikertelen.')
                    else
                        display('A mentés sikeres.')
                    end
                    pause
                    menu=1;
                case 'l'
                    menu=1;
                    disp('Az elérhetõ fájlok:')
                    dir '*.dan'
                    entry=input('A választott fájl: ','s');
                    if Kezelo.Tolt(entry)
                        disp('A betöltés sikertelen.')
                    else
                        disp('A betöltés sikeres.')
                        if ~Kezelo.Kocka.IsSolvable()
                            if Kezelo.Kocka.IsLapos()
                                disp('Bár a kocka 4 különbözõ sarokelemet tartalmaz,')
                                disp('a sarok- és/vagy a paritás-teszt szerint')
                                disp('mégsem rakható ki.')
                                KockaHiba=1;
                            else
                                disp('A kocka nem rakható ki, mivel')
                                disp('nem tartalmaz 4 különbözõ sarokelemet.')
                                KockaHiba=2;
                            end
                        else
                            disp('A kocka átment mind a sarok-,')
                            disp('mind a paritás-teszten.')
                            KockaHiba=0;
                        end
                        if ~Kezelo.IsLapos()
                            disp(' ')
                            disp('! A tájolási mátrix érvénytelen:')
                            disp('A program a fájl által megadott nézetben')
                            disp('nem képes kívánnivaló nélkül kezelni a kockát.')
                            disp('Tessék betölteni egy másik fájlt!')
                            NezetHiba=true;
                        else
                            disp('A tájolási mátrix érvényes.')
                            NezetHiba=false;
                        end
                    end
                    pause
                case 'q'
                    menu=0;
                case 'd'
                    menu=1;
                    Solver_3x3x1
            end
        otherwise
            menu=0;
    end
end
close
delete(Kezelo)
clear all
clc