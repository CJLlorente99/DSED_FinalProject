# Proyecto final DSED

## Intro

Este proyecto ha sido creado por Imanol Torres Inchaurza (ITI) y Carlos Llorente Cortijo (CJLL) en el marco de la asignatura DSED perteneciente al cuarto curso de GITST de la UPM.

La funcionalidad de este proyecto es la de crear un sistema de grabación, tratamiento y reproducción de audio en una FPGA Artix-7 en la placa Nexys 4 DDR.

## ¿Cómo usar?

El sistema se maneja a través de los siguientes controles
- SW 12 -> reset
- SW 13 -> clear RAM
- SW 14 -> grabación de audio
- SW 15 -> reproducción según la posición indicada en SW 0 y SW 1
	
| SW0   | SW1   | reproduccion              |
| :---: | :---: | :-----------------------: | 
| 0     | 0     | normal                    |
| 1     | 0     | al revés                  |
| 0     | 1     | tras filtrado paso bajo   |
| 1     | 1     | tras filtrado paso alto   |

- BTNU -> subir volumen
- BTND -> bajar volumen
- BTNR -> aumentar reverberación
- BTNL -> disminuir reverberación

## Algunos apuntes acerca de la funcionalidad

La reproducción se produce una sola vez. Una vez se ha reproducido todo lo disponible en la memoria se para la reproducción. Para volver a usar el mismo modo de reproducción, cambiar a otro y volver.

Se reproducirá un pitido cuando queden 3 segundos de memoria disponible para grabar. Se reproducirá un pitido constante si se ha agotado la memoria disponible para grabar.

