module TotsHelper
  def a_url(tot, size)
    if tot.a_image_file_name
      return size == 'thumb' ? tot.a_image.url(:thumb) : tot.a_image.url(:medium)
    else
      return tot.a_url
    end
  end
  
  def b_url(tot, size)
    if tot.b_image_file_name
      return size == 'thumb' ? tot.b_image.url(:thumb) : tot.b_image.url(:medium)
    else
      return tot.b_url
    end
  end
end
