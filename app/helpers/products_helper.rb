module ProductsHelper
  def tweet_link(product, klass)
    product_url = u (view_product_url(product))
    text = u "#{product.name}: #{product.description}"
    via = "feriadestartups #{product.mentions}"
    tweet_link = "https://twitter.com/intent/tweet?url=#{product_url}&text=#{text}&via=#{via}"
    link_to "Tweet", tweet_link, class: klass+'tweet_link'
  end
  
end
