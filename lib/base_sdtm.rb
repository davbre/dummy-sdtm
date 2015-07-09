
class BaseSdtm

  include ActiveModel::Validations

  def write_csv
    
  end

  # methods for creating attr_accessor variables on the fly
  # http://stackoverflow.com/questions/4082665/dynamically-create-class-attributes-with-attr-accessor
  def create_method( name, &block )
    self.class.send( :define_method, name, &block )
  end

  def create_attr( name )
    create_method( "#{name}=".to_sym ) { |val| 
      instance_variable_set( "@" + name, val)
    }

    create_method( name.to_sym ) { 
      instance_variable_get( "@" + name ) 
    }
  end  

end