def gen_ex(study,controlled_terms,dm,sv)

  s = study
  ct = controlled_terms
  rng = SimpleRandom.new
  ex_dataset = {}
  exseq = 0
 
  sv.each do |key,sbj_visits|

    sbj_ex_rows = []

    sbj_visits.each do |vis|

      next if vis.visitnum < 2
      exseq += 1
      exstdtc = vis.svstdtc
      exdose = study.treatment_doses[study.treatment_codes.find_index(dm[key].armcd)]
      ex_row = SdtmEx.new(
        # domain is automatically assigned
        studyid:  s.studyid, usubjid: key, exseq: exseq,
        exstdtc: exstdtc, exdose: exdose
      )

      sbj_ex_rows << ex_row
    end

    ex_dataset[key] = sbj_ex_rows
  end

  ex_dataset

end