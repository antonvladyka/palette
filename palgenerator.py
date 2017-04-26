# -*- coding: utf-8 -*-
"""
Created on Sat Apr 15 11:11:07 2017

@author: Anton

PAL generator
"""



import struct
import numpy as np

def hex2array(colors):
    tmp = []
    for color in colors:
        tmp.append([int(color[1:3],16),int(color[3:5],16),int(color[5:],16)])
    return tmp

palette_size = 256
cols = ['#67001f','#b2182b','#d6604d','#f4a582','#fddbc7','#f7f7f7','#d1e5f0','#92c5de','#4393c3','#2166ac','#053061']
colors = [[55,49,149],[1,142,248],[73,219,112],[255,255,154],[188,160,112],[143,97,84],[182,154,143],[255,255,255]]
colors = [[0,63,191],[0,127,159],[127,191,127],[255,255,95],[223,127,63],[191,0,31],[159,0,0]]
colors = [[0,127,63],[127,191,127],[255,255,95],[223,127,63],[191,0,31]]
colors = [[255,255,255],[31,127,191],[255,255,31],[255,31,63],[95,31,95]]
colors = hex2array(cols)

pos = np.round(np.linspace(1,palette_size,len(colors)))

data_size = palette_size * 4
file_size = data_size + 24
line1 = b'RIFF' #'\x52\x49\x46\x46'.encode() # == 'RIFF'
line2 = struct.pack('<I',file_size-8)
line3 = b' PAL' #'\x50\x41\x4C\x20'.encode()  # == ' PAL'
line4 = b'data' #'\x64\x61\x74\x61'.encode() # == 'data'
line5 = struct.pack('<I',file_size - 20)
line6 = struct.pack('<BBH',0,3,palette_size)

f = open('mypal.pal','wb+')
f.write(line1)
f.write(line2)
f.write(line3)
f.write(line4)
f.write(line5)
f.write(line6)




data = []
for i in range(palette_size):
    if i+1 in pos:
        j = pos.tolist().index(i+1)
        r = colors[j][0]
        g = colors[j][1]
        b = colors[j][2]
    else:
        t = sum(i+1 > pos)
        x = (i + 1 - pos[t-1])/(pos[t]-pos[t-1])
        r = int((1-x)*colors[t-1][0]+x*colors[t][0])
        g = int((1-x)*colors[t-1][1]+x*colors[t][1])
        b = int((1-x)*colors[t-1][2]+x*colors[t][2])
    data.append((r,g,b))

for j in data:
   line = struct.pack('>BBBB',j[0],j[1],j[2],0)
   f.write(line)
f.close()

from PIL import Image
img = Image.new('RGB', (palette_size,25))
img.putdata(data*25)
#img.save('image.png')
img.show()
