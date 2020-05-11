module CustomHelpers
  def edit_page_url(base_url, relative_path)
    "#{base_url}/-/sse/#{encode_path(relative_path)}/"
  end

  def encode_path(relative_path)
    ERB::Util.url_encode("master/source/#{relative_path}")
  end
end
