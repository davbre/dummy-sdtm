
# Use this to create a new data set with variables added from DM
def gen_add_dm(study,dm,inputDs,addVariableArray) # mean = mean number of AEs

  # take a deep copy of the input data set. Otherwise we will end up overwriting
  # its nested objects. Using Marshal load and dump as per:
  #   http://stackoverflow.com/questions/8206523/how-to-create-a-deep-copy-of-an-object-in-ruby
  # Not the fastest, but seems ok for our purpose
  outputDs = Marshal.load(Marshal.dump(inputDs))

  addVariableArray.each do |v|
    outputDs.meta[v] = "--> No info added by gen_add_dm method <--"
  end

  outputDs.rows.each do |usubjid,sbj_rows|
    # dynamically set instance variables: http://stackoverflow.com/questions/6741567/ruby-metaprogramming-dynamic-instance-variable-names
    sbj_rows.each do |row|
      addVariableArray.each do |var|
        row.instance_variable_set("@#{var}", dm.rows[usubjid].send("#{var}"))
        row.create_attr("#{var}")
      end
    end

  end

 outputDs
end