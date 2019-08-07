class PersonPage
  include Her::JsonApi::Model
  use_api YB
  collection_path "/api/admin/person_pages"

  # temporary while we are not yet sending jsonapi data back to core properly
  include_root_in_json true
  parse_root_in_json false

  def self.new_with_defaults(attributes={})
    person_page = PersonPage.new({
      person_uid: nil,
      send_invitation: false,
      send_reminder: false,
      featured: false,
      featured_at: nil,
      blacklisted: false,
      invited_at: nil,
      reminded_at: nil,
      accepted_at: nil,
      slug: ""
    }.merge(attributes))
    person_page
  end

  def new_record?
    id.nil?
  end

  def featured_date
    DateTime.parse(featured_at)
  end

  def invited?
    !invited_at.nil?
  end

  def invitable?
    person.invitable?
  end

  def invited_date
    DateTime.parse(invited_at) if invited_at.present?
  end

  def accepted?
    !accepted_at.nil?
  end

  def accepted_date
    DateTime.parse(accepted_at).in_time_zone(Rails.application.config.time_zone) if accepted_at.present?
  end

  def reminded?
    !reminded_at.nil?
  end

  def remindable?
    invited? && !accepted?
  end

  def reminded_date
    DateTime.parse(reminded_at).in_time_zone(Rails.application.config.time_zone) if reminded_at.present?
  end

  def published?
    published_at.present?
  end

  def published_date
    DateTime.parse(published_at).in_time_zone(Rails.application.config.time_zone) if published_at.present?
  end

  def reminded_to_publish?
    !reminded_to_publish_at.nil?
  end

  def remindable_to_publish?
    invited? && user && user.confirmed?
  end

  def reminded_to_publish_date
    DateTime.parse(reminded_to_publish_at).in_time_zone(Rails.application.config.time_zone) if reminded_to_publish_at.present?
  end

end

