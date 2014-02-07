class Dessert
#different with attr, attr_accessor
  attr_accessor :name
  attr_accessor :calories

  def initialize(name, calories)
    # your code here
    @name = name 
    @calories = calories
  end
  def healthy?
    # your code here
    if @calories <= 200
      return true
    end
    return false
  end

  def delicious?
    # your code here
    return true
  end
end

class JellyBean < Dessert

  def initialize(flavor)
    # your code here
    @flavor = flavor
    @name = @flavor + " jelly bean"
    @calories = 5  
  end

  def flavor 
    #define getter
    @flavor
  end

  def flavor=(flavor)
    #define setter
    @flavor = flavor
  end

  def delicious?
    if @flavor == "licorice"
      return false
    end
    return true
  end

end
