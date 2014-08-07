module ApplicationHelper
  
  def randomized_background_color
    colors = ["#f95dae", "#5db9f8", "#f16565", "#6cc884", "#40d6d5", "#ff9b3d",
              "#af5dce", "#f4e265", "#6584ca", "#f55952"]
    colors[rand(colors.size)]
  end
  
end
 