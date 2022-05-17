function representa_datos_fondo(X,Y)
    [numDatos, numAtributos] = size(X);
    valoresY = unique(Y);
    numClases = length(valoresY);
    
    % Añadir los valores RGB de los pixeles de fondo en otro color
    filasFondo = Y == valoresY(1);

    ValoresR = X(filasFondo,1);
    ValoresG = X(filasFondo,2);
    ValoresB = X(filasFondo,3);

    plot3(ValoresR, ValoresG, ValoresB, '.b')

    xlabel('Componente ROJA'), ylabel('Componente VERDE'), zlabel('Componente AZUL')
    ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax]);
    legend('Datos Fondo')
end