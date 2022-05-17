function datosEsferaAgrupacion = calcula_datos_esferas_agrupacion(Xcolor_agrupacion, X, Y)
    valoresY = unique(Y);
    FoF = Y == valoresY(1);
    Xfondo = X(FoF,:);

    % 1.- Calcula centroide de los puntos del color de seguimiento de la
    % agrupacion
    valoresMedios = mean(Xcolor_agrupacion);
    Rc = valoresMedios(1);
    Gc = valoresMedios(2);
    Bc = valoresMedios(3);
    
    % 2.- Calcula el vector distancias  entre el centroide anterior y cada uno
    % de los puntos de Xcolor_agrupacion
    P = [Rc; Gc; Bc];
    NP_agrupacion = Xcolor_agrupacion';
    Pamp = repmat(P,1,size(NP_agrupacion,2));
    vectorDistanciaAgrupacion = sqrt(sum((Pamp-NP_agrupacion).^2));
    
    % 3.- Caclula el vector distancia entre el centroide anterior y cada uno de
    % los puntos de las muestras de fondo que hay en X
    % P = [Rc; Gc; Bc];
    NP_fondo = Xfondo';
    Pamp = repmat(P,1,size(NP_fondo,2));
    vectorDistanciaFondo = sqrt(sum((Pamp-NP_fondo).^2));
    
    % 4.- Calcular r1 y r2 a partir de los vectores distancia anteriores
    r1 = max(vectorDistanciaAgrupacion);
    r2 = min(vectorDistanciaFondo);
    
    % 5.- Calcular el radio de compromiso r12
%     if(r1 > r2)
%         r12 = mean([r1 r2]);
%     else
%         r12 = 0;
%     end
    r12 = mean([r1 r2]);
    
    % 6.- Devolver datosEsferaAgrupacion = [Rc, Gc, Bc, r1, r2, r12] (vector fila)
    datosEsferaAgrupacion = [Rc, Gc, Bc, r1, r2, r12];
end