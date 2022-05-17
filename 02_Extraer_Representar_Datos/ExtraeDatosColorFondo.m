% FASE 2: EXTRAER Y REPRESENTAR LOS DATOS

clear
close all
clc
    
%% RUTAS A DIRECTORIOS CON INFORMACIÓN    

addpath('Funciones')
addpath('../01_GeneracionMaterial')

%% CARGAR IMÁGENES DE ENTRENAMIENTO

load ImagenesEntrenamiento_Calibracion.mat
[N M numComp numImag] = size(imagenes);

% Vemos las imagenesx
for i=1:numImag
    imshow(imagenes(:,:,:,i)),title(['Imagen: ' num2str(i)])
    pause
end
close all

% =========================================================================
% 2.1.2. Para la imagen de fondo
% =========================================================================
%% SELECCIONAR REGIÓN DE COLORES DE FONDO

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

% =========================================================================
% 2.1.1. Para cada imagen de calibración que contiene el objeto
% =========================================================================
%% SELECCIONAR REGIÓN DEL COLOR DE SEGUIMIENTO

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

% =========================================================================
% 2.1.3. Generación de un primer conjunto de datos X e Y
% =========================================================================
%% GENERACIÓN DE CONJUNTO DE DATOS X e Y

X = double([DatosColor(:,2:end) ; DatosFondo(:,2:end) ]);
Y = [ones(size(DatosColor,1),1) ; zeros(size(DatosFondo,1),1) ];

save('./VariablesGeneradas/conjunto_de_datos_original_amarillo', 'X', 'Y')

% =========================================================================
% 2.2. Representación de los datos del color objeto de seguimiento y otros del fondo de la escena
% =========================================================================
%% REPRESENTACIÓN DE LA INFORMACIÓN

clear all
close all
clc
load('./VariablesGeneradas/conjunto_de_datos_original_amarillo.mat')
representa_datos_color_seguimiento_fondo(X,Y), title('Gráfica original');

% =========================================================================
% 2.3.2. Generar el conjunto de datos final X e Y
% =========================================================================
%% DETECCIÓN Y ELIMINACIÓN DE OUTLIERS

pos_outliers = funcion_detecta_outliers_clase_interes(X,Y);
X(pos_outliers,:) = [];
Y(pos_outliers) = [];


% =========================================================================
% 2.3.3. Representar en el espacio RGB todos los valores RGB
% =========================================================================
%% REPRESENTACIÓN DE LA INFORMACIÓN SIN OUTLIERS
representa_datos_color_seguimiento_fondo(X,Y), title('Gráfica sin outliers');

%% GUARDADO DE LA INFORMACIÓN DEL CONJUNTO DE DATOS    
    
save('./VariablesGeneradas/conjunto_de_datos_amarillo', 'X', 'Y')

%% LIMPIAR RUTAS AÑADIDAS

rmpath('Funciones')
rmpath('../01_GeneracionMaterial')
    
    
    