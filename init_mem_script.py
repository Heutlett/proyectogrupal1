file = open("ARM_UNICICLO/data_mem_init.dat", "w") 

texto = input("Ingrese el texto: ")

for char in texto:
    hex = "".join(["{:02x}".format(ord(c)) for c in char])
    hex = "000000"+ str(hex) + "\n"
    file.writelines(hex)
file.write( "00000000")

file.close()

print(f"El texto tiene una longitud de: {len(texto)}")
