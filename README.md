# Microsoft Palette

Palette file (\*.pal) is a binary file consisiting of the list of colors in hexadecimal format. Such files are used by various software, e.g. Originlab. 

Recent versions of Origin have nice set of palettes but sometimes own-designed one is desired/preferred.

PAL file consists of the header (24 bytes) and the list of colors, 4 bytes per color (RGBA). The header includes:
- ASCII text '**RIFF**'
- INT number *file_size-8* (4 bytes, little-endian)
- ASCII text '**PAL data**'
- INT number *file_size-20* (4 bytes, little-endian)
- BYTES 0, 3
- SHORT INT palette_size (2 bytes, little-endian)
, where *palette_size* is the number of colors, and *file_size* = *palette_size*\*4

## Example
Rainbow.pal, one of the default palette from OriginLab

1052 bytes = Header (24 bytes) + 256 Colors (256x4=1024 bytes) + 4 bytes (Trash?)

First 8\*4=32 bytes: 

```
f = open('rainbow.pal', 'rb')
for i in range(8):
    l = f.read(4)
    print(l)
f.close()
```

Output:
- `b'RIFF'`
- `b'\x14\x04\x00\x00'` = 0x00000414 = 1044
- `b'PAL '`
- `b'data'`
- `b'\x08\x04\x00\x00'` = 0x00000408 = 1032
- `b'\x00\x03\x00\x01'` = 0, 3, 0x0100 = 256 colors
- `b'l\x00l\x00'` First color, RGBA: b'l' = 0x6c = 108, b'\x00' = 0, b'l' = 0x6c = 108, b'\x00' = 0 
- `b'p\x00v\x00'` Second color, RGBA: b'p' = 0x70 = 112, b'\x00' = 0, b'v' = 0x76 = 118, b'\x00' = 0 

R-code generates files with HEX codes, which requires conversion Hex-> Ascii (by notepad++)

Python generates ready binary file
