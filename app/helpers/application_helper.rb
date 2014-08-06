module ApplicationHelper
  
  def randomized_background_color
    colors = ["#fd548a", "#54a9fd", "#E2BDA7", "#fda754", "#fc54f3",
              "#545bfd", "#6bde6b", "#D98C9C", "#6FCEB9",
              "#BFBF45", "#FF9B3D", "#8ADCFF"]
    colors[rand(colors.size)]
  end
  
end
 