function representa_datos_color_seguimiento_fondo(X,Y)
    [numDatos, numAtributos] = size(X);
    valoresY = unique(Y);
    numClases = length(valoresY);
    
    filasColor = Y == valoresY(2);

    ValoresR = X(filasColor,1);
    ValoresG = X(filasColor,2);
    ValoresB = X(filasColor,3);

    figure, plot3(ValoresR, ValoresG, ValoresB, '.r')

    % Añadir los valores RGB de los pixeles de fondo en otro color
    filasFondo = Y == valoresY(1);

    ValoresR = X(filasFondo,1);
    ValoresG = X(filasFondo,2);
    ValoresB = X(filasFondo,3);

    hold on, plot3(ValoresR, ValoresG, ValoresB, '.b')

    xlabel('Componente ROJA'), ylabel('Componente VERDE'), zlabel('Componente AZUL')
    ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax]);
    legend('Datos Color', 'Datos Fondo')
end