class UpdateClusters

  def initialize(collected_ink)
    self.collected_ink = collected_ink
  end

  def perform
    similar = find_similar
    brand_id = update_brand_clusters(similar)
    update_ink_cluster(similar, brand_id)
  end

  private

  THRESHOLD = 2

  attr_accessor :collected_ink

  def find_similar
    cis = by_similarity(brand: simplified_brand_name, ink: simplified_ink_name)
    cis = cis.or(by_similarity(line: simplified_brand_name, ink: simplified_ink_name))
    cis = cis.or(by_similarity(brand: simplified_line_name, ink: simplified_ink_name))
    cis = cis.or(by_combined_similarity)
    cis.distinct
  end

  def by_combined_similarity
    value = [simplified_brand_name, simplified_line_name, simplified_ink_name].join
    CollectedInk.where(
      "levenshtein_less_equal(CONCAT(simplified_brand_name, simplified_line_name, simplified_ink_name), ?, ?) <= ?",
      value, THRESHOLD, THRESHOLD
    )
  end

  def by_similarity(opts)
    rel = CollectedInk
    opts.each do |field, value|
      rel = rel.where(
        "levenshtein_less_equal(simplified_#{field}_name, ?, ?) <= ?",
        value, THRESHOLD, THRESHOLD
      )
    end
    rel
  end

  def update_brand_clusters(cis)
    ink_brand_id = cis.pluck(:ink_brand_id).compact.first
    unless ink_brand_id
      ink_brand = InkBrand.where(
        "levenshtein_less_equal(simplified_name, ?, ?) <= ?",
        simplified_brand_name, THRESHOLD, THRESHOLD
      ).first
      ink_brand ||= InkBrand.find_or_create_by(simplified_name: simplified_brand_name)
      ink_brand_id = ink_brand.id
    end
    cis.update_all(ink_brand_id: ink_brand_id)
    ink_brand_id
  end

  def update_ink_cluster(cis, brand_id)
    new_ink_name_id = cis.pluck(:new_ink_name_id).compact.first
    unless new_ink_name_id
      new_ink_name_id = NewInkName.create!(
        simplified_name: simplified_ink_name,
        ink_brand_id: brand_id
      ).id
    end
    cis.update_all(new_ink_name_id: new_ink_name_id)
  end

  def simplified_brand_name
    collected_ink.simplified_brand_name
  end

  def simplified_line_name
    collected_ink.simplified_line_name
  end

  def simplified_ink_name
    collected_ink.simplified_ink_name
  end
end
