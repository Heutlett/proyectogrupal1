import numpy as np
from PIL import Image
img = np.asarray(Image.open("test.png"))

for i in range(10):

    print(img[0][i]," ", end="")