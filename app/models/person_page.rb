class PersonPage
  include Her::JsonApi::Model
  use_api YB
  collection_path "/api/admin/person_pages"
  custom_post :invite, :remind

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
      invitable: false,
      reminded_at: nil,
      accepted_at: nil,
      slug: ""
    }.merge(attributes))
    person_page
  end

  def self.for_person(person_uid)
    person_uid = person_uid.uid if person_uid.respond_to?(:uid)
    where(person_uid: person_uid).first
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


  def created_date
    DateTime.parse(created_at) if created_at.present?
  end

  def updated_date
    DateTime.parse(updated_at) if updated_at.present?
  end



  # Invitations to the yearbook are sent when a scholar is issued with their first award.
  # This is apparent because the Person record gives its issued_at date to the PersonPage.awarded_at value.
  # If awarded_at is set and invited_at is not, then we start inviting. If awarded_at > invited_at, we reinvite.
  #
  def invite!
    self.class.post("/api/admin/person_pages/#{self.id}/invite")
  end

  def invited?
    invited_at.present?
  end

  def invitable?
    awarded?
  end

  def inviting?
    awarded? && !invited?
  end

  def invited_date
    DateTime.parse(invited_at) if invited_at.present?
  end


  def remind!
    self.class.post("/api/admin/person_pages/#{self.id}/remind")
  end

  def reminded?
    reminded_at.present?
  end

  def reminded_date
    DateTime.parse(reminded_at) if reminded_at.present?
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
    accepted? && awarded? && awarded_at > accepted_at
  end



  def published?
    published_at.present?
  end

  def published_since_invitation?
    published? && invited? && published_at > invited_at
  end

  def out_of_date?
    published? && invited? && published_at < awarded_at
  end

  def published_date
    DateTime.parse(published_at).in_time_zone(Rails.application.config.time_zone) if published_at.present?
  end

  def publication_status
    if published_at.present?
      if !awarded_at.present? || DateTime.parse(published_at) > DateTime.parse(awarded_at)
        "published"
      else
        "outofdate"
      end
    elsif accepted_at.present?
      "accepted"
    elsif reminded_at.present?
      "reminded"
    elsif invited_at.present?
      "invited"
    elsif !invitable?
      "uninvitable"
    else
      "uninvited"
    end
  end

  def reindex
    self.class.post("/api/admin/person_pages/#{self.id}/reindex")
  end

  # Other reminders

  def remind_to_update!
    self.class.post("/api/admin/person_pages/#{self.id}/rtu")
  end

  def reminded_to_update?
    rtu_at.present?
  end

  def rtu_date
    DateTime.parse(rtu_at).in_time_zone(Rails.application.config.time_zone) if rtu_at.present?
  end

  def remind_to_publish!
    self.class.post("/api/admin/person_pages/#{self.id}/rtp")
  end

  def reminded_to_publish?
    rtp_at.present?
  end

  def rtp_date
    DateTime.parse(rtp_at).in_time_zone(Rails.application.config.time_zone) if rtp_at.present?
  end

end

