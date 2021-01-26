#Imprima un triángulo invertido dependiendo de su altura

upside_triangle = lambda n: '\n'.join([
    f"{' ' * (n - i - 1)}{'*' * (2 * i + 1)}"
    for i in range(n - 1, -1, -1)
])

#Imprimir las figuras con alturas 4, 5 y 6
print(upside_triangle(4)+'\n')
print(upside_triangle(5)+'\n')
print(upside_triangle(6)+'\n')
