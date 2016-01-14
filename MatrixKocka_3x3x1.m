%Ez a szkript a 3x3x1-es kocka szimul�ci�j�nak "motorja". Ezt h�vd meg a
%parancssorb�l!
%sorfolytonos, k�dolt f�jlokat haszn�l� ment�s �s bet�lt�s �r�sa.
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
                    disp('A kock�t siker�lt kirakni!')
                    display(' ')
                    WasSolved=true;
                end
            else
                WasSolved=false;
            end
            if KockaHiba || NezetHiba
                disp('! Figyelmeztet�s:')
                if KockaHiba==1
                    disp('B�r a kocka 4 k�l�nb�z� sarokelemet tartalmaz,')
                    disp('a sarok- �s/vagy a parit�s-teszt szerint')
                    disp('m�gsem rakhat� ki.')
                elseif KockaHiba==2
                    disp('A kocka nem rakhat� ki, mivel')
                    disp('nem tartalmaz 4 k�l�nb�z� sarokelemet.')
                end
                if NezetHiba
                    disp('A program nem t�mogatja a jelenlegi n�zetet, emiatt')
                    disp('a lenti ''a'', ''s'', ''d'' �s ''w'' parancsok')
                    disp('nem mindegyike m�k�dik.')
                    disp('Ez a probl�ma csak �j �llapot bet�lt�s�vel,')
                    disp('vagy az alap�llapot vissza�ll�t�s�val orvosolhat�,')
                    disp('ami csak a men�b�l (''q'' parancs) �rhet� el.')
                end
                display(' ')
            end
            display('L�p�sek (folytonosan is):')
            display('   H�ts�: w')
            display('   Els�: s')
            display('   Bal: a')
            display('   Jobb: d')
            display('N�zetv�lt�sok (folytonosan is):')
            display('   Megford�t�s X k�r�l: x')
            display('   Megford�t�s Y k�r�l: y')
            display('   Forgat�s a s�kban jobbra: c')
            display('   Forgat�s a s�kban balra: �')
            display('Men�: q')
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
                        case '�'
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
                            case '�'
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
                    case '�'
                        Kezelo.Zp()
                end
            end
        case 11
            display('Men�:')
            display('   Folytat�s: c')
            display('   Ment�s: s')
            display('   Bet�lt�s: l')
            display('   Kever�s: x')
            display('   Vissza�ll�ts�s: r')
            display('   Megold�: d')
            display('   Kil�p�s: q')
            entry=input('MK>>','s');
            switch entry
                case 'c'
                    menu=1;
                case 'x'
                    menu=1;
                    entry=input('A l�p�sek sz�ma:','s');
                    try
                        num=str2double(entry);
                        if num>=0 && mod(num,1)==0
                            Kezelo.kever(num)
                        else
                            display('Hib�s sz�mform�tum.')
                            pause(0.75)
                        end
                    catch ME
                        display('Hib�s sz�mform�tum.')
                        pause(0.75)
                    end
                case 'r'
                    menu=1;
                    Kezelo.reset()
                    KockaHiba=0;
                    NezetHiba=false;
                    WasSolved=true;
                case 's'
                    entry=input('A file neve (automatikusan ''.dan'' v�gz�d�st kap): ','s');
                    if Kezelo.Ment(entry)
                        display('A ment�s sikertelen.')
                    else
                        display('A ment�s sikeres.')
                    end
                    pause
                    menu=1;
                case 'l'
                    menu=1;
                    disp('Az el�rhet� f�jlok:')
                    dir '*.dan'
                    entry=input('A v�lasztott f�jl: ','s');
                    if Kezelo.Tolt(entry)
                        disp('A bet�lt�s sikertelen.')
                    else
                        disp('A bet�lt�s sikeres.')
                        if ~Kezelo.Kocka.IsSolvable()
                            if Kezelo.Kocka.IsLapos()
                                disp('B�r a kocka 4 k�l�nb�z� sarokelemet tartalmaz,')
                                disp('a sarok- �s/vagy a parit�s-teszt szerint')
                                disp('m�gsem rakhat� ki.')
                                KockaHiba=1;
                            else
                                disp('A kocka nem rakhat� ki, mivel')
                                disp('nem tartalmaz 4 k�l�nb�z� sarokelemet.')
                                KockaHiba=2;
                            end
                        else
                            disp('A kocka �tment mind a sarok-,')
                            disp('mind a parit�s-teszten.')
                            KockaHiba=0;
                        end
                        if ~Kezelo.IsLapos()
                            disp(' ')
                            disp('! A t�jol�si m�trix �rv�nytelen:')
                            disp('A program a f�jl �ltal megadott n�zetben')
                            disp('nem k�pes k�v�nnival� n�lk�l kezelni a kock�t.')
                            disp('Tess�k bet�lteni egy m�sik f�jlt!')
                            NezetHiba=true;
                        else
                            disp('A t�jol�si m�trix �rv�nyes.')
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