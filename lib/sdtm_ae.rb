class SdtmAe < BaseSdtm

  attr_accessor :studyid, :domain, :usubjid,
    :aeseq, :aegrpid, :aerefid, :aespid, :aeterm, :aemodify,
    :aellt,:aelltcd, :aedecod, :aeptcd, :aehlt, :aehltcd,
    :aehlgt, :aehlgtcd, :aecat, :aescat, :aepresp, :aebodsys,
    :aebdsycd, :aesoc, :aesoccd, :aeloc, :aesev, :aeser,
    :aeacn, :aeacnoth, :aerel, :aerelnst, :aepatt, :aeout,
    :aescan, :aescong, :aesdisab, :aesdth, :aeshosp, :aeslife,
    :aesod, :aesmie, :aecontrt, :aetoxgr, :aestdtc, :aeendtc,
    :aestdy, :aeendy, :aedur, :aeenrf, :aeenrtpt, :aeentpt

  def initialize(studyid: nil, domain: nil, usubjid: nil,
    aeseq: nil, aegrpid: nil, aerefid: nil, aespid: nil, aeterm: nil, aemodify: nil,
    aellt: nil,aelltcd: nil, aedecod: nil, aeptcd: nil, aehlt: nil, aehltcd: nil,
    aehlgt: nil, aehlgtcd: nil, aecat: nil, aescat: nil, aepresp: nil, aebodsys: nil,
    aebdsycd: nil, aesoc: nil, aesoccd: nil, aeloc: nil, aesev: nil, aeser: nil,
    aeacn: nil, aeacnoth: nil, aerel: nil, aerelnst: nil, aepatt: nil, aeout: nil,
    aescan: nil, aescong: nil, aesdisab: nil, aesdth: nil, aeshosp: nil, aeslife: nil,
    aesod: nil, aesmie: nil, aecontrt: nil, aetoxgr: nil, aestdtc: nil, aeendtc: nil,
    aestdy: nil, aeendy: nil, aedur: nil, aeenrf: nil, aeenrtpt: nil, aeentpt: nil)
    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    domain = self.class.to_s[-2..-1].upcase # last two letters of this class name to give the domain value
  end

  # Required variables
  validates_presence_of :studyid, :domain, :usubjid, :aeseq, :aeterm, :aedecod

end