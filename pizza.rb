class Pizza

attr_reader :radius
attr_accessor :toppings, :cheese, :fire

  def initialize
    @radius = 10
    @toppings = [nil,nil,nil,nil,nil,nil]
    @bigger = true
    @cheese
    @fire
  end

  def rolling_out
    if @bigger
      @radius += 5
    else
      @radius -= 5
    end
    @bigger = true if @radius < 40
    @bigger = false if @radius > 170
  end

  def score
    size = 100 - (@radius - 140).abs
    @toppings.sort!
    topping = 0
    5.times do |i|
      dt = @toppings[i+1][0] - @toppings[i][0]
      score_one = 50 - (60 - dt).abs
      topping += score_one if score_one > 0
    end
    topping /= 2.5
    fire = 100 - (@fire - 600).abs*0.5
    size = 0 if size < 0
    fire = 0 if fire < 0
    [size,topping,fire,size+topping+fire]
  end

end