
# def gen_lb(study,controlled_terms,dm)

#   s = study
#   ct = controlled_terms

#   lb_dataset = []

#   s.total_subjects.times do |i|

#     num_visits = r
#     country_num = rand(1..s.sites.length)
#     site_num = rand(1..s.sites[country_num-1].length)

#     siteid = country_num.to_s + \
#              site_num.to_s.rjust(s.max_sites.to_s.size+1,"0")

#     invnam = s.investigators[country_num-1][site_num-1][0]
#     # increment running count of subjects assinged to investigator
#     subjnum = (s.investigators[country_num-1][site_num-1][1] += 1)
#     country = s.sites[country_num-1]

#     usubjid = s.studyid + "-" + siteid + "-" \
#               + subjnum.to_s.rjust((s.treatment_ratios.max*s.total_subjects/s.total_sites).floor.to_s.size+1,"0")
#     country = s.sites[site_num-1][0]
#     sex = ct["sex"][rand(0..1)]

#     arm_array_index = rand*s.treatments.length.floor
#     armcd = s.treatment_codes[arm_array_index]
#     arm = s.treatments[arm_array_index]

#     race = ct["race"][rand(0..ct.length-1)]

#     # certain percentage screen failures
#     if rand < 0.5 then
#       actarmcd = "SCRNFAIL"
#       actarm = "Screen Failure"
#     else
#       actarmcd = armcd
#       actarm = arm
#     end

#     unless actarmcd == "SCRNFAIL"
#       rfstdtc = hlp_rand_time(s.ref_date, s.ref_date + rand(0..365).days)
#       rfendtc = "--placeholder--"

#       age = rand(s.age_range[0]..s.age_range[1])
#       ageu = "years"
#     end

#     dm_row = SdtmDm.new(
#                     studyid:  s.studyid,
#                     usubjid:  usubjid,
#                     siteid:   siteid,
#                     invnam:   invnam,
#                     sex:      sex,
#                     country:  country,
#                     armcd:    armcd,
#                     arm:      arm,
#                     actarmcd: actarmcd,
#                     actarm:   actarm,
#                     rfstdtc:  rfstdtc,
#                     rfendtc:  rfendtc,
#                     age:      age,
#                     ageu:     ageu
#                    )


#     begin
#       raise "DM observation is not valid" unless dm_row.valid?
#       dm_dataset << dm_row
#     rescue Exception => e
#       puts e.message
#     end
#   end

#   dm_dataset
# end