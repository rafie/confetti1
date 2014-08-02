
(lots
	(nbu.prod.mcu
		(vobs
			nbu.prod.mcu)
		(lots
			nbu.mcu
			nbu.web
			nbu.media
			nbu.dsp
			nbu.infra
			nbu.bsp
			nbu.contrib
			nbu.build
			nbu.tests))

	(nbu.mcu
		(vobs
			mcu
			adapters
			dialingInfo
			mediaCtrlInfo))

	(nbu.web
		(vobs
			web))

	(nbu.media
		(lots
			nbu.dsp
			nbu.infra
			nbu.bsp
			nbu.contrib
			nbu.build
			nbu.tests)
		(vobs
			nbu.media
			mvp
			mpc
			map
			mf
			mpInfra
			NBU_FEC
			NBU_RTP_RTCP_STACK
			NBU_ICE
			swAudioCodecs))

	(nbu.dsp
		(vobs
			dspUCGW
			dspIntelInfra
			dspUCGW
			mpDsp))

	(nbu.infra
		(lots
			nbu.contrib
			nbu.build)
		(vobs
			nbu.infra
			boardInfra
			configInfra
			swInfra
			loggerInfra
			rvfc
			securityApp
			securityInfra))

	(nbu.contrib
		(lots
			nbu.build)
		(vobs
			nbu.contrib
			NBU_COMMON_CORE
			NBU_SIP_STACK
			NBU_H323_STACK))
		
	(nbu.build
		(vobs
			freemasonBuild))

	(nbu.bsp
		(vobs
			bspLinuxIntel))

	(nbu.tests
		(vobs
			nbu.test)))
