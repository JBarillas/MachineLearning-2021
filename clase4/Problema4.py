'''
El código fue obtenido de stackoverflow https://stackoverflow.com/questions/2068372/fastest-way-to-list-all-primes-below-n 
investigando en la página  https://www.quora.com/How-do-you-write-a-relatively-simple-yet-fast-Python-program-for-generating-prime-numbers
'''

def get_primes(n):
    numbers = set(range(n, 1, -1))
    primes = []
    while numbers:
        p = numbers.pop()
        primes.append(p)
        numbers.difference_update(set(range(p*2, n+1, p)))
    return primes

get_primes(100000)
print(get_primes(100000))