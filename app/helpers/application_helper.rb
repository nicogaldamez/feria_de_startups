module ApplicationHelper
  
  def randomized_background_color
    colors = ["#B6D98C", "#AFC7E4", "#E2BDA7", "#B3E3E6", "#EDC9ED",
              "#F4E9DD", "#8CB6D9", "#D18075", "#D98C9C", "#6FCEB9",
              "#BFBF45", "#FF9B3D", "#8ADCFF"
            ]
    colors[rand(colors.size)]
  end
  
end
 