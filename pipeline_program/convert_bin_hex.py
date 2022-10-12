
f = open("new isa program bin.txt")
f2 = open("new isa program hex.txt", "w")

for i in range(51):

    num = f.readline()
    num = num[0:32]

    decimal_representation = int(num, 2)
    hexadecimal_string = hex(decimal_representation)

    print(i, ":\t", num, " = ", hexadecimal_string)

    f2.write(hexadecimal_string + "\n")