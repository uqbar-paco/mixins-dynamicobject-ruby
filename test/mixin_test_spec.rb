module DynamicObject

  def values
    @values ||= {}
  end

  def method_missing(name, *args)
    if name.to_s.end_with?('=')
      self.assign_value(name.to_s[0..-2].to_sym, args[0])
    else
      values[name]
    end
  end

  def assign_value(name, value)
    values[name]=value
  end

end

module Observable

  def add_listener(event, listener)
    listeners(event).push(listener)
  end

  def trigger(event, *args)
    listeners(event).each { |a_listener|
      a_listener.notify(event, args)
    }
  end

  def remove_listener(event, listener)
    listeners(event).pop(listener)
  end

  def __listeners
    @listeners ||= {}
  end

  def listeners(event)
    __listeners[event] ||= []
  end
end


class Model
  include DynamicObject
  include Observable

  def assign_value(name, value)
    super
    self.trigger(name, value)
  end

end

require 'rspec'


describe 'testeando observable' do

  before do
    class TestListener
      def initialize(output)
        @output = output
      end

      def notify(event, args)
        @output.push({"event" => event, "args" => args})
      end
    end

  end

  it 'observable dispara evento' do
    class Observado
      include Observable
    end

    a = Observado.new

    output = []

    a.add_listener("evento", TestListener.new(output))

    a.trigger("evento", "parametros")

    output.should== [{"event" => "evento", "args" => ["parametros"]}]

  end

end

describe 'testeando modelo' do
  it 'modelo dispara evento al setear valor' do
    a = Model.new

    output = []

    a.add_listener(:saraza, TestListener.new(output))

    a.saraza = "sarlompa"

    output.should== [{"event" => :saraza, "args" => ["sarlompa"]}]
  end
end