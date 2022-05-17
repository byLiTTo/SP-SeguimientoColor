function Ib = calcula_deteccion_multiples_esferas_en_imagen(I,centroides_radios)
    
    [numAgrup numAtrib] = size(centroides_radios);

    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));

    [numFilas, numColumnas, numComp] = size(I);
    Ib = logical(zeros(numFilas,numColumnas));
    
    for i=1:numAgrup
        Rc = centroides_radios(i,1);
        Gc = centroides_radios(i,2);
        Bc = centroides_radios(i,3);

        radio = centroides_radios(i,4);

        MD = sqrt( (R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2);

        aux = MD < radio;
        
        Ib = Ib | aux;
    end

end