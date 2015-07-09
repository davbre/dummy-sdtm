class SdtmEx < BaseSdtm
  include ActiveModel::Validations

  attr_accessor :studyid, :domain, :usubjid,
    :exseq, :exgrpid, :exrefid, :exspid, :exlnkid, :exlnkgrp,
    :extrt, :excat, :exscat, :exdose, :exdostxt,
    :exdosu, :exdosfrm, :exdosfrq, :exdosrgm, :exroute, :exlot,
    :exloc, :exlat, :exdir, :exfast, :exadj, :epoch, :exstdtc,
    :exendtc, :exstdy, :exendy, :exdur, :extpt, :extptnum,
    :exeltm, :extptref, :exrftdtc

  def initialize(studyid: nil, domain: nil, usubjid: nil,
    exseq: nil, exgrpid: nil, exrefid: nil, exspid: nil, exlnkid: nil, exlnkgrp: nil,
    extrt: nil, excat: nil, exscat: nil, exdose: nil, exdostxt: nil,
    exdosu: nil, exdosfrm: nil, exdosfrq: nil, exdosrgm: nil, exroute: nil, exlot: nil,
    exloc: nil, exlat: nil, exdir: nil, exfast: nil, exadj: nil, epoch: nil, exstdtc: nil,
    exendtc: nil, exstdy: nil, exendy: nil, exdur: nil, extpt: nil, extptnum: nil,
    exeltm: nil, extptref: nil, exrftdtc: nil)
    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    domain = self.class.to_s[-2..-1].upcase # last two letters of this class name to give the domain value
  end

  # Required variables
  validates_presence_of :studyid, :domain, :usubjid, :exseq, :extrt
  
end