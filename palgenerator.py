# -*- coding: utf-8 -*-
"""
Created on Sat Apr 15 11:11:07 2017

@author: Anton

PAL generator
"""



import struct
import numpy as np




#cols = ['#67001f','#b2182b','#d6604d','#f4a582','#fddbc7','#f7f7f7','#d1e5f0','#92c5de','#4393c3','#2166ac','#053061']
cols = ['#0074F4','#0088F3','#0090D1','#009296','#009053','#148A00','#737E00','#AA6800','#D3471B','#E5215A']
#cols = ['#984ea3','#377eb8','#4daf4a','#ffff33','#ff7f00','#e41a1c']
#colors = [[55,49,149],[1,142,248],[73,219,112],[255,255,154],[188,160,112],[143,97,84],[182,154,143],[255,255,255]]
#colors = [[0,63,191],[0,127,159],[127,191,127],[255,255,95],[223,127,63],[191,0,31],[159,0,0]]
#colors = [[0,127,63],[127,191,127],[255,255,95],[223,127,63],[191,0,31]]
#colors = [[255,255,255],[31,127,191],[255,255,31],[255,31,63],[95,31,95]]
#colors = hex2array(cols)


def hex2array(colors):
    tmp = []
    for color in colors:
        tmp.append([int(color[1:3],16),int(color[3:5],16),int(color[5:],16)])
    return tmp
def palette(colors, pal_size = 256, out_name = 'palette.pal', image = False):
    colors = colors
    if type(colors) == str:
        colors = open(colors,'r').read().split()
    if type(colors[0]) == str:
        colors = hex2array(colors)
    palette_size = int(pal_size)
    pos = np.linspace(1,palette_size,len(colors)).astype(int)
    data_size = palette_size * 4
    file_size = data_size + 24
    line1 = b'RIFF' #'\x52\x49\x46\x46'.encode() # == 'RIFF'
    line2 = struct.pack('<I',file_size-8)
    line3 = b'PAL ' #'\x50\x41\x4C\x20'.encode()  # == 'PAL '
    line4 = b'data' #'\x64\x61\x74\x61'.encode() # == 'data'
    line5 = struct.pack('<I',file_size - 20)
    line6 = struct.pack('<BBH',0,3,palette_size)
    f = open(out_name,'wb+')
    f.write(line1)
    f.write(line2)
    f.write(line3)
    f.write(line4)
    f.write(line5)
    f.write(line6)
    data = []
    for i in range(1,palette_size+1):
        if i in pos:
            j = pos.tolist().index(i)
            r = colors[j][0]
            g = colors[j][1]
            b = colors[j][2]
        else:
            t = sum(i > pos)
            x = (i - pos[t-1])/(pos[t]-pos[t-1])
            r = int((1-x)*colors[t-1][0]+x*colors[t][0])
            g = int((1-x)*colors[t-1][1]+x*colors[t][1])
            b = int((1-x)*colors[t-1][2]+x*colors[t][2])
        data.append((r,g,b))
    for j in data:
       line = struct.pack('>BBBB',j[0],j[1],j[2],0)
       f.write(line)
    f.close()
    if image:
        from PIL import Image
        img = Image.new('RGB', (palette_size,25))
        img.putdata(data*25)
        img.save(out_name + '.bmp')
        img.show()

if __name__ == '__main__':
    import sys
    args = sys.argv[1:]
    print(args)
    palette(*args)