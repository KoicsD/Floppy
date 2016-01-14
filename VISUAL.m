classdef VISUAL < handle
    %Ez a kock�t kezel� objektum oszt�ly�nak sz�l�oszt�lya. Tartalmazza
    %a Kock�t modellez� objektumot, a t�jol�st k�dol� m�trixot, az utols�
    %�br�zol�s �ta t�rt�nt v�ltoz�sok logikai v�ltoz�j�t, tov�bb� a handle
    %aloszt�lyak�nt lehet�v� teszi, hogy a v�ltoz�kat m�dos�t�
    %tagf�ggv�nyeknek ne kelljen visszat�rni�k.
    %Ennek aloszt�lya a 3x3x1-es kocka kezel�s�re szolg�l� VIS_LAPOS
    %oszt�ly, de tervbe van v�ve a 3x3x3-as kock�t kezel� oszt�ly is, mint
    %aloszt�ly.
    properties
        Kocka
        Nezet=eye(3)
        Changed=true
    end
    methods
        function out=IsOrtog(obj)
            if obj.Nezet*obj.Nezet'==eye(3)
                out=true;
            else
                out=false;
            end
        end
    end
end