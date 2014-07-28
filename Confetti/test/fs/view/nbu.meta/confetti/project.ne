(project mcu-8.0
	(baseline 
		(cspec
			(vobs
				(mcu                      mcu_8.0.0.49.5_SP2)
				(adapters                 adapter_7.49.52_8.0.0.49.5_SP2)
				(dialingInfo              dialingInfo_7.44_SP2_28Feb13)
				(mediaCtrlInfo            mediaCtrlInfo_7.41.9_SP2_28Feb13)
		
				(web                      WebMcu_8.0.0_107_021212.1183)
		
				(mvp                      mp_8.0.0.49.4_sp2)
				(map                      mp_8.0.0.49.3_sp2)
				(mf                       mp_8.0.0.49.3_sp2)
				(mpc                      mp_8.0.0.48.3_sp2)
				(mpInfra                  mp_8.0.0.48.2_sp2)
				(swAudioCodecs            mp_8.0.0.48.0_sp2)
				(NBU_FEC                  mp_8.0.0.48.3_sp2)
				(NBU_RTP_RTCP_STACK       mcu_nbuRtpRtcpStack_8.0.0.40.0_sp2)
				(NBU_ICE                  mcu_nbuIce_8.0.0.33.0_sp2)
		
				(dspNetraVideo            Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
				(dspIntelInfra            Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
				(dspNetraInfra            Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
				(dspInfra                 Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
				(dspIcsVideo              Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
				(mpDsp                    Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
				(NetraVideoCODEC          Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
				(dspNetraAudio            Avatar_integ_2012Dec25___8.0.0.49.1_sp2)
		
				(nbu.infra                nbu.infra_mcu-8.0_3.0)
				(boardInfra               nbu.infra_mcu-8.0_5.20_SP2)
				(swInfra                  nbu.infra_mcu-8.0_3.9_SP2)
				(rvfc                     nbu.infra_mcu-8.0_3.3_SP2)
				(loggerInfra              nbu.infra_mcu-8.0_3.0_SP2_28Feb13)
				(configInfra              nbu.infra_mcu-8.0_3.3_SP2_28Feb13)
		
				(nbu.contrib              nbu.infra_mcu-8.0_3.7_NEW_IPP)
				(NBU_COMMON_CORE          nbuCCore_4.4.11_SP2)
				(NBU_SIP_STACK            nbuSip_6.0.7_SP2_28Feb13)
				(NBU_H323_STACK           nbuH323_7.0.6_SP2_28Feb13)
		
				(nbu.tests                nbu.tests_1.7.0)
		
				(bspLinuxIntel            130218_AVATAR_HOST_1.0.0.6.16_SP2)
				(bspLinuxARM              120702_NETRA_0.1.25)
		
				(freemasonBuild           freemasonBuild_1.4.13_SP2))))

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
