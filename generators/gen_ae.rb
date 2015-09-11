def gen_ae(study,dm,sv,aeterms) # mean = mean number of AEs

  s = study
  rng = SimpleRandom.new
  ds = Dataset.new("ae")
  aeseq = 0

  dm.rows.each do |usubjid,sbj_dm|

    sbj_ae_rows = []

    earliest_ae_dt = sv.rows[usubjid].first.svstdtc
    latest_ae_dt = sv.rows[usubjid].last.svendtc
    trt_index = s.treatment_codes.index(sbj_dm.actarmcd)
    mean_per_year = trt_index.nil? ? s.default_mean_aes_per_year : s.mean_aes_per_year[trt_index]

    serious_weight = trt_index.nil? ? s.weights["default"]["aeser"] : s.weights["arm"]["aeser"][trt_index]
    severity_weights = trt_index.nil? ? s.weights["default"]["aesev"] : s.weights["arm"]["aesev"][trt_index]

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

      aestdy = (aestdtc - sbj_dm.rfstdtc).to_i if sbj_dm.rfstdtc != nil
      aeendy = (aeendtc - sbj_dm.rfstdtc).to_i if (aeendtc != nil && sbj_dm.rfstdtc != nil)

      aeterm = Faker::Lorem.sentence(2)

      aebodsys = pick_term(aeterms["SOC weights"])
      aedecod = pick_term(aeterms["Terms"][aebodsys])

      aeser = (rand < serious_weight) ? "Y" : "N"
      
      aesev = pick_severity(severity_weights)

      ae_row = SdtmAe.new(
        # domain is automatically assigned
        studyid:  s.studyid, usubjid: usubjid, #, aeseq: exseq,
        aestdtc: aestdtc, aeendtc: aeendtc,
        aestdy: aestdy, aeendy: aeendy,
        aeser: aeser, aesev: aesev,
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

def pick_term(terms_with_weights)
  weights = terms_with_weights.values
  terms = terms_with_weights.keys
  normalised_weights = weights.map { |w| w/weights.sum }
  terms = terms_with_weights.keys
  cumulative_sum = 0
  cumulative_weights = normalised_weights.map{|x| cumulative_sum += x}
  randval = rand
  cumulative_weights.each_index do |i|
    return terms[i] if randval < cumulative_weights[i]
  end
  puts "Something wrong in pick_term method if this is printed!!"
end

def pick_severity(weights)
  normalised_weights = weights.map { |w| w/weights.sum }
  cumulative_sum = 0
  cumulative_weights = normalised_weights.map{|x| cumulative_sum += x}
  sevrand = rand
  if sevrand < cumulative_weights[0]
    aesev = "Mild"
  elsif sevrand < cumulative_weights[1]
    aesev = "Moderate"
  else
    aesev = "Severe"
  end
end