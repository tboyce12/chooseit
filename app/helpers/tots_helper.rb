module TotsHelper
  def a_url(tot, size)
    if tot.a_image_file_name
      return size == 'thumb' ? tot.a_image.url(:thumb) : tot.a_image.url(:medium)
    else
      return tot.a_url unless !tot.a_url || tot.a_url.empty?
      return 'http://choose_it_public.s3.amazonaws.com/assets/root.png'
    end
  end
  
  def b_url(tot, size)
    if tot.b_image_file_name
      return size == 'thumb' ? tot.b_image.url(:thumb) : tot.b_image.url(:medium)
    else
      return tot.b_url unless !tot.b_url || tot.b_url.empty?
      return 'http://choose_it_public.s3.amazonaws.com/assets/root.png'
    end
  end
end
