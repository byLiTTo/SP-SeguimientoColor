function Matriz_Binaria_Filtrada = filtra_objetos(Matriz_Binaria, NumPix)
    Matriz_Binaria_Filtrada = logical(zeros(size(Matriz_Binaria)));
    
    [Matriz_Etiquetada N] = funcion_etiquetar(Matriz_Binaria);
    
    Areas = calcula_areas(Matriz_Etiquetada);
    %[AreasOrd Ind] = sort(Areas,'descend');
    
    for i=1:N
       if(Areas(i) >= NumPix)
           Matriz_Binaria_Filtrada(Matriz_Etiquetada == i)=1;
       end
    end
end

function Areas = calcula_areas(Matriz_Etiquetada)
    NumObjetos = max(Matriz_Etiquetada(:));
    Areas = zeros(NumObjetos,1);
    
    [nFilas,nColumnas] = size(Matriz_Etiquetada);
    for x=1:nFilas
        for y=1:nColumnas
            pos = Matriz_Etiquetada(x,y);
         
            if pos > 0
                Areas(pos) = Areas(pos)+1;
            end 
        end 
    end 
end

function [Matriz_Etiquetada N] = funcion_etiquetar(Matriz_Binaria)
    [nFila, nColumna] = size(Matriz_Binaria);

    N = 0;
    Matriz_Etiquetada = zeros(nFila,nColumna);
    
    for i=1:nFila
        for j=1:nColumna
            if Matriz_Binaria(i,j) == 1
                N = N+1;
                [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,i,j,N);
            end
        end
    end
end

function [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila,columna,N)
    %Pixel Central
    if Matriz_Binaria(fila,columna) == 1
        Matriz_Binaria(fila,columna) = 0;
        Matriz_Etiquetada(fila,columna) = N;
        
        %Vecino de Arriba
        if fila > 1
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila-1,columna,N);
        end
        
        %Vecino de Abajo
        if fila < size(Matriz_Binaria,1)
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila+1,columna,N);
        end
        
        %Vecino de Izquierda
        if columna > 1
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila,columna-1,N);
        end
        
        %Vecino de Derecha
        if columna < size(Matriz_Binaria,2)
            [Matriz_Binaria,Matriz_Etiquetada] = vecinos(Matriz_Binaria,Matriz_Etiquetada,fila,columna+1,N);
        end
    end
end