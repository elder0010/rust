.var screenChars  = $0400 //; the 40x25 buffer
.var screenPixels = $3800 //; the pixel data for font or bitmap ($1000 or $9000 are always charrom)

.var sprites = $2800

.var frame_ct = $e8

.var fade_pt = $97

.var sin_pt = $98

.var cur_y = $99