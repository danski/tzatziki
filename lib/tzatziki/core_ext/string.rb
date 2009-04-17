class String
  
  def liquify(payload)
    return Liquid::Template.parse(self).render(Mash.new(payload))
  end
  
end