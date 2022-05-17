% FASE 2: EXTRAER Y REPRESENTAR LOS DATOS

    clear
    close all
    clc
    
%% RUTAS A DIRECTORIOS CON INFORMACI�N    

    addpath('Funciones')
    addpath('../01_GeneracionMaterial')

%% CARGAR IM�GENES DE ENTRENAMIENTO

    load ImagenesEntrenamiento_Calibracion_amarillo.mat
    [N M numComp numImag] = size(imagenes);

    % Vemos las imagenesx
    for i=1:numImag
        imshow(imagenes(:,:,:,i)),title(['Imagen: ' num2str(i)])
        pause
    end
    close all

%% SELECCIONAR REGI�N DE COLORES DE FONDO

    numImagFondo = 2;
    veces = 2;

    DatosFondo = [];
    for i=1:numImagFondo
        for j=1:veces
            I = imagenes(:,:,:,i);

            R = I(:,:,1);
            G = I(:,:,2);
            B = I(:,:,3);

            disp(['Imagen: ' num2str(i) '/' num2str(numImagFondo) ' Repeticion: ' num2str(j)]);

            ROI = roipoly(I); 

            DatosFondo = [DatosFondo; i*ones(sum(ROI(:)),1) R(ROI) G(ROI) B(ROI) ];
        end
    end
    close all

%% SELECCIONAR REGI�N DEL COLOR DE SEGUIMIENTO

    DatosColor = [];
    for i=(numImagFondo+1):numImag
        I = imagenes(:,:,:,i);

        R = I(:,:,1);
        G = I(:,:,2);
        B = I(:,:,3);

         disp(['Imagen: ' num2str(i) '/' num2str(numImag)]);

        ROI = roipoly(I);

        DatosColor = [DatosColor; i*ones(sum(ROI(:)),1) R(ROI) G(ROI) B(ROI) ];
    end
    close all

    %% GENERACI�N DE CONJUNTO DE DATOS X e Y

    X = double([DatosColor(:,2:end) ; DatosFondo(:,2:end) ]);
    Y = [ones(size(DatosColor,1),1) ; zeros(size(DatosFondo,1),1) ];

    save('./VariablesGeneradas/conjunto_de_datos_original_amarillo', 'X', 'Y')

%% REPRESENTACI�N DE LA INFORMACI�N

    clear all
    close all
    clc
    load('./VariablesGeneradas/conjunto_de_datos_original_amarillo.mat')
    representa_datos_color_seguimiento_fondo(X,Y), title('Gr�fica original');

%% DETECCI�N Y ELIMINACI�N DE OUTLIERS

    pos_outliers = funcion_detecta_outliers_clase_interes(X,Y);
    X(pos_outliers,:) = [];
    Y(pos_outliers) = [];

    representa_datos_color_seguimiento_fondo(X,Y), title('Gr�fica sin outliers');

%% GUARDADO DE LA INFORMACI�N DEL CONJUNTO DE DATOS    
    
    save('./VariablesGeneradas/conjunto_de_datos_amarillo', 'X', 'Y')
    
    
    