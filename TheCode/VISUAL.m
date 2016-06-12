classdef VISUAL < handle
    %Ez a kockát kezelõ objektum osztályának szülõosztálya. Tartalmazza
    %a Kockát modellezõ objektumot, a tájolást kódoló mátrixot, az utolsó
    %ábrázolás óta történt változások logikai változóját, továbbá a handle
    %alosztályaként lehetõvé teszi, hogy a változókat módosító
    %tagfüggvényeknek ne kelljen visszatérniük.
    %Ennek alosztálya a 3x3x1-es kocka kezelésére szolgáló VIS_LAPOS
    %osztály, de tervbe van véve a 3x3x3-as kockát kezelõ osztály is, mint
    %alosztály.
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