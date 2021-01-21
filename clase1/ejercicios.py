my_list = [1,2,3,4,5]

#for i in my_list:
#    n = i*i
#    print(n)

def square_list(ilist):
    olist = []
    for i in ilist:
        olist.append(i**2)
    return olist
#print(square_list([1,2,3,4,5]))


def option2 (ilist):
    return [el ** 2 for el in ilist]
#print(option2([1,2,3,4,5]))

#First level citizens
option3 = lambda ilist: [el**2 for el in ilist]
#print(option3([1,2,3,4,5,6]))

square = lambda n: n ** 2

#Second order functions
def gen_list_transformer(transformation):
    def transformer(ilist):
        return [transformation(el) for el in ilist]
    return transformer

square_of_list = gen_list_transformer(lambda n: n ** 2)
cubre_of_list = gen_list_transformer(lambda n: n ** 3)

print(square_of_list([1,2,3,4,5]))
print(cubre_of_list([1,2,3,4,5]))