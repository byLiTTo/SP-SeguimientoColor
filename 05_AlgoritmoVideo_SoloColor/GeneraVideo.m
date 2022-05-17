% Fase 5: Generación de video

    clear
    close all
    clc
    
%% RUTAS A DIRECTORIOS Y CARGA DE INFORMACIÓN

    addpath('../01_GeneracionMaterial');
    addpath('../04_AjusteClasificador_ImgCalib/VariablesGeneradas');
    
    addpath('Funciones');
    
    load parametros_clasificador_amarillo.mat
    
%% LECTURA VIDEO ENTRADA (original)

    nombre_archivo_video_entrada = '01_ColorAmarillo.avi';
    videoInput = VideoReader(nombre_archivo_video_entrada);

    [numFrames, numFilasFrame, numColumnasFrame, FPS] = ...
        carga_video_entrada(videoInput);
    
%% GENERACIÓN VIDEO SALIDA

    nombre_archivo_video_salida = '05_Color.avi';
    videoOutput = VideoWriter(nombre_archivo_video_salida);
    videoOutput.FrameRate = FPS;
    
    open(videoOutput);

    % Color con el que se representará el centroide
    color = [0 0 255];
    
    for i=1:numFrames
        I=read(videoInput,i);

        Ib = calcula_deteccion_multiples_esferas_en_imagen(I,datosMultiplesEsferas_clasificador);
        Ib_filtrada = filtra_objetos(Ib,numPix);

        if sum(Ib_filtrada(:)) > 0  
            [Ib_etiquetada numEtiq] = funcion_etiquetar(Ib_filtrada);

            centroides = calcula_centroides(Ib_etiquetada);
            numCentroides = size(centroides,1);

            for j=1:numCentroides
                x = round(centroides(j,1));
                y = round(centroides(j,2));

                if (y>2 && y<numFilasFrame-1) && (x>2 && x<numColumnasFrame-1)
                    I(y-1:y+1, x-1:x+1,1) = color(1);
                    I(y-1:y+1, x-1:x+1,2) = color(2);
                    I(y-1:y+1, x-1:x+1,3) = color(3);
                else
                    I(y, x, 1) = color(1);
                    I(y, x, 2) = color(2);
                    I(y, x, 3) = color(3);
                end
            end
        end
        writeVideo(videoOutput,I);
    end

    close(videoOutput);
    
    
    