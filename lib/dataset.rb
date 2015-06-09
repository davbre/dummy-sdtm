class Dataset
  include ActiveModel::Validations

  attr_accessor :name, :meta, :rows

  def initialize(name)
    @name = name
    @meta = {}
    @rows = {}
  end

  validates_presence_of :name

  def add(key, rows)
    @rows[key] = rows
    update_meta(rows)
  end

  def sort
    @rows = @rows.sort.to_h
  end

  def write_csv(outfile)
    variables_present = @meta.keys
    CSV.open(outfile, "wb", force_quotes: true) do |csv|
      csv << variables_present

      @rows.each do |key,value|
        objarr = value.is_a?(Array) ? value : [value]
        objarr.each do |obj|
          csvrow = []
          variables_present.each do |ovar|
            csvrow << (obj.send(ovar).nil? ? " " : obj.send(ovar))
          end
          csv << csvrow
        end
      end

    end
  end

  private
  def update_meta(rows)
    rowarr = rows.is_a?(Array) ? rows : [rows]
    rowarr.each do |rowobj|
      datavars = rowobj.instance_variables - [:@errors, :@validation_context]
      datavars.each do |iv|
        varname = iv.to_s.tr("@","")
         @meta[varname] = @meta.has_key?(varname) ? @meta[varname] += 1 : @meta[varname] = 1        
#        dataset[:meta][varname] = dataset[:meta].has_key?(varname)  ? dataset[:meta][varname] += 1 : dataset[:meta][varname] = 1
      end
    end
  end

end