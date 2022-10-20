

           
i_file = "input_message.txt"
o_file = "data_mem_init.dat"


# Environment
lines = []
output = []

# Read
with open(i_file) as file:
  lines = file.readlines()[0]
  file.close()
  
# Process
lines = lines.split(' ')
for i in range(0, 20, 2):
  MSB = int(lines[i])
  LSB = int(lines[i+1])
  MSB = MSB.to_bytes(1, "big").hex()
  LSB = LSB.to_bytes(1, "big").hex()
  letter = '0'*4+str(MSB)+str(LSB)
  letter = letter.upper()
  output.append(letter)

with open(o_file, "w") as file:
  for i in range(0, len(output)-1):
    file.write(output[i]+'\n')
  file.write(output[len(output)-1])
  file.close()