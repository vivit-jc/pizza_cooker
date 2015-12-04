class View

  def initialize(game,controller)
    @game = game
    @controller = controller
    @pizza = Image.load("pizza.jpg")
    @furnace = Image.load("furnace_240.jpg")
  end

  def draw
    case @game.status
    when :title
      draw_title
    when :game
      draw_game
    when :ranking
      draw_ranking
    end
  end

  def draw_title
    Window.draw(0,0,@pizza)
    Window.drawFont(70, 10, "PIZZA", Font120, {color: O_BLACK})
    Window.drawFont(70, 140, "COOKER", Font120, {color: O_BLACK})
    
    MENU_TEXT.each_with_index do |menu,i|
      fonthash = {color: O_BLACK}
      fonthash = {color: DARK_BLUE} if(@controller.pos_menu == i)
      Window.drawFont(MENU_X,MENU_Y[i],menu,Font32,fonthash)
    end
  end

  def draw_game
    case @game.cooking_status
    when :rolling_out
      str = "クリックで生地の大きさを決める　円と一致するように"
    when :rolling_out_d
      str = "クリックでピザソースを塗り、チーズを乗せる（自動）"
    when :topping
      str = "クリックで具を乗せる　できるだけ均等に　"+@game.topping_no.to_s+" / 6"
      str = "クリックで窯に入れる" if @game.topping_no == 6
    when :baking
      str = "クリックで燃焼開始　目標：10秒ちょうど"
      str = "燃焼中・・・　クリックで窯から出す" if @game.baking
    when :finish
      str = "できあがり！"
    end
    Window.draw_font(80,400,str,Font16)
    draw_score if @game.cooking_status == :finish

    dough = CREAM
    dough = BAKED if @game.cooking_status == :finish
    Window.draw_circle_fill(PIZZA_X,PIZZA_Y,@game.pizza.radius,dough) if @game.cooking_status != :baking
    Window.draw_circle(PIZZA_X,PIZZA_Y,140,YELLOW) if @game.cooking_status == :rolling_out
    if @game.cooking_status == :topping || @game.cooking_status == :finish
      Window.draw_circle_fill(PIZZA_X,PIZZA_Y,@game.pizza.radius*0.92,RED)
      Window.draw_circle_fill(PIZZA_X,PIZZA_Y,@game.pizza.radius*0.85,CHEESE) if @game.cooking_status == :finish
      draw_topping
      draw_guidelines if @game.cooking_status == :topping
    end
    draw_furnace if @game.cooking_status == :baking
  end

  def draw_topping
    pizza = @game.pizza
    if(@game.cooking_status != :finish)
      pizza.cheese.each do |c|
        Window.draw_circle_fill(PIZZA_X+c[1]*Math.cos(rad(@game.deg+c[0])),PIZZA_Y+c[1]*Math.sin(rad(@game.deg+c[0])),7,CHEESE)
      end
    end
    pizza.toppings.each do |topping|
      next unless topping
      # トッピング1番
      tx1 = PIZZA_X+(pizza.radius*0.72)*Math.cos(rad(@game.deg+topping[0])+Math::PI/12.0)
      ty1 = PIZZA_Y+(pizza.radius*0.72)*Math.sin(rad(@game.deg+topping[0])+Math::PI/12.0)
      draw_topping_one(tx1,ty1,topping[1])
      # トッピング2番
      tx2 = PIZZA_X+(pizza.radius*0.55)*Math.cos(rad(@game.deg+topping[0])-Math::PI/12.0)
      ty2 = PIZZA_Y+(pizza.radius*0.55)*Math.sin(rad(@game.deg+topping[0])-Math::PI/12.0)
      draw_topping_one(tx2,ty2,topping[2])
      # トッピング3番
      tx3 = PIZZA_X+(pizza.radius*0.3)*Math.cos(rad(@game.deg+topping[0]))
      ty3 = PIZZA_Y+(pizza.radius*0.3)*Math.sin(rad(@game.deg+topping[0]))
      draw_topping_one(tx3,ty3,topping[3])
    end
  end

  def draw_topping_one(tx,ty,kind)
    if kind == :p
      Window.draw_circle(tx,ty,tsize(kind),tcolor(kind))
    else
      Window.draw_circle_fill(tx,ty,tsize(kind),tcolor(kind))
    end
  end

  def draw_guidelines
    3.times do |i|
      Window.draw_line(PIZZA_X,PIZZA_Y,PIZZA_X+@game.pizza.radius*Math.cos(rad(@game.deg+120*i)),PIZZA_Y+@game.pizza.radius*Math.sin(rad(@game.deg+120*i)),BLACK)
    end
    Window.draw_line(PIZZA_X,PIZZA_Y,PIZZA_X+@game.pizza.radius,PIZZA_Y,DARK_BLUE)
  end

  def draw_furnace
    Window.draw(80,80,@furnace)
  end

  def draw_ranking
    Window.drawFont(200,40,"RANKING",Font60)
    @game.ranking.each_with_index do |r,i|
      Window.drawFont(250,120+40*i,(i+1).to_s+". "+r.to_s,Font32)
    end
    fonthash = {}
    fonthash = {color: YELLOW} if(@controller.pos_return)
    Window.drawFont(250,400,"戻る",Font20,fonthash)
  end

  def draw_score
    score = @game.pizza.score
    Window.drawFont(400,40,"大きさ "+score[0].to_s,Font16)
    Window.drawFont(400,64,"トッピング "+score[1].to_s,Font16)
    Window.drawFont(400,88,"焼き加減 "+score[2].to_s,Font16)
    Window.drawFont(400,120,"score: "+score[3].to_s,Font16)
    Window.drawFont(400,150,"ハイスコアを更新しました！",Font20,{color: [0,255,0]}) if(@game.new_rank)
    Window.drawFont(400,240,"Thank you for playing！",Font16)
    Window.drawFont(80,430,"クリックでタイトルに戻る",Font16)
  end

  def tsize(s)
    case s
    when :o
      8
    when :s
      18
    when :p
      13
    end
  end

  def tcolor(s)
    case s
    when :o
      BLACK
    when :s
      BROWN
    when :p
      GREEN
    end
  end

  def rad(deg)
    deg * Math::PI / 180.0
  end

end