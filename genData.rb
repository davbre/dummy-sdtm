require 'rubygems'
require 'bundler/setup'
require 'faker'
require 'pry'
require 'active_model'
require 'active_support/core_ext' # for some time functions and more
require 'time'
require 'yaml'
require 'pp'
require 'simple-random'

require_relative 'lib/init.rb'
require_relative 'generators/init.rb'

study = YAML.load(File.read('config/dummy_study.yml'))
study.assign_random_investigator_names

srand 1234                         # set a seed to give reproducability of 'randomly' assigned variables
# ref_date = DateTime.new(2014,3,1)  # reference date/study start
controlled_terms = YAML::load_file "config/controlled_terms.yml"
lab_parameters = YAML::load_file "config/lab_parameters.yml"

dm = gen_dm(study,controlled_terms)
sv = gen_sv(study,controlled_terms,dm)

def gen_lb(study,controlled_terms,sv,lab_params)

  s = study
  ct = controlled_terms
  rng = SimpleRandom.new
  lb_dataset = []
  lbseq = 0
 
  sv.each do |sbjvis|

    lbseq += 1

    lab_params.each do |param,details|

      lbtestcd = param
      lbtest = details["LBTEST"]
      lbstnrlo = details["LBSTNRLO"]
      lbstnrhi = details["LBSTNRHI"]
      lbstresn = rng.normal((lbstnrhi+lbstnrlo)/2, (lbstnrhi-lbstnrlo)/4).round(details["PRECISION"]) # ~95% will fall within range

      sbj_vis_param_row = SdtmLb.new(
        # domain is automatically assigned
        studyid:  s.studyid, usubjid: sbjvis.usubjid, lbseq: lbseq,
        lbtestcd: lbtestcd,  lbtest:  lbtest,         visitnum: sbjvis.visitnum,
        visit: sbjvis.visit, visitdy: sbjvis.visitdy, lbstresn: lbstresn,
        lbstnrlo: lbstnrlo,  lbstnrhi: lbstnrhi
        )
      
      sbj_vis_param_row.set_lbnrind

      lb_dataset << sbj_vis_param_row

    end


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

lb = gen_lb(study,controlled_terms,sv,lab_parameters)

File.open("output/#{study.studyid}_dm.yml", 'w') {|f| f.write(YAML.dump(dm)) }
File.open("output/#{study.studyid}_sv.yml", 'w') {|f| f.write(YAML.dump(sv)) }
File.open("output/#{study.studyid}_lb.yml", 'w') {|f| f.write(YAML.dump(lb)) }

# usbjids
# binding.pry

