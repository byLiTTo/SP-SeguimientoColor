% FASE 1: GENERACI�N DE MATERIAL

clear
close all
clc

% =========================================================================
% 1.1 Secuencia de video para evaluar el funcionamiento del algoritmo de 
%   seguimiento
% =========================================================================
%% OBTENCION FPS DE LA C�MARA
   
video = videoinput('winvideo',1,'YUY2_320x240');
video.TriggerRepeat = inf;
video.FrameGrabInterval = 1;

TIEMPO = [];

disp('ACTIVANDO c�mara para c�lculo de FPS');
start(video)
while video.FramesAcquired < 300
    [I TIME] = getdata(video,1);
    TIEMPO = [TIEMPO; TIME];
end
stop(video)
flushdata(video);
disp('APAGANDO c�mara');

% Contador donde obtendremos los FPS a los que trabaja nuestra c�mara
camaraFPS = 0;
for i=1:length(TIEMPO)
    if floor(TIEMPO(i)) == 1
        camaraFPS = camaraFPS+1;
    end
end

% N�mero de FPS a los que queremos que se grabe el v�deo
videoFPS = 10;

% Intervalo de captura de cada frame al que debe trabajar el v�deo,
% para que se grabe a la cantidad de FPS deseada
intervalo = camaraFPS/videoFPS;
    
%% GENERACI�N DE ARCHIVO DE V�DEO

% Nombre que le vamos a poner al archivo.avi que vamos a generar
nombre = '01_Color.avi';

% Duraci�n deseada del v�deo que grabaremos
duracion = 30;

% N�mero de frames que debemos capturar para que se cumpla la duraci�n
% que hemos indicado
framesTotales = duracion*videoFPS;

%video = videoinput('winvideo',1,'YUY2_320x240');
%video.TriggerRepeat = inf;
video.FrameGrabInterval = intervalo;
video.ReturnedColorSpace = 'rgb';

set(video,'LoggingMode','memory');

avi = VideoWriter(nombre,'Uncompressed AVI');
avi.FrameRate = videoFPS;

frames = 0;
disp('....');
disp('ENCENDIENDO c�mara para grabaci�n de video');
open(avi)
start(video)
while video.FramesAcquired < framesTotales
    I = getdata(video,1);
    writeVideo(avi,I);
    imshow(I),title(['Duraci�n: ' num2str(frames/videoFPS)])
    frames = frames+1;
end
stop(video)
close(avi)
close all;
disp('APAGANDO c�mara');
    
% =========================================================================
% 1.2 Im�genes de calibraci�n
% =========================================================================
%% LECTURA DE LAS IM�GENES DEL V�DEO

video = VideoReader(nombre);
get(video);

% Segundo a partir del cual comenzaremos a capturar im�genes
inicio = 5;

% N�mero de im�genes que vamos a capturar
numIma = 18;

%Tama�o del salto del vector para que capruremos el n�mero de im�genes
% que hemos indicado
salto = floor((framesTotales-(videoFPS*inicio)) / numIma);

% Matriz donde almacenaremos todas las im�genes
imagenes = []; 
imagenes = uint8(imagenes);

close all

disp('....');
disp('CARGANDO im�genes capturadas');
%disp('pulse cualquier tecla para avanzar...');
frame = (videoFPS*inicio);
for i=1:(numIma-1)
    I = read(video,frame);
    imagenes(:,:,:,i) = I;
    imshow(imagenes(:,:,:,i)), title(['Imagen : ' num2str(i)])
    pause
    frame = frame+salto;
end

% A�adimos la imagen correspondiente al pen�ltimo frame, que es donde
% el objeto ser� de menor tama�o (seg�n como hemos grabado los v�deos)
I = read(video,framesTotales-1);
imagenes(:,:,:,numIma) = I;
imshow(imagenes(:,:,:,numIma)), title(['Imagen : ' num2str(numIma)])

%close all;
disp('TERMINADO de cargar im�genes');
    
%% GUARDADO DE LAS IM�GENES EN PAQUETE .MAT
    
disp('....');
disp('GUARDANDO archivo .mat');
save('ImagenesEntrenamiento_Calibracion.mat','imagenes');
disp('ARCHIVO GUARDADO');

