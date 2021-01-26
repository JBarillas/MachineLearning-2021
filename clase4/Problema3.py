#Imprimir un rumbo dependiendo de su altura
import math

diamond = lambda n: '\n'.join([
    f"{' ' * (abs(math.ceil(n/2) - 1 - i))}{'* ' * (math.ceil(n/2) -(abs(math.ceil(n/2) - 1 - i)))}"
    for i in range(n)
])

#Imprimir figuras con las alturas 7,9,11
print(diamond(7)+"\n")
print(diamond(9)+"\n")
print(diamond(11)+"\n")