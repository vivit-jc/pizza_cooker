class Controller
  attr_reader :x,:y,:mx,:my

  def initialize(game)
    @game = game
  end

  def input
    @mx = Input.mousePosX
    @my = Input.mousePosY
    if Input.mouse_push?( M_LBUTTON )
      case @game.status
      when :title
        @game.start if(pos_menu == 0)
        @game.rank_start if(pos_menu == 1)
        exit if(pos_menu == 2)
      when :game
        @game.click
      when :ranking
        @game.go_title if(pos_return)
      when :end
        @game.next if(pos_return)
      end
    end
    if(Input.key_push?(K_SPACE))
      case @game.status
      when :game
        @game.toggle_pause
      end
    end
    if(Input.key_push?(K_ESCAPE))
      exit
    end
  end

  def pos_menu
    3.times do |i|
      return i if(mcheck(MENU_X, MENU_X+Font32.get_width(MENU_TEXT[i]), MENU_Y[i], MENU_Y[i]+32))
    end
    return -1
  end

  def pos_return
    mcheck(250,250+Font20.get_width("戻る"),400,420)
  end

  def mcheck(x1,x2,y1,y2)
    x1 < @mx && x2 > @mx && y1 < @my && y2 > @my
  end
end