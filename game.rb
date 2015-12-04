class Game

require './pizza'

attr_accessor :status
attr_reader :pizza, :cooking_status, :deg, :baking, :topping_no, :new_rank, :ranking

  def initialize
    @status = :title
    @cooking_status
    @pizza = Pizza.new
    @deg = 0
    @topping_no = 0
    @fire = 0
    @baking = false
    @ranking = load_ranking
  end

  def start
    @status = :game
    @cooking_status = :rolling_out
  end

  def topping
    @pizza.toppings[@topping_no] = [360-@deg,[:p,:s,:o].shuffle].flatten if @topping_no < 6
    @topping_no += 1
    @cooking_status = :baking if(@topping_no == 7)
  end

  def click
    case @cooking_status
    when :rolling_out
      @cooking_status = :rolling_out_d
    when :rolling_out_d
      @pizza.cheese = []
      200.times do
        @pizza.cheese.push [rand(360),rand(@pizza.radius*0.9)]
      end
      @cooking_status = :topping
    when :topping
      topping
    when :baking
      if @baking
        @cooking_status = :finish
        @pizza.fire = @fire
        ending
      end
      @baking = true unless @baking
    when :finish
      @status = :next
    end
  end

  def clock
    if @cooking_status == :rolling_out
      @pizza.rolling_out
    elsif @cooking_status == :topping && @topping_no < 6
      @deg = (@deg+2)%360
    elsif @cooking_status == :baking && @baking
      @fire += 1
    end
  end

  def go_title
    @status = :title
  end

  def rank_start
    @status = :ranking
  end

  def load_ranking
    File.open("rank.dat","w"){} unless(File.exist?("rank.dat"))
    array = []
    open("rank.dat") do |f|
      while l = f.gets
        array.push l.to_f
      end
    end
    array
  end

  def save_ranking
    File.open("rank.dat","w") do |f|
      @ranking.each{|r| f.write(r.to_s+"\n")}
    end
  end

  def ending
    score = @pizza.score[3]
    @ranking.push score
    del = @ranking.sort.reverse.pop if(@ranking.size > 5)
    @new_rank = true if(del != score)
    @score = @pizza.score
    @ranking = @ranking.sort!.reverse![0..4]
    save_ranking
  end

end