def gen_lb(study,controlled_terms,sv,lab_params)

  s = study
  ct = controlled_terms
  rng = SimpleRandom.new
  lb_dataset = {}
  lbseq = 0
 
  sv.each do |key,sbj_visits|


    sbj_lb_rows = []

    sbj_visits.each do |vis|

      lbseq += 1

      lab_params.each do |param,details|

        lbtestcd = param
        lbtest = details["LBTEST"]
        lbstnrlo = details["LBSTNRLO"]
        lbstnrhi = details["LBSTNRHI"]
        lbstresn = rng.normal((lbstnrhi+lbstnrlo)/2, (lbstnrhi-lbstnrlo)/4).round(details["PRECISION"]) # ~95% will fall within range

        sbj_vis_param_row = SdtmLb.new(
          # domain is automatically assigned
          studyid:  s.studyid, usubjid: key, lbseq: lbseq,
          lbtestcd: lbtestcd,  lbtest:  lbtest,         visitnum: vis.visitnum,
          visit: vis.visit, visitdy: vis.visitdy, lbstresn: lbstresn,
          lbstnrlo: lbstnrlo,  lbstnrhi: lbstnrhi
          )
        
        sbj_vis_param_row.set_lbnrind

        sbj_lb_rows << sbj_vis_param_row

      end
    end

    lb_dataset[key] = sbj_lb_rows
    # :studyid, :domain, :usubjid, :lbseq, :lbgrpid, :lbrefid,
    # :lbspid, :lbtestcd, :lbtest, :lbcat, :lbscat, :lborres, :lborresu,
    # :lbornrlo, :lbornrhi, :lbstresc, :lbstresc, :lbstresn, :lbstresu,
    # :lbstnrlo, :lbstnrhi, :lbstnrc, :lbnrind, :lbstat, :lbreasnd, :lbnam,
    # :lbloinc, :lbspec, :lbspccnd, :lbmethod, :lbblfl, :lbfast, :lbdrvfl,
    # :lbtox, :lbtoxgr, :visitnum, :visit, :visitdy, :lbdtc, :lbendtc, :lbdy,
    # :lbtpt, :lbtptnum, :lbeltm, :lbtptref, :lbrftdtc    
  end

  lb_dataset

end