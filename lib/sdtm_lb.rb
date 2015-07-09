class SdtmLb < BaseSdtm
  include ActiveModel::Validations

  attr_accessor :studyid, :domain, :usubjid, :lbseq, :lbgrpid, :lbrefid,
    :lbspid, :lbtestcd, :lbtest, :lbcat, :lbscat, :lborres, :lborresu,
    :lbornrlo, :lbornrhi, :lbstresc, :lbstresn, :lbstresu,
    :lbstnrlo, :lbstnrhi, :lbstnrc, :lbnrind, :lbstat, :lbreasnd, :lbnam,
    :lbloinc, :lbspec, :lbspccnd, :lbmethod, :lbblfl, :lbfast, :lbdrvfl,
    :lbtox, :lbtoxgr, :visitnum, :visit, :visitdy, :lbdtc, :lbendtc, :lbdy,
    :lbtpt, :lbtptnum, :lbeltm, :lbtptref, :lbrftdtc

  def initialize(studyid: nil, domain: nil, usubjid: nil, lbseq: nil,
    lbgrpid: nil, lbrefid: nil, lbspid: nil, lbtestcd: nil, lbtest: nil,
    lbcat: nil, lbscat: nil, lborres: nil, lborresu: nil, lbornrlo: nil,
    lbornrhi: nil, lbstresc: nil, lbstresn: nil, lbstresu: nil,
    lbstnrlo: nil, lbstnrhi: nil, lbstnrc: nil, lbnrind: nil, lbstat: nil,
    lbreasnd: nil, lbnam: nil, lbloinc: nil, lbspec: nil, lbspccnd: nil,
    lbmethod: nil, lbblfl: nil, lbfast: nil, lbdrvfl: nil, lbtox: nil,
    lbtoxgr: nil, visitnum: nil, visit: nil, visitdy: nil, lbdtc: nil,
    lbendtc: nil, lbdy: nil, lbtpt: nil, lbtptnum: nil, lbeltm: nil,
    lbtptref: nil, lbrftdtc: nil)
    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    domain = self.class.to_s[-2..-1].upcase # last two letters of this class name to give the domain value
  end

  # Required variables
  validates_presence_of :studyid, :domain, :usubjid, :lbseq, :lbtestcd, :lbtest
  
  def set_lbnrind
    if (@lbstnrlo <= @lbstresn && @lbstresn <= @lbstnrhi)
      @lbnrind = "NORMAL"
    elsif @lbstresn < @lbstnrlo
      @lbnrind = "LOW"
    elsif @lbstresn > @lbstnrhi
      @lbnrind = "HIGH"
    end
  end
end