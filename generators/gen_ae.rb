def gen_ae(study,dm,sv,mean_per_year) # mean = mean number of AEs

  s = study
  rng = SimpleRandom.new
  ds = Dataset.new("ae")
  aeseq = 0

  dm.rows.each do |usubjid,sbj_dm|

    sbj_ae_rows = []

    earliest_ae_dt = sv.rows[usubjid].first.svstdtc
    latest_ae_dt = sv.rows[usubjid].last.svendtc
    mean_per_sbj_period = (latest_ae_dt-earliest_ae_dt)/365.25*mean_per_year
    chi_square_mean = [mean_per_sbj_period,1].max
    number_of_aes = rng.chi_square(chi_square_mean).floor

    number_of_aes.times do
      aestdtc = rand(earliest_ae_dt..latest_ae_dt)
      if rand(0..1)>0.1
        aeendtc = rand(aestdtc..latest_ae_dt)
      else
        aeenrf = "ONGOING"
        aeendtc = nil
      end
      aeterm = Faker::Lorem.sentence(2)
      aebodsys = "Body System " + rand(1..10).to_s
      aedecod = "AE Decode " + rand(1..10).to_s

      ae_row = SdtmAe.new(
        # domain is automatically assigned
        studyid:  s.studyid, usubjid: usubjid, #, aeseq: exseq,
        aestdtc: aestdtc, aeendtc: aeendtc,
        aeterm: aeterm, aebodsys: aebodsys, aedecod: aedecod
      )
      sbj_ae_rows << ae_row
    end

    sbj_ae_rows.sort_by { |obj| obj.aestdtc }
    sbj_ae_rows.each do |ae|
      aeseq += 1
      ae.aeseq = aeseq
    end

    ds.add(usubjid, sbj_ae_rows)
    #ae_dataset[key] = sbj_ae_rows

  end

  ds
end