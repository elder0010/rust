.pc=$7800 "Image file/Multiply table "
imagefile:
.var colorMap = List()
.eval colorMap.add($000000)
.eval colorMap.add($ffffff)
.eval colorMap.add($894036)
.eval colorMap.add($7abfc7)
.eval colorMap.add($8a46ae)
.eval colorMap.add($69a941)
.eval colorMap.add($3e31a2)
.eval colorMap.add($d0dc71)
.eval colorMap.add($905f25)
.eval colorMap.add($5c4700)
.eval colorMap.add($bb776d)
.eval colorMap.add($555555)
.eval colorMap.add($808080)
.eval colorMap.add($acea88)
.eval colorMap.add($7c70da)
.eval colorMap.add($ababab)  
.var image = LoadPicture("images\butterflyck.png")
 .for (var y=0; y < 64 ;  y++) {
    .for (var x=0; x < 64 ; x=x+2) {
        .var color = image.getPixel(x,y)	
		.var min=3*$ff
		.var col1=0
		.for(var i=0;i<16;i++)
		{
			.var r=<floor(colorMap.get(i)/65536)
			.var g=<floor(colorMap.get(i)/256)
			.var b=<colorMap.get(i)
			.var rt=<floor(color/65536)
			.var gt=<floor(color/256)
			.var bt=<color
			.var newm=abs(r-rt)+abs(g-gt)+abs(b-bt)
			.if (min>newm) {
				.eval min=newm
				.eval col1=i
			}
		}
        .eval color = image.getPixel(x+1,y)	
		.eval min=3*$ff
		.var col2=0
		.for(var i=0;i<16;i++)
		{
			.var r=<floor(colorMap.get(i)/65536)
			.var g=<floor(colorMap.get(i)/256)
			.var b=<colorMap.get(i)
			.var rt=<floor(color/65536)
			.var gt=<floor(color/256)
			.var bt=<color
			.var newm=abs(r-rt)+abs(g-gt)+abs(b-bt)
			.if (min>newm) {
				.eval min=newm
				.eval col2=i
			}
		}		
		.byte col1*16+col2
   }
}
