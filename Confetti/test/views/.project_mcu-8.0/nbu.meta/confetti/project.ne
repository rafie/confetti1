(project mcu-8.0
	(baseline ...)

	:icheck 0
	:itag 0
	
	(lots
		nbu.prod.mcu
		nbu.mcu
		nbu.web
		nbu.media
		nbu.dsp
		nbu.tbu-stacks
		nbu.infra
		nbu.tools
		nbu.bsp
		nbu.tests)
	
	(products
		(product mcu :lot nbu.prod.mcu))
)