% Fase 4: Ajuste de clasificador de imágenes

%% RUTAS A DIRECTORIOS 
    addpath('../01_GeneracionMaterial');
    addpath('../02_Extraer_Representar_Datos/VariablesGeneradas');
    addpath('../03_DiseñoClasificador/VariablesGeneradas');
    
    addpath('Funciones');
    
%% CARGAMOS Y REPRESENTAMOS DATOS

    load ImagenesEntrenamiento_Calibracion_amarillo.mat
    load datos_multiples_esferas_amarillo.mat
    
    [N M numComp numImag] = size(imagenes);
    for i=1:numImag
        imshow(imagenes(:,:,:,i)),title(['Imagen: ' num2str(i) '/' num2str(numImag)])
        pause
    end

    close all

    % 2.- VISUALIZACION DE ESFERAS EN EL ESPACIO DE CARACTERISTICAS JUNTO CON
    % LOS DATOS DE ENTRENAMIENTO
    
    load conjunto_de_datos_amarillo.mat
    representa_multiples_esferas_espacio_ccas(datosMultiplesEsferas, X, Y)

    close all
    
%% CALIBRACION DE RADIO ESFERAS

    close all

    criteriosRadios{1} = 'Radio sin perdida de color';
    criteriosRadios{2} = 'Radio sin ruido de fondo';
    criteriosRadios{3} = 'Radio de compromiso';

    color = [130 30 200];

    for i=1:numImag
        I = imagenes(:,:,:,i);
        figure(4), subplot(2,2,1), imshow(I), title(['Imagen original: ' num2str(i) '/' num2str(numImag)])

        for j=1:length(criteriosRadios)
            centroides_radios = datosMultiplesEsferas(:,[1:3 3+j]);

            Ib = calcula_deteccion_multiples_esferas_en_imagen(I,centroides_radios);

            subplot(2,2,j+1), funcion_visualiza(I,Ib,color)
            title(criteriosRadios{j})
        end
        pause
    end

    close all
     
    % Elegimos el radio que mejores resultados nos ha dado en proporcion a
    % ruido/area de l objeto de seguimiento
    radio = 3;
    datosMultiplesEsferas_clasificador = datosMultiplesEsferas(:,[1:3 3+radio]);
    
%% CALIBRACION DE PARAMETRO DE CONECTIVIDAD: nimPix

    % Calculamos el area del objeto de seguimiento en su posicion más
    % alejada, hemos hecho los videos de tal forma que coincida con la
    % ultima imagen, pero se puede cambiar manualmente. Debería de ser la
    % imagen donde el objeto de seguimiento salga lo más pequeño posible
    close all
    I_objeto_pos_mas_alejada = imagenes(:,:,:,numImag);
    Ib = roipoly(I_objeto_pos_mas_alejada);
    numPixReferencia = sum(Ib(:));
    
    % Posibles valores de numPix, ya que nunca deberia deberia de ser igual
    % a dicha area, solo un porcentaje de la total
    numPixAnalisis = round([0.25 0.5 0.75]*numPixReferencia);
    
    
    % Color con el que se verá los pixeles que están dentro de nuestro
    % rango de los posibles radios
    color = [130 30 200];
    
    % Posibles porcentajes a elegir, se representará el valor del area
    valoresConectividad{1} = ['numPix = ' num2str(numPixAnalisis(1))];
    valoresConectividad{2} = ['numPix = ' num2str(numPixAnalisis(2))];
    valoresConectividad{3} = ['numPix = ' num2str(numPixAnalisis(3))];
    
    close all
    for i=1:numImag
        I = imagenes(:,:,:,i);
        figure(4), subplot(2,2,1), imshow(I), title(['Imagen : ' num2str(i) '/' num2str(numImag)])

        for j=1:length(numPixAnalisis)             
            Ib = calcula_deteccion_multiples_esferas_en_imagen(I,centroides_radios);
            Ib_filtrada = filtra_objetos(Ib,numPixAnalisis(j));

            subplot(2,2,j+1), funcion_visualiza(I,Ib_filtrada,color)
            title(valoresConectividad{j})
        end
        pause
    end
    
    close all

    % Eleccion de numPix en base al analisis de las imagenes anteriores
    numPix = numPixAnalisis(3);
    
%% GUARDADO DE  PARÁMETROS PARA LA APLICACIÓN DEL CLASIFICADOR

    save('./VariablesGeneradas/parametros_clasificador',...
        'datosMultiplesEsferas_clasificador_amarillo','numPix')


