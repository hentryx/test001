# Prueba iOS json de rutas y marca de mapas

Este documento ayuda a realizar la reconstruccion del proyeto iOS para pueba
--------------
ha sido desarrollado para iPhone X para iOS 11.2 en Xcode 9,3,1 bajo lenguaje Swift 4.1

* Nota: para el simulador el device debe estar enrolled luego al momento de ejecutar la aplicacion antes de presionar el boton ingresar debe estar marcada 
la opcion enrolled en Simulator -> Hardware -> FaceID -> enrolled. 

* despues de esto, al presionar el boton ingresar, 

* solicitara el FaceID, y alli se debe ir a la opcion Simulator->Hardware -> FaceID ->Matching Face si se desea evento de acceso
 o non matching faceID si se quiere simular un reconocimiento facial fallido.
 
 alli se presentara la imagen correspondiente a cada una de las rutas descritas en la solicitud de la prueba. 
 
 al seleccionar uno de los botones alli dinamicamente creados se visualizará el mapa con los puntos que se han recuperado segun cada web service expuesto relacionado con cada url de prueba
 
 EOF Cordial Saludo Henry Bautista
