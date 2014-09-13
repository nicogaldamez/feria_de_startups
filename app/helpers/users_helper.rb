module UsersHelper
  
  def twitter_profile_link(username)
    link_to username, "http://twitter.com/#{username}", target: '_blank'
  end
end
