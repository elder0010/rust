spriteData:

	:LoadSprite("frames_tentacoli/01/png/01.png")
	:LoadSprite("frames_tentacoli/02/png/01.png")
	:LoadSprite("frames_tentacoli/03/png/01.png")
	:LoadSprite("frames_tentacoli/04/png/01.png")
	:LoadSprite("frames_tentacoli/05/png/01.png")
	:LoadSprite("frames_tentacoli/06/png/01.png")
	:LoadSprite("frames_tentacoli/07/png/01.png")
	:LoadSprite("frames_tentacoli/08/png/01.png")

	:LoadSprite("frames_tentacoli/01/png/02.png")
	:LoadSprite("frames_tentacoli/02/png/02.png")
	:LoadSprite("frames_tentacoli/03/png/02.png")
	:LoadSprite("frames_tentacoli/04/png/02.png")
	:LoadSprite("frames_tentacoli/05/png/02.png")
	:LoadSprite("frames_tentacoli/06/png/02.png")
	:LoadSprite("frames_tentacoli/07/png/02.png")
	:LoadSprite("frames_tentacoli/08/png/02.png")

	:LoadSprite("frames_tentacoli/01/png/03.png")
	:LoadSprite("frames_tentacoli/02/png/03.png")
	:LoadSprite("frames_tentacoli/03/png/03.png")
	:LoadSprite("frames_tentacoli/04/png/03.png")
	:LoadSprite("frames_tentacoli/05/png/03.png")
	:LoadSprite("frames_tentacoli/06/png/03.png")
	:LoadSprite("frames_tentacoli/07/png/03.png")
	:LoadSprite("frames_tentacoli/08/png/03.png")

	:LoadSprite("frames_tentacoli/01/png/04.png")
	:LoadSprite("frames_tentacoli/02/png/04.png")
	:LoadSprite("frames_tentacoli/03/png/04.png")
	:LoadSprite("frames_tentacoli/04/png/04.png")
	:LoadSprite("frames_tentacoli/05/png/04.png")
	:LoadSprite("frames_tentacoli/06/png/04.png")
	:LoadSprite("frames_tentacoli/07/png/04.png")
	:LoadSprite("frames_tentacoli/08/png/04.png")

	:LoadSprite("frames_tentacoli/01/png/05.png")
	:LoadSprite("frames_tentacoli/02/png/05.png")
	:LoadSprite("frames_tentacoli/03/png/05.png")
	:LoadSprite("frames_tentacoli/04/png/05.png")
	:LoadSprite("frames_tentacoli/05/png/05.png")
	:LoadSprite("frames_tentacoli/06/png/05.png")
	:LoadSprite("frames_tentacoli/07/png/05.png")
	:LoadSprite("frames_tentacoli/08/png/05.png")


	:LoadSprite("frames_tentacoli/01/png/06.png")
	:LoadSprite("frames_tentacoli/02/png/06.png")
	:LoadSprite("frames_tentacoli/03/png/06.png")
	:LoadSprite("frames_tentacoli/04/png/06.png")
	:LoadSprite("frames_tentacoli/05/png/06.png")
	:LoadSprite("frames_tentacoli/06/png/06.png")
	:LoadSprite("frames_tentacoli/07/png/06.png")
	:LoadSprite("frames_tentacoli/08/png/06.png")




// etc

.macro LoadSprite(filename) {
	.var picture = LoadPicture(filename, List().add($000000, $31297b,$73a5b5,$6b3a84))
	.for (var y=0; y<21; y++)
		.for (var x=0; x<3; x++)
			.byte picture.getMulticolorByte(x,y) 
	.byte 0
}