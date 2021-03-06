module InstitutionsHelper
  
  def formatted_institution_name(institution)
    return unless institution
    if institution.name.include?("\s") or institution.name.include?(".")
      institution.name.titleize
    else
      institution.name
    end
  end
end
