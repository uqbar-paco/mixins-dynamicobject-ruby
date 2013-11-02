require 'rspec'

class MyOpenStructMissing

  def initialize
    @values={}
  end

  def method_missing(name,*args)
    if name.to_s.end_with?('=')
      self.assign_value(name,args[0])
    else
      @values[name]
    end
  end

  def assign_value(name,value)
    @values[name.to_s[0..-2].to_sym]=value
  end
end

describe 'Probar MyOpenStructMissing' do

  before do
    @my_open_struct=MyOpenStructMissing.new
  end

  it 'Probar seteto y obtener de valor' do
    @my_open_struct.x=3
    @my_open_struct.x.should.equal? 3
  end

  it 'Probar multiples seteos' do
    @my_open_struct.saraza='bleh'
    @my_open_struct.algo_mas=4

    @my_open_struct.saraza.should== 'bleh'
    @my_open_struct.algo_mas.should== 4
  end

end