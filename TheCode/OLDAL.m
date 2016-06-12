classdef OLDAL
    properties
        forgatas=false
        definit=true
    end
    methods
        function obj=forog(obj)
            if obj.forgatas
                obj.forgatas=false;
            else
                obj.forgatas=true;
            end
        end
    end
end