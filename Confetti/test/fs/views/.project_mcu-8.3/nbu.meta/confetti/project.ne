(project mcu-8.3
	(baseline 
		(cspec
			(vobs
				(mcu                      mcu_8.3.0.11.8)
				(adapters                 adapter_7.49.105.8.3)
				(dialingInfo              dialingInfo_7.50)
				(mediaCtrlInfo            mediaCtrlInfo_7.42.11)
				
				(web                      WebMcu_8.3_26_040314.7582)
				
				(nbu.media                mp_8.2.0.13.1)
				(mvp                      mp_8.3.0.11.3)
				(map                      mp_8.3.0.11.0)
				(mf                       mp_8.3.0.11.0)
				(mpc                      mp_8.3.0.11.0)
				(mpInfra                  mp_8.3.0.11.0)
				(swAudioCodecs            mp_8.3.0.5.1)
				(NBU_FEC                  mp_8.3.0.10.0)
				(NBU_RTP_RTCP_STACK       mp_8.3.0.8.5)
				(NBU_ICE                  mp_8.3.0.7.0)
				
				(dspNetraVideo            Avatar_integ_2014Mar03__8.3.0.11.0)
				(dspIntelInfra            Avatar_integ_2014Mar03__8.3.0.11.0)
				(dspNetraInfra            Avatar_integ_2014Mar03__8.3.0.11.0)
				(dspInfra                 Avatar_integ_2014Mar03__8.3.0.11.0)
				(dspIcsVideo              Avatar_integ_2014Mar03__8.3.0.11.0)
				(mpDsp                    Avatar_integ_2014Mar03__8.3.0.11.0)
				(NetraVideoCODEC          Avatar_integ_2014Mar03__8.3.0.11.0)
				(dspNetraAudio            Avatar_integ_2014Mar03__8.3.0.11.0)
				(swVideoCodecs            Avatar_integ_2014Mar03__8.3.0.11.0)
				
				(nbu.infra                nbu.infra_mcu-8.0_3.0)
				(boardInfra               nbu.infra_mcu-8.0_5.61)
				(swInfra                  nbu.infra_mcu-8.0_3.28)
				(rvfc                     nbu.infra_mcu-8.0_3.10)
				(loggerInfra              nbu.infra_mcu-8.0_8.2)
				(configInfra              nbu.infra_mcu-8.0_5.1)
				
				(nbu.contrib              nbu.infra_mcu-8.0_3.13_ezSDK)
				(NBU_COMMON_CORE          nbuCCore_4.4.13)
				(NBU_SIP_STACK            nbuSip_6.0.14)
				(NBU_H323_STACK           nbuH323_7.0.9)
				
				(nbu.tests                nbu.tests_1.7.4_2)
				
				(bspLinuxIntel            140112_AVATAR_HOST_1.0.0.7.6)
				(bspLinuxARM              140112_NETRA_1.0.4)
				
				(freemasonBuild           freemasonBuild_1.4.17))))

	:icheck 0
	:itag 0
	
	(lots
		nbu.prod.mcu
		nbu.mcu
		nbu.web
		nbu.media
		nbu.dsp
		nbu.infra
		nbu.bsp
		nbu.contrib
		nbu.build
		nbu.tests))
