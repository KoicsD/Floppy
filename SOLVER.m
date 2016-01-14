classdef SOLVER < handle
    %Ez a megold�objektum oszt�ly�nak sz�l�oszt�lya. A megold� mez�i itt
    %vannak defini�lva. A 3x3x1-esen k�v�l tervben van egy 3x3x3-as kocka
    %megold�s�ra k�pes aloszt�ly.
    properties
        Alfa %kezd� kocka
        Omega %c�lkocka
        Nezet=eye(3) %t�jol�si m�trix
        StepMax %maxim�li l�p�ssz�m
        TEstimateFcn %fut�sid�t becsl� f�ggv�ny
        TimeMax %maxim�lis fut�si id�
        AlfaTemp %�tmeneti kezd�kocka
        ATmpTovalidate=false %jelz, ha van v�gleges�t�sre v�r� AlfaTemp
        OmegaTemp %�tmeneti c�lkocka
        OTmpTovalidate=false %jelzi, ha van v�gleges�t�sre v�r� OmegaTemp
        AlfaChanged=true %jelzi, ha a kezd�kocka megv�ltozott
        OmegaChanged=true %jelzi, ha a c�lkocka megv�ltozott
        Solved=false %jelzi, ha lefutott a megold�f�ggv�ny
        Solution=cell(0,1) %a megold�sok list�ja
        NSol=0 %a megold�sok sz�ma
        Time %a t�nyleges fut�si id�
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