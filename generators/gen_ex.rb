def gen_ex(study,dm,sv)

  s = study
  rng = SimpleRandom.new
  ds = Dataset.new("ex") #{name: "ex", meta: {}}
  exseq = 0
 
  sv.rows.each do |usubjid,sbj_visits|

    sbj_ex_rows = []

    sbj_visits.each do |vis|

      next if vis.visitnum < 2
      exseq += 1
      exstdtc = vis.svstdtc
      exdose = study.treatment_doses[study.treatment_codes.find_index(dm.rows[usubjid].armcd)]
      ex_row = SdtmEx.new(
        # domain is automatically assigned
        studyid:  s.studyid, usubjid: usubjid, exseq: exseq,
        exstdtc: exstdtc, exdose: exdose
      )

      sbj_ex_rows << ex_row

    end

    ds.add(usubjid, sbj_ex_rows)
  end

  ds

end