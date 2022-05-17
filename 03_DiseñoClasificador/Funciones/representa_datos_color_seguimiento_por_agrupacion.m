function representa_datos_color_seguimiento_por_agrupacion(Xclase, idx)
    valoresIdx = unique(idx);
    numEsferas = length(valoresIdx);
    
    [numDatos, numAtributos] = size(Xclase);

    Color ={'.y'; '.m'; '.c'; '.r'; '.g'; '.k'}; 
    numColor = 0;
    
    for i=1:numEsferas        
        filasColor = idx == valoresIdx(i);
        
        ValoresR = Xclase(filasColor,1);
        ValoresG = Xclase(filasColor,2);
        ValoresB = Xclase(filasColor,3);
        
        numColor = numColor+1;
        if(numColor>6)
            numColor=1;
        end
        
        hold on, plot3(ValoresR, ValoresG, ValoresB, Color{numColor})
    end
    xlabel('Componente ROJA'), ylabel('Componente VERDE'), zlabel('Componente AZUL')
    ValorMin = 0; ValorMax = 255; axis([ValorMin ValorMax ValorMin ValorMax ValorMin ValorMax]);
    legend('Datos Color')
end