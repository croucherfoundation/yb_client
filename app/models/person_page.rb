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
      invite_me: false,
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

  def awarded?
    awarded_at.present?
  end


  # Invitations to the yearbook are sent when a scholar receives their first award.
  #
  def invited?
    invited_at.present?
  end

  def inviting?
    !accepted? && !!invite_me
  end

  def should_be_invited?
    awarded? && !invited? && !inviting?
  end

  def invited_date
    DateTime.parse(invited_at) if invited_at.present?
  end

  def accepted?
    accepted_at.present?
  end

  def accepted_date
    DateTime.parse(accepted_at).in_time_zone(Rails.application.config.time_zone) if accepted_at.present?
  end


  # Reinvitations are sent when an existing scholar receives a new award.
  #
  def reinvited?
    invited? && accepted? && invited_at > accepted_at
  end

  def reinviting?
    accepted? && !!invite_me
  end

  def should_be_reinvited?
    accepted? && awarded? && !inviting? && awarded_at > accepted_at
  end



  def published?
    published_at.present?
  end

  def published_since_invitation?
    published? && invited? && published_at > invited_at
  end

  def published_date
    DateTime.parse(published_at).in_time_zone(Rails.application.config.time_zone) if published_at.present?
  end

end

