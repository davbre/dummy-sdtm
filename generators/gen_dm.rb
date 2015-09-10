def gen_dm(study,controlled_terms)

  s = study
  ct = controlled_terms
  ds = Dataset.new("dm")

  s.total_subjects.times do |i|
    country_num = rand(1..s.sites.length)
    site_num = rand(1..s.sites[country_num-1].length-1)
    siteid = country_num.to_s + \
             site_num.to_s.rjust(s.max_sites.to_s.size+1,"0")
    subjnum = (s.investigators[country_num-1][site_num-1][1] += 1)
    subjid = subjnum.to_s.rjust((s.treatment_ratios.max*s.total_subjects/s.total_sites).floor.to_s.size+1,"0")

    invnam = s.investigators[country_num-1][site_num-1][0]
    # increment running count of subjects assinged to investigator
    # country = s.sites[country_num-1]
    usubjid = s.studyid + "-" + siteid + "-" + subjid
    country = s.sites[country_num-1][0]
    sex = ct["sex"][rand(0..1)]

    arm_array_index = rand*s.treatments.length.floor
    armcd = s.treatment_codes[arm_array_index]
    arm = s.treatments[arm_array_index]

    race = ct["race"][rand(0..ct.length-1)]
    age = rand(s.age_range[0]..s.age_range[1])
    ageu = "years"

    
    # certain percentage screen failures
    if rand < s.screen_fail_weight then
      actarmcd = "SCRNFAIL"
      actarm = "Screen Failure"
    else
      actarmcd = armcd
      actarm = arm
    end

    unless actarmcd == "SCRNFAIL"
      rfstdtc = hlp_rand_start_date(s.ref_date)
      rfendtc = "--placeholder--"
    end


    dm_row = SdtmDm.new(
                    studyid:  s.studyid,
                    # domain is automatically assigned
                    siteid:   siteid,
                    subjid:   subjid,
                    usubjid:  usubjid,
                    invnam:   invnam,
                    sex:      sex,
                    country:  country,
                    armcd:    armcd,
                    arm:      arm,
                    actarmcd: actarmcd,
                    actarm:   actarm,
                    rfstdtc:  rfstdtc,
                    rfendtc:  rfendtc,
                    age:      age,
                    ageu:     ageu
                   )


    begin
      raise "DM observation is not valid" unless dm_row.valid?
      ds.add(usubjid,dm_row)
    rescue Exception => e
      puts e.message
      puts dm_row.errors.full_messages
    end
  end
  #dm_dataset = dm_dataset.sort.to_h # sort dm dataset now so other data sets will automatically be sorted
  ds.sort
  ds
end