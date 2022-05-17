% Fase 3: Dise�o del Clasificador (Basado en esferas)

clear
close all
clc

% =========================================================================
% 3.1.1. A�adir a la representaci�n del apartado 2.2.1 las superficies 
% esf�ricas a las que hace referencia el planteamiento anterior.
% =========================================================================
%% RUTAS A DIRECTORIOS CON INFORMACI�N
    
addpath('../02_Extraer_Representar_Datos/VariablesGeneradas');
addpath('Funciones');
    
%% LECTURA Y REPRESENTACI�N DE DATOS
    
load conjunto_de_datos.mat
representa_datos_color_seguimiento_fondo(X,Y)
    
%% AGRUPAMIENTO DE DATOS Y REPRESENTACI�N - clase de inter�s

% Extraemos los datos del color de seguimiento
valoresY = unique(Y);
FoI = Y == valoresY(2);
Xcolor = X(FoI,:);

% Calculamos las agrupaciones
numAgrup = 5;
idx = funcion_kmeans(Xcolor, numAgrup);
%idx = kmeans(Xcolor, numAgrup);

% Representamos agrupaciones
close all
representa_datos_color_seguimiento_fondo(X,Y)

figure
representa_datos_fondo(X,Y), hold on
representa_datos_color_seguimiento_por_agrupacion(Xcolor,idx)
hold off
    
%% C�LCULO DE LAS ESFERAS DE CADA AGRUPACI�N

% Variable que contiene los datos de todas las esferas de todas las
% agrupaciones
% Filas: tantas como agrupaciones
% Columnas: 3 valores para el centroide, 3 para radios
datosMultiplesEsferas = zeros(numAgrup,6);

for i=1:numAgrup
    Fagrupacion = idx == i;
    Xcolor_agrupacion = Xcolor(Fagrupacion,:);

    datosEsferaAgrupacion = calcula_datos_esferas_agrupacion(Xcolor_agrupacion, X, Y);
    datosMultiplesEsferas(i,:) = datosEsferaAgrupacion;
end
    
%% REPRESENTACI�N DE LAS ESFERAS EN EL ESPACIO DE CARACTER�STICAS

close all

% Separamos los valores de los centroides y los radios
valoresCentros = datosMultiplesEsferas(:,1:3);
valoresRadios = datosMultiplesEsferas(:,4:6);

% En nuestro caso tendremos 3 posibles radios
significadoRadio{1} = 'Radio sin perdida';
significadoRadio{2} = 'Radio sin ruido';
significadoRadio{3} = 'Radio compromiso';

for i=1:3
    figure(i),set(i,'Name',significadoRadio{i})
    representa_datos_fondo(X,Y), hold on
    representa_datos_color_seguimiento_por_agrupacion(Xcolor,idx)

    for j=1:numAgrup
        representa_esfera(valoresCentros(j,:),valoresRadios(j,i))
    end
end
    
%% GUARDADO DE LA INFORMACI�N DE LOS DATOS DE LAS ESFERAS

save('./VariablesGeneradas/datos_multiples_esferas','datosMultiplesEsferas')

%% LIMPIAR RUTAS A DIRECTORIOS CON INFORMACI�N
    
rmpath('../02_Extraer_Representar_Datos/VariablesGeneradas');
rmpath('Funciones');
    
    
    