function representa_multiples_esferas_espacio_ccas(datosMultiplesEsferas, X, Y)
    [numAgrup numAtrib] = size(datosMultiplesEsferas);

    criteriosRadios{1} = 'Radio sin perdida de color';
    criteriosRadios{2} = 'Radio sin ruido de fondo';
    criteriosRadios{3} = 'Radio de compromiso';
    
    valoresCentros = datosMultiplesEsferas(:,1:3);
    valoresRadios = datosMultiplesEsferas(:,4:6);
    
    for i=1:3
        figure(i),set(i,'Name',criteriosRadios{i})
        representa_datos_color_seguimiento_fondo(X,Y), hold on

        for j=1:numAgrup
            representa_esfera(valoresCentros(j,:),valoresRadios(j,i))
        end
    end
end

function representa_datos_color_seguimiento_fondo(X,Y)
    [numDatos, numAtributos] = size(X);
    valoresY = unique(Y);
    numClases = length(valoresY);
    
    filasColor = Y == valoresY(2);

    ValoresR = X(filasColor,1);
    ValoresG = X(filasColor,2);
    ValoresB = X(filasColor,3);

    plot3(ValoresR, ValoresG, ValoresB, '.r')

    % A?adir los valores RGB de los pixeles de fondo en otro color
    filasFondo = Y == valoresY(1);

    ValoresR = X(filasFondo,1);
    ValoresG = X(filasFondo,2);
    ValoresB = X(filasFondo,3);

    hold on, plot3(ValoresR, ValoresG, ValoresB, '.b')

    xlabel('Componente ROJA'), ylabel('Componente VERDE'), zlabel('Componente AZUL')
    ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax]);
    legend('Datos Color', 'Datos Fondo')
end

function representa_esfera(centroide, radio)
    [R,G,B] = sphere(100);
    x = radio*R(:) + centroide(1);
    y = radio*G(:) + centroide(2);
    z = radio*B(:) + centroide(3);
    
    plot3(x,y,z, '-y') 
end