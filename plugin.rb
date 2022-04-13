# frozen_string_literal: true

# name: test-tagger
# about: Add an "unhandled" tag to every topic where non-staff post
# version: 0.1
# authors: Sam Saffron, Renee Sullivan

# other files used:
# config/settings.yml: defines the 'unhandled' tag.
# spec/plugin_spec.rb: just a test?
# config/locales/client.en.yml: related to a button
# assets/javascripts/connectors... related to a button I don't need

# to do: change from post_created to topic_created


after_initialize do
  DiscourseEvent.on(:topic_created) do |topic, _, user|
    next if SiteSetting.test_tag.blank?
    #next if user.staff?
    next if topic.private_message?



# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# add tags for demographic fields.

    #demographicFields = ["Sex", "Sexual Orientation", "Transition History", "Generation"]
    demographicFields = ["Sex"]

    demographicFields.each do |x|

      logging = "start-"

      user_field = UserField.find_by_name("Sex")

      if user_field == nil
        logging = logging + "userfield-is-nil-"
      else

        if user_field.name == nil
          logging = logging + "userfield-name-is-nil-"
        else
          logging = logging + "userfield-name-not-nil-"
          #logging = logging + "userfield-name-is-" + user_field.name
        end

        if user_field.id == nil
          logging = logging + "userfield-id-is-nil-"
        else
          logging = logging + "userfield-id-not-nil-"
          logging = logging + "userfield-id-is-" + user_field.id.to_s

          custom_field_name = "user_field_" + user_field.id.to_s

          tag_text = user.custom_fields[custom_field_name]
        end

      end

      tag_text = tag_text.downcase
      tag_text = tag_text.sub(" ","-")

      tag = Tag.find_or_create_by!(name: tag_text)

      # if the topic does not already contain this tag, add the tag.
      ActiveRecord::Base.transaction do
        if !topic.tags.pluck(:id).include?(tag.id)
          topic.tags.reload
          topic.tags << tag
          topic.save
        end
      end # end ActiveRecord::Base.transaction do

    end # end iteration through array of demographic fields

  end # end on(topic_created)
end # end after_initialize
