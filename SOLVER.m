classdef SOLVER < handle
    %Ez a megoldóobjektum osztályának szülõosztálya. A megoldó mezõi itt
    %vannak definiálva. A 3x3x1-esen kívül tervben van egy 3x3x3-as kocka
    %megoldására képes alosztály.
    properties
        Alfa %kezdõ kocka
        Omega %célkocka
        Nezet=eye(3) %tájolási mátrix
        StepMax %maximáli lépésszám
        TEstimateFcn %futásidõt becslõ függvény
        TimeMax %maximális futási idõ
        AlfaTemp %átmeneti kezdõkocka
        ATmpTovalidate=false %jelz, ha van véglegesítésre váró AlfaTemp
        OmegaTemp %átmeneti célkocka
        OTmpTovalidate=false %jelzi, ha van véglegesítésre váró OmegaTemp
        AlfaChanged=true %jelzi, ha a kezdõkocka megváltozott
        OmegaChanged=true %jelzi, ha a célkocka megváltozott
        Solved=false %jelzi, ha lefutott a megoldófüggvény
        Solution=cell(0,1) %a megoldások listája
        NSol=0 %a megoldások száma
        Time %a tényleges futási idõ
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