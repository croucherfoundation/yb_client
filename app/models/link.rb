class Link
  include Her::JsonApi::Model
  use_api YB
  collection_path "/api/admin/person_pages/links"

  belongs_to :person_page

  def self.new_with_defaults(attributes={})
    link = Link.new({
      position: nil,
      url: nil,
      person_page_id: nil,
      platform: nil,
      name: nil,
      destination: nil,
      private: nil
    }.merge(attributes))

  end

  def self.create_or_update(person_page_id, params)
    params = params.to_h unless params == {}
    link_params ={link: params}
    post "/api/admin/person_pages/#{person_page_id}/create_or_update_links", link_params
  end

end