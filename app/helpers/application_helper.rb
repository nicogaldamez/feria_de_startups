module ApplicationHelper

  # Retorna el título completo
  def full_title()
    base_title = "Feria de Startups"
    if signed_in? && current_user.is_admin?
      "#{base_title} | Admin"
    else
      base_title
    end
  end

  def randomized_background_color
    colors = ["#f95dae", "#5db9f8", "#f16565", "#6cc884", "#40d6d5", "#ff9b3d",
              "#af5dce", "#f4e265", "#6584ca", "#f55952"]
    colors[rand(colors.size)]
  end
  
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
  
  def date_to_text(date)
    date.strftime("%d/%m/%Y") unless date.nil?
  end
  
  def text_to_color(text)
    "<span class='label' style='background: #{text};'> #{text} </span>".html_safe
  end
  
  def icon(name)
    content_tag :i, nil, class: "glyphicon glyphicon-#{name}"
  end

  def icon_left(name, string)
    (content_tag(:i, nil, class: "glyphicon glyphicon-#{name} margin-right-5") + string)
  end

  def icon_right(name, string)
    (string + content_tag(:i, nil, class: "glyphicon glyphicon-#{name} margin-left-5")).html_safe
  end
  
end
 