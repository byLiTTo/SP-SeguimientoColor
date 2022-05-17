% FASE 2: EXTRAER Y REPRESENTAR LOS DATOS

clear
close all
clc
    
%% RUTAS A DIRECTORIOS CON INFORMACI�N    

addpath('Funciones')
addpath('../01_GeneracionMaterial')

%% CARGAR IM�GENES DE ENTRENAMIENTO

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

% =========================================================================
% 2.1.1. Para cada imagen de calibraci�n que contiene el objeto
% =========================================================================
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

% =========================================================================
% 2.1.3. Generaci�n de un primer conjunto de datos X e Y
% =========================================================================
%% GENERACI�N DE CONJUNTO DE DATOS X e Y

X = double([DatosColor(:,2:end) ; DatosFondo(:,2:end) ]);
Y = [ones(size(DatosColor,1),1) ; zeros(size(DatosFondo,1),1) ];

save('./VariablesGeneradas/conjunto_de_datos_original_amarillo', 'X', 'Y')

% =========================================================================
% 2.2. Representaci�n de los datos del color objeto de seguimiento y otros del fondo de la escena
% =========================================================================
%% REPRESENTACI�N DE LA INFORMACI�N

clear all
close all
clc
load('./VariablesGeneradas/conjunto_de_datos_original_amarillo.mat')
representa_datos_color_seguimiento_fondo(X,Y), title('Gr�fica original');

% =========================================================================
% 2.3.2. Generar el conjunto de datos final X e Y
% =========================================================================
%% DETECCI�N Y ELIMINACI�N DE OUTLIERS

pos_outliers = funcion_detecta_outliers_clase_interes(X,Y);
X(pos_outliers,:) = [];
Y(pos_outliers) = [];


% =========================================================================
% 2.3.3. Representar en el espacio RGB todos los valores RGB
% =========================================================================
%% REPRESENTACI�N DE LA INFORMACI�N SIN OUTLIERS
representa_datos_color_seguimiento_fondo(X,Y), title('Gr�fica sin outliers');

%% GUARDADO DE LA INFORMACI�N DEL CONJUNTO DE DATOS    
    
save('./VariablesGeneradas/conjunto_de_datos_amarillo', 'X', 'Y')

%% LIMPIAR RUTAS A�ADIDAS

rmpath('Funciones')
rmpath('../01_GeneracionMaterial')
    
    
    