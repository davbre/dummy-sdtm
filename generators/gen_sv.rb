def gen_sv(study,controlled_terms,dm)

  s = study
  ct = controlled_terms
  rng = SimpleRandom.new
  sv_dataset = {}

 
  dm.each do |key,sbj|

    sbj_row_set = []
    # Screening visit
    screening_length = rng.weibull(s.screening_days, s.screening_days).round # same shape and scale seems to give reasonable results
    visitnum = 1
    visit = "SCREENING"
    svstdtc = sbj.actarmcd == "SCRNFAIL" ? hlp_rand_start_date(s.ref_date) : sbj.rfstdtc - screening_length
    svendtc = svstdtc
    visitdy = s.screening_days
    svstdy = (svstdtc - sbj.rfstdtc).to_i if sbj.rfstdtc != nil
    svendy = svstdy

    sbj_screen_row = SdtmSv.new(
      # domain is automatically assigned
      studyid:  s.studyid, usubjid: sbj.usubjid, visitnum: visitnum,
      visit:    visit,     visitdy:  visitdy,    svstdtc:  svstdtc,
      svendtc:  svendtc,   svstdy:   svstdy,     svendy:   svendy,
      # -NOTE- SVUPDES...no unplanned visits added yet
      )

    sbj_row_set << sbj_screen_row

    # all other visits
    prev_svstdtc=0 # just needs to be initialized at this point
    if sbj.actarmcd != "SCRNFAIL"
      sbj_visits = rand(0..1) > s.discontinue_proportion ? s.num_visits : rand(1..s.num_visits)
      sbj_visits.times do |i|
        visitnum=i+2
        visit = i==0 ? "BASELINE" : "VISIT " + "#{i+1}"
        svstdtc = i==0 ? sbj.rfstdtc : prev_svstdtc + rng.weibull(s.visit_duration*1.5, s.visit_duration).round
        svendtc = svstdtc
        svstdy = (svstdtc - sbj.rfstdtc).to_i
        svendy = (svendtc - sbj.rfstdtc).to_i
        prev_svstdtc = svstdtc

        sbj_visit_row = SdtmSv.new(
          # domain is automatically assigned
          studyid:  s.studyid, usubjid: sbj.usubjid, visitnum: visitnum,
          visit:    visit,     visitdy:  visitdy,    svstdtc:  svstdtc,
          svendtc:  svendtc,   svstdy:   svstdy,     svendy:   svendy,
          # -NOTE- SVUPDES...no unplanned visits added yet
          )

        sbj_row_set << sbj_visit_row

      end

      sv_dataset[key] = sbj_row_set # contains all visit rows for a single subject (screening + others)
      dm[key].rfendtc = svendtc # at this point we have the last visit date

    end

  end

  sv_dataset

end
