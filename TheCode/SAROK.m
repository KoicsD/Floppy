classdef SAROK
    properties
        forgatas=false
        eltolas=[false false]
        definit=true
    end
    methods
        function obj=eltol(obj,vect)
            if vect(1)~=vect(2)
                obj.forgatas=~obj.forgatas;
            end
            obj.eltolas=xor(obj.eltolas,vect);
        end
    end
end