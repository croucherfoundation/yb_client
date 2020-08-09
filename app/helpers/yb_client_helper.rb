module YbClientHelper

  def yb_url(path)
    URI.join(yb_host, path).to_s
  end

  def yb_host
    ENV['YB_URL']
  end

end
