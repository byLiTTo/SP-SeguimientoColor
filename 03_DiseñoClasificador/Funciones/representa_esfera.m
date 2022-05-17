function representa_esfera(centroide, radio)
    [R,G,B] = sphere(100);
    x = radio*R(:) + centroide(1);
    y = radio*G(:) + centroide(2);
    z = radio*B(:) + centroide(3);
    
    plot3(x,y,z, '-y') 
end