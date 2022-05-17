function pos_outliers = funcion_detecta_outliers_clase_interes(X,Y)
    valoresY = unique(Y);

    R = X(:,1);
    G = X(:,2);
    B = X(:,3);

    FoI = Y == valoresY(2);     % FILAS DE LA CLASE DE INTERÉS

    % Calculo de la media y desviación típica de en R, G y B de la clase de
    % interés

    medias = mean(X(FoI,:)) ; desv = std(X(FoI,:));
    Rmean = medias(1); Rstd = desv(1);  % SIEMPRE REPRESENTATIVOS DE LA CLASE DE INTERÉS
    Gmean = medias(2); Gstd = desv(2);  
    Bmean = medias(3); Bstd = desv(3);

    factor_outlier = 3;
    % Consideramos que una instancia es un outlier si en cualquiera de sus
    % atributos, el valor está fuera del rango:
    % [media_atributo - 3*sigma_atributo, media_atributo + 3*sigma_atributo]

    outR = (R > Rmean + factor_outlier*Rstd) | (R < Rmean - factor_outlier*Rstd); 
    outG = (G > Gmean + factor_outlier*Gstd) | (G < Gmean - factor_outlier*Gstd); 
    outB = (B > Bmean + factor_outlier*Bstd) | (B < Bmean - factor_outlier*Bstd);

    % UNICAMENTE VALIDAMOS LOS OUTLIERS DE LAS FILAS DE LA CLASE

    outR = and(FoI,outR);
    outG = and(FoI,outG);
    outB = and(FoI,outB);
    
    % UN OUTLIER ES UNA INSTANCIA QUE TIENE UN 1 BINARIO EN CUALQUIERA DE
    % ESOS CANALES
    
    outR_G = or(outR,outG);
    out_R_G_B = or(outR_G,outB);
    
    % CALCULAMOS LAS POSICIONES DE LOS OUTLIERS DETECTADOS
    
    pos_outliers = find(out_R_G_B);
end