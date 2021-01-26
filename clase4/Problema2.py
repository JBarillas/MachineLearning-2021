#Calcular la función utilizando recurrencia, n y m son naturales (incluye 0)

def equation(n,m):
    if m == n:
        return 1
    if m == 0:
        return 1
    if (n >= m) and (m > 0):
        return equation(n-1,m) + equation(n-1, m-1)
#Calcule (50,35) y (100,85)
print(equation(50,35))
