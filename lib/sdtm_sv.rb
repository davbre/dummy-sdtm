class SdtmSv < BaseSdtm
  include ActiveModel::Validations

  attr_accessor :studyid, :domain, :usubjid, :visitnum, :visit, :visitdy,
                :svstdtc, :svendtc, :svstdy, :svendy, :svupdes

  def initialize(studyid: nil, domain: nil, usubjid: nil, visitnum: nil, visit: nil, visitdy: nil,
                svstdtc: nil, svendtc: nil, svstdy: nil, svendy: nil, svupdes: nil)
    local_variables.each do |k|
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    domain = self.class.to_s[-2..-1].upcase # last two letters of this class name to give the domain value
  end

  # Required variables
  validates_presence_of :studyid, :domain, :usubjid, :visitnum
  
end