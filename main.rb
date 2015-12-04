require 'dxruby'
require './game'
require './view'
require './controller'

BLACK = [0,0,0]
RED = [255,0,0]
YELLOW = [255,255,0]
CHEESE = [255,240,0]
GRAY = [90,90,90]
O_BLACK = [10,10,30]
DARK_BLUE = [25,25,230]
WHITE = [255,255,255]
CREAM = [255,240,210]
BAKED = [255,210,140]
BROWN = [230,70,70]
GREEN = [0,255,0]

FRAME = 15
MENU_X = 240
MENU_Y = [360,392,424]
MENU_TEXT = ["START","RANKING","EXIT"]
PIZZA_X = 200
PIZZA_Y = 200


Font12 = Font.new(12)
Font16 = Font.new(16)
Font20 = Font.new(20)
Font32 = Font.new(32)
Font60 = Font.new(60)
Font120 = Font.new(120)

Window.height = 480
Window.width = 640

game = Game.new
controller = Controller.new(game)
view = View.new(game,controller)

Window.loop do

  controller.input
  view.draw
  game.clock if(game.status == :game)
  if(game.status == :next)
    game = Game.new
    controller = Controller.new(game)
    view = View.new(game,controller)
  end
end