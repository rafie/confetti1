
(lots
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
		(vobs
			nbu.media
			mvp
			mpc
			map
			mf
			mpInfra
			NBU_FEC
			NBU_RTP_RTCP_STACK
			NBU_ICE))

	(nbu.dsp
		(vobs
			dspIcsVideo
			dspInfra
			dspIntelInfra
			dspNetraInfra
			dspNetraVideo
			dspUCGW
			mpDsp
			NetraVideoCODEC
			swAudioCodecs))

	(nbu.infra
		(vobs
			nbu.infra
			boardInfra
			configInfra
			swInfra
			loggerInfra
			rvfc))

	(nbu.contrib
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
			bspLinuxIntel
			bspLinuxARM))

	(nbu.tests
		(vobs
			nbu.test)))
