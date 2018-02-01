require 'rubygems'
require 'sinatra/base'
require 'faye/websocket'
require 'rpi_gpio'


class SmartDesk < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    RPi::GPIO.set_numbering :bcm
    RPi::GPIO.setup 17, :as => :output, :initialize => :high
    RPi::GPIO.setup 27, :as => :output, :initialize => :high
    set :up_pin, 17
    set :down_pin 27
  end

  get '/' do
    if Faye::WebSocket.websocket?(request.env)
      ws = Faye::WebSocket.new(request.env)

      ws.on(:open) do |event|

      end

      ws.on(:message) do |msg|
        p msg.data
        move_desk msg.data
      end

      ws.on(:close) do |event|

      end

      ws.rack_response
    else
      erb :index
    end
  end

  def move_desk msg
    direction, value = msg.split
    if direction == 'up'
      if value == 'start'
        RPi::GPIO.set_low settings.up_pin
      else
        RPi::GPIO.set_high settings.up_pin
      end
    else
      if value == 'start'
        RPi::GPIO.set_low settings.down_pin
      else
        RPi::GPIO.set_high settings.down_pin
      end
    end
  end

  run! if app_file == $0
end
